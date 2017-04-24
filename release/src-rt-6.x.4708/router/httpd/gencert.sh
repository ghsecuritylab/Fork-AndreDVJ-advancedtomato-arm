#!/bin/sh

# Unix epoch
SECS=1483228799

cd /etc

cp -L openssl.cnf openssl.config

LANIP=$(nvram get lan_ipaddr)
LANHOSTNAME=$(nvram get lan_hostname)

NVCN=`nvram get https_crt_cn`
if [ "$NVCN" == "" ]; then
	NVCN=`nvram get router_name`
fi

I=0
for CN in $NVCN; do
        echo "$I.commonName=CN" >> openssl.config
        echo "$I.commonName_value=$CN" >> openssl.config
        echo "$I.organizationName=O" >> /etc/openssl.config
        echo "$I.organizationName_value=$(uname -o)" >> /etc/openssl.config
        I=$(($I + 1))
done

I=0
# Start of SAN extensions
sed -i "/\[ CA_default \]/acopy_extensions = copy" openssl.config
sed -i "/\[ v3_ca \]/asubjectAltName = @alt_names" openssl.config
sed -i "/\[ v3_req \]/asubjectAltName = @alt_names" openssl.config
echo "[alt_names]" >> openssl.config

# IP
echo "IP.0 = $LANIP" >> openssl.config
echo "DNS.$I = $LANIP" >> openssl.config # For broken clients like IE
I=$(($I + 1))

# hostnames
echo "DNS.$I = $LANHOSTNAME" >> openssl.config
I=$(($I + 1))

# create the key and certificate request
/usr/sbin/openssl req -new -sha256 -out /tmp/cert.csr -config openssl.config -keyout /tmp/privkey.pem -newkey rsa -passout pass:password
# remove the passphrase from the key
/usr/sbin/openssl rsa -in /tmp/privkey.pem -out key.pem -passin pass:password
# convert the certificate request into a signed certificate
/usr/sbin/openssl x509 -in /tmp/cert.csr -out cert.pem -req -signkey key.pem -setstartsecs $SECS -days 3653 -set_serial $1

#	openssl x509 -in /etc/cert.pem -text -noout

# server.pem for WebDav SSL
cat key.pem cert.pem > server.pem

rm -f /tmp/cert.csr /tmp/privkey.pem openssl.config
