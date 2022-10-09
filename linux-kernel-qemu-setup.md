# Linux 6.0 kernel building and QEMU setup

## Table of contents

- [Linux 6.0 kernel building and QEMU setup](#linux-60-kernel-building-and-qemu-setup)
  - [Table of contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Building the kernel](#building-the-kernel)
    - [Get kernel sources](#get-kernel-sources)
    - [Generate default configs](#generate-default-configs)
    - [Enable required config options](#enable-required-config-options)
    - [Compile the kernel](#compile-the-kernel)
  - [System image](#system-image)
    - [Create a Debian Stretch Linux image](#create-a-debian-stretch-linux-image)
  - [Run QEMU](#run-qemu)
    - [Run script](#run-script)
    - [Usage](#usage)

## Prerequisites

```
DEPS="git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison qemu-system-x86"
```

Install/update on Ubuntu
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install $DEPS
```

Install/update on an Arch-based distro
```
sudo pacman -Syu $DEPS
```

## Building the kernel

### Get kernel sources

```
mkdir kernel-project
cd kernel-project
git clone git@github.com:Silentsky0/linux.git
cd linux
git checkout 6.0
```

### Generate default configs

```
make defconfig
make kvm_guest.config
```
Kernel configuration has been written to `kernel-project/linux/.config` ,
additional modifications should be made there or by using a GUI config editor
using `make menuconfig`

### Enable required config options

Some kernel config options are required by syzkaller, the very minimum needed
is listed here:

```
# Coverage collection.
CONFIG_KCOV=y

# Debug info for symbolization.
CONFIG_DEBUG_INFO=y

# Memory bug detector
CONFIG_KASAN=y
CONFIG_KASAN_INLINE=y

# Required for Debian Stretch
CONFIG_CONFIGFS_FS=y
CONFIG_SECURITYFS=y
```

Also, these options should be enabled, a rootfs mounting error is thrown
otherwise
```
CONFIG_VIRTIO_BALLOON=y
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_PAGE_REPORTING=y
```

Regenerate config after making changes
```
make olddefconfig
```

### Compile the kernel

```
make -j`nproc`
```

These should be present:
- `vmlinux` (kernel binary) - at `kernel-project/linux/vmlinux`
- `bzImage` (packed kernel image) - at `kernel-project/linux/arch/x86/boot/bzImage`

## System image

### Create a Debian Stretch Linux image

```
mkdir image
cd image
wget https://raw.githubusercontent.com/google/syzkaller/master/tools/create-image.sh -O create-image.sh
chmod +x create-image.sh
./create-image.sh
```

The result should be a `image/stretch.img` disk image

## Run QEMU

### Run script

The easiest way is to create a script which would run QEMU with the generated
kernel image and disk image

Create a `run.sh` script with these contents:

```
qemu-system-x86_64 \
	-m 2G \
	-smp 2 \
	-kernel $LINUX_PATH/arch/x86/boot/bzImage \
	-append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
	-drive file="$LINUX_PATH/image/stretch.img",format=raw \
	-net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
	-net nic,model=e1000 \
	-enable-kvm \
	-nographic \
	-pidfile vm.pid \
	2>&1 | tee vm.log
```

Don't forget to make it executable: `chmod +x run.sh`

### Usage

Exemplary usage:

```
LINUX_PATH=`pwd` ./run.sh
```

`LINUX_PATH` should be a path to the linux source tree location in your host
system, it can be easily set like this: ```LINUX_PATH=`pwd` ``` ,provided that
you are currently in the `linux` directory

To quit QEMU, press `Ctrl+a` and then `x`
