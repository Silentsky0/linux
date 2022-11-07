# WORKING # # # # # # # 
qemu-system-x86_64 \
	-m 2G \
	-smp 1 \
	-kernel ~/kernel-project/linux-6.0/arch/x86/boot/bzImage \
	-append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0 rootfstype=ext4 loglevel=7 init=/bin/sh" \
	-initrd ../kernel-utils/initramfs.cpio.gz \
	-net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
	-net nic,model=e1000 \
	-enable-kvm \
	-nographic




# mknod /dev/tty4 c 4 4 && mknod /dev/tty3 c 4 3 && mknod /dev/tty2 c 4 2

# qemu-system-x86_64 \
# 	-m 2G \
# 	-smp 2 \
# 	-kernel ~/kernel-project/linux-6.0/arch/x86/boot/bzImage \
# 	-append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0 rootfstype=ext4 loglevel=7" \
# 	-drive file="/home/silentsky/kernel-project/linux-6.0/image/stretch.img",format=raw \
# 	-net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
# 	-net nic,model=e1000 \
# 	-enable-kvm \
# 	-nographic \
# 	-pidfile vm.pid \
# 	2>&1 | tee vm.log

# qemu-system-x86_64 \
#         -m 2G \
#         -smp 2 \
#         -kernel $1/arch/x86/boot/bzImage \
#         -hda $2/stretch.img \
#         #-append "root=/dev/sda earlyprintk=serial nokaslr" \
#         -netdev user,id=mynet0,hostfwd=tcp::7722-:22 \
#         -device virtio-net,netdev=mynet0 \
#         -enable-kvm \
#         -pidfile vm.pid \
#         2>&1 | tee vm.log



# sudo qemu-system-x86_64 \
# -m 1024M \
# -hda /var/lib/libvirt/images/DEbian.img \
# -enable-kvm \
# -initrd /home/username/compiled_kernel/initrd.img-3.2.46 \
# -kernel /home/username/compiled_kernel/bzImage \
# -append "root=/dev/sda1 console=ttyS0" \
# -nographic \
# -redir tcp:2222::22 \
# -cpu host \
# -smp cores=2
