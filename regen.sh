#!/bin/bash

rm -rf out

# Array of device names
devices=("a52q" "a72q")

# Loop through the devices
for device in "${devices[@]}"
do
    echo "Generating defconfig for $device"
    make ARCH=arm64 O=out vendor/pixelos-"${device}"_defconfig
    cp out/.config "arch/arm64/configs/vendor/pixelos-${device}_defconfig"
    rm -rf out
    echo "Defconfig generated for $device"
    echo ""
done

echo "Defconfig generation completed for all devices."

echo
