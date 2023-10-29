# Raspberry Pi Zero QEMU
Small project for running Raspberry Pi Zero within qemu for development purposes.

# Specification
Raspberry Pi Zero specs are as follows. These are helpful in identifying the right kernel and
dts:

| Type      | Value                                   |
| --------- | --------------------------------------- |
| CPU       | 1-GHZ, Broadcom BCM2835 (ARM1176JZF-S)  |
| RAM       | 512MB                                   |
| Wireless  | 802.11n / Bluetooth 4.1 / LE            |
| Ports     | Micro USB, mini-HDMI                    |
| I/O       | 40 GPIO Pins | CSI Camera Connector     |


# Usage
## Dependencies
I have included the device tree blobs(`DTB`) and kernel image for the Raspberry Pi Zero, which
were obtained from the [Raspberry Pi Foundation GitHub Repository][2].

- Install qemu for arm ([Arch Linux qemu-system-arm][1]).
- Kernel & DTB files from [Raspberry Pi Foundation GitHub Repository][2].
- An image from your favorite linux distro. ([RPi OS][3], [Void Linux][4], etc...)

## Run Qemu
Simply run the [run-qemu.sh](./run-qemu.sh) script passing in the path to the image you'd like to boot.
```sh
$ ./run-qemu.sh ./images/void-rpi-armv6l-20230628.img
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 6.1.58+ (dom@buildbot) (arm-linux-gnueabihf-gcc-8 (Ubuntu/Linaro 8.4.0-3ubuntu1) 8.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #1693 Tue Oct 24 12:12:18 BST 2023
[    0.000000] CPU: ARMv6-compatible processor [410fb767] revision 7 (ARMv7), cr=00c5387d
[    0.000000] CPU: VIPT aliasing data cache, unknown instruction cache
[    0.000000] OF: fdt: Machine model: Raspberry Pi Zero W
...
Welcome to Void!
```


[1]: https://archlinux.org/packages/extra/x86_64/qemu-system-arm/
[2]: https://github.com/raspberrypi/firmware/tree/master/boot
[3]: https://www.raspberrypi.com/software/operating-systems/
[4]: https://repo-default.voidlinux.org/live/current/