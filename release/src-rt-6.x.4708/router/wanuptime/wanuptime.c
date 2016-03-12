#include <stdio.h>
#include <time.h>
#include <sys/sysinfo.h>

int main(int argc, char **argv)
{
    struct sysinfo si;
    time_t uptime;

    if (sysinfo(&si) == -1) {
        return 1;
    }
    if (f_read("/var/lib/misc/wan_time", &uptime, sizeof(time_t)) == sizeof(uptime)) {
        printf("%ld\n", si.uptime - uptime);
    }
    else {
        printf("0\n");
    }

    return 0;
}