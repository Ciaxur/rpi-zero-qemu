#!/usr/bin/env bash
set -e

# Script which emulates a Raspberry Pi Zero within qemu.
# It expects passing in a rootfs image to boot into.

# Move to the parent directory of the running script, since most of
# the filepaths are relative.
FILE_PATH="$(dirname $0)"
cd "$FILE_PATH"

# Paths to the raspberry pi kernel image and device tree blob.
# Of which can be obtained from https://github.com/raspberrypi/firmware/tree/master/boot.
KERNEL_PATH="kernels/kernel.img"
DTB_PATH="dtbs/bcm2708-rpi-zero.dtb"

# The rootfs image for which to boot into.
IMG_PATH="$1"
if [[ "$IMG_PATH" = "" ]] || [[ ! -e $IMG_PATH ]]; then
  echo "Image path $IMG_PATH not found"
  exit 1
fi

# Target machine and CPU BCM2835 ARMv6.
# BCM2835 -> ARM1176JZF-S.
# Can be found using:
#  - `qemu-system-arm -M help`
#  - `qemu-system-arm -cpu help`
TARGET_MACHINE="raspi0"
CPU="arm1176"

# Set Kernel flags.
# Doing an echo here to have a multiline for ease of readability.
CMDLINE=$(echo \
  "root=/dev/mmcblk0p2 rw " \
  "rootwait " \
  "rootfstype=ext4 " \
  "panic=1 " \
  "arm_boost=1 " \
  "initcall_blacklist=bcm2835_pm_driver_init " \
  "dwc_otg.nak_holdoff=0 dwc_otg.fiq_fsm_enable=0 " \
  "dwc_otg.fiq_enable=0 " \
)

# Start emulating!
#
# SMP stands for Symmetric Multiprocessing. Essentially Virtual CPU cores.
#
# In order argument description:
#   - Turn on guest errors debug qemu flag.
#   - Pass in the rpi zero kernel to use.
#   - Exit instead of rebooting.
#   - Path to the device tree blob, which describes the rpi hardware.
#   - Pass in kernel command line args.
#   - Specify the guest machine to emulate, which in our case is the Raspberry Pi Zero.
#   - Specify the cpu model to emulate.
#   - Allocate 512MiB of mem to VM.
#   - Mount image as a raw device.
#   - Specify 1 vcores.
#   - Set keyboard layout to US.
#   - Create an emulated keyboard USB device.
#   - Create a USB network device.
#   - Configure the net0 network device to port forward.
#   - Print serial output to the terminal.
#   - Disable virtualized graphics (optional, comment out).
qemu-system-arm \
  -d guest_errors \
  -kernel "$KERNEL_PATH" \
  -no-reboot \
  -dtb "$DTB_PATH" \
  -append "$CMDLINE" \
  -M "$TARGET_MACHINE" \
  -cpu "$CPU" \
  -m 512M \
  -drive "file=$IMG_PATH,format=raw,index=0,media=disk" \
  -smp 1 \
  -k en-us \
  -device usb-kbd \
  -device usb-net,netdev=net0 \
  -netdev user,id=net0,hostfwd=tcp::2022-:22 \
  -serial stdio
  #-nographic

