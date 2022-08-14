#!/bin/bash
[[ -f /tmp/cpudata.dat  ]] && cat /dev/null > /tmp/cpudata.dat
time=$(date +%d:%m:%y\-%H:%M:%S)
filename="plot-$time.png"

while true; do
    cpup=$(echo -ne "$(cat <(grep 'cpu ' /proc/stat) \
                <(sleep 1 && grep 'cpu ' /proc/stat) |  \
                awk -v RS="" \
                '{printf "%2.0f",($13-$2+$15-$4)*100/($13-$2+$15-$4+$16-$5)}')")
    ram=$(echo -ne "$(cat /proc/meminfo | \
                awk -v RS="\n\n+" '{printf "%2.0f",($26/$2)*100}')")
    temp=$(echo -ne "$(sed 's/[0-9]\{3\}$//' /sys/class/thermal/thermal_zone1/temp)")
    echo -ne "$(date +%d/%m/%y\ %H:%M:%S) $cpup $ram $temp\n" >> /tmp/cpudata.dat
    $(./plot.pg > $filename)
done
