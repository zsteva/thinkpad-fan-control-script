#!/bin/bash

if [ ! -e /sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input ]; then
    echo "missing /sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input" >&2
    exit 1
fi

if [ ! -e /proc/acpi/ibm/fan ]; then
    echo "missing /proc/acpi/ibm/fan" >&2
    exit 1
fi

termscript() {
    test -n $DEBUG && echo "temrscript" >&2
    echo "level auto" > /proc/acpi/ibm/fan
    exit 0
}

trap termscript EXIT TERM INT

while :; do
    T1=$(cat /sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input)
    CURR_LEVEL=$(cat /proc/acpi/ibm/fan | grep level: | sed -e 's/^.*:\s*//')

    if [ $T1 -lt 39000 ]; then
        NEW_LEVEL="4"
    elif [ $T1 -lt 49000 ]; then
        NEW_LEVEL="5"
    elif [ $T1 -lt 59000 ]; then
        NEW_LEVEL="6"
    else
        NEW_LEVEL="7"
    fi

    test -n $DEBUG && echo "T1 $T1 CURR_LEVEL $CURR_LEVEL NEW_LEVEL $NEW_LEVEL" >&2

    if [ "$NEW_LEVEL" != "$CURR_LEVEL" ]; then
        test -n $DEBUG && echo "level $NEW_LEVEL" >&2

        echo "level $NEW_LEVEL" > /proc/acpi/ibm/fan
    fi

    sleep 2
done

exit 0

