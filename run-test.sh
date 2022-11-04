qemu-system-x86_64 \
	-m 2G \
	-smp 2 \
	-kernel ~/kernel-project/linux/arch/x86/boot/bzImage \
    -initrd ../kernel-utils/initramfs.cpio.gz \
	-append "root=/dev/sda earlyprintk=serial net.ifnames=0" \
    -hda /home/silentsky/kernel-project/linux/image/stretch.img \
	-net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
	-net nic,model=e1000 \
	-enable-kvm \
	-pidfile vm.pid \
	2>&1 | tee vm.log
