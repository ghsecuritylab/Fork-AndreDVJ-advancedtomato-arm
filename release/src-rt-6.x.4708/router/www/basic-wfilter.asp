<!--
Tomato GUI
Copyright (C) 2006-2010 Jonathan Zarate
http://www.polarcloud.com/tomato/

Tomato VLAN GUI
Copyright (C) 2011 Augusto Bott
http://code.google.com/p/tomato-sdhc-vlan/

For use with Tomato Firmware only.
No part of this file may be used without permission.
--><title>Wireless Filter</title>
<content>
	<script type="text/javascript" src="js/wireless.jsx?_http_id=<% nv(http_id); %>"></script>
	<script type="text/javascript">

		//	<% nvram("wl_maclist,macnames"); %>

		var smg = new TomatoGrid();

		smg.verifyFields = function(row, quiet) {
			var f;
			f = fields.getAll(row);

			return v_mac(f[0], quiet) && v_nodelim(f[1], quiet, 'Description', 1);
		}

		smg.resetNewEditor = function() {
			var f, c, n;

			f = fields.getAll(this.newEditor);
			ferror.clearAll(f);

			if ((c = cookie.get('addmac')) != null) {
				cookie.set('addmac', '', 0);
				c = c.split(',');
				if (c.length == 2) {
					f[0].value = c[0];
					f[1].value = c[1];
					return;
				}
			}

			f[0].value = '00:00:00:00:00:00';
			f[1].value = '';
		}

		smg.setup = function() {
			var i, i, m, s, t, n;
			var macs, names;

			this.init('sm-grid', 'sort', 250, [
				{ type: 'text', maxlen: 17 },
				{ type: 'text', maxlen: 48 }
			]);
			this.headerSet(['MAC Address', 'Description']);
			macs = nvram.wl_maclist.split(/\s+/);
			names = nvram.macnames.split('>');
			for (i = 0; i < macs.length; ++i) {
				m = fixMAC(macs[i]);
				if ((m) && (!isMAC0(m))) {
					s = m.replace(/:/g, '');
					t = '';
					for (var j = 0; j < names.length; ++j) {
						n = names[j].split('<');
						if ((n.length == 2) && (n[0] == s)) {
							t = n[1];
							break;
						}
					}
					this.insertData(-1, [m, t]);
				}
			}
			this.sort(0);
			this.showNewEditor();
			this.resetNewEditor();
		}

		function save()
		{
			var fom;
			var d, i, macs, names, ma, na;
			var u;

			if (smg.isEditing()) return;

			fom = E('_fom');

			macs = [];
			names = [];
			d = smg.getAllData();
			for (i = 0; i < d.length; ++i) {
				ma = d[i][0];
				na = d[i][1].replace(/[<>|]/g, '');

				macs.push(ma);
				if (na.length) {
					names.push(ma.replace(/:/g, '') + '<' + na);
				}
			}
			fom.wl_maclist.value = macs.join(' ');
			fom.macnames.value = names.join('>');

			for (i = 0; i < wl_ifaces.length; ++i) {
				u = wl_fface(i);
				E('_wl'+u+'_maclist').value = fom.wl_maclist.value;
			}

			form.submit(fom, 1);
		}

		function earlyInit()
		{
			smg.setup();
		}

		function init()
		{
			smg.recolor();

			var elements = document.getElementsByClassName("new_window");
			for (var i = 0; i < elements.length; i++) if (elements[i].nodeName.toLowerCase()==="a")
				addEvent(elements[i], "click", function(e) { cancelDefaultAction(e); window.open(this,"_blank"); } );
		}
	</script>

	<form id="_fom" method="post" action="tomato.cgi">
		<input type="hidden" name="_nextpage" value="/#basic-wfilter.asp">
		<input type="hidden" name="_nextwait" value="10">
		<input type='hidden' name='_service' value='wireless-restart'>
		<input type='hidden' name='_force_commit' value='1'>
		<input type="hidden" name="wl_maclist">
		<input type="hidden" name="macnames">

		<script type="text/javascript">
			for (var uidx = 0; uidx < wl_ifaces.length; ++uidx) {
				var u = wl_fface(uidx);
				$('#_fom').prepend('<input type=\'hidden\' id=\'_wl'+u+'_maclist\' name=\'wl'+u+'_maclist\'>');
			}
		</script>

		<div class="box">
			<div class="heading">Wireless Filter</div>
			<div class="content">
				<br /><br />
				<table id="sm-grid" class="line-table"></table>
			</div>
		</div>

		<h4>Notes</h4>
		<ul>
			<li>To specify how and on which interface this list should work, use the <a href="#advanced-wlanvifs.asp" class="new_window">Virtual Wireless Interfaces</a> page.</li>
		</ul>

		<button type="button" value="Save" id="save-button" onclick="save()" class="btn btn-primary">Save <i class="icon-check"></i></button>
		<button type="button" value="Cancel" id="cancel-button" onclick="javascript:reloadPage();" class="btn">Cancel <i class="icon-cancel"></i></button>
		<span id="footer-msg" class="alert alert-warning" style="visibility: hidden;"></span>
	</form>

	<script type="text/javascript">earlyInit()</script>
</content>
