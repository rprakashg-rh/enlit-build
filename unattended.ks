%pre --log=/var/log/anaconda/pre-install.log --erroronfail
echo "In pre install stage"
%end

lang en_US.UTF-8
keyboard us
timezone America/Los_Angeles --utc
text
clearpart --all --initlabel # Clears all partitions on sda and initializes the disk label
zerombr # Clear the MBR/GPT on all detected disks
part /boot --fstype=ext4 --size=4096 # Creates a /boot partition with ext4 filesystem, 4GB size to accomodate multiple kernels
part pv.01 --size=1 --grow # Create a physical volume for LVM
# Setup LVM
volgroup vg_system pv.01
logvol / --vgname=vg_system --name=lv_root --fstype=xfs --size=20480
logvol /home --vgname=vg_system --name=lv_home --fstype=xfs --size=10240
logvol /vms --vgname=vg_system --name=lv_vms --fstype=xfs --size=20480
logvol swap --vgname=vg_system --name=lv_swap --recommended
network --bootproto=dhcp --activate #auto detect network

%packages
@core
cloud-init
cloud-utils-growpart
%end
reboot --eject

%post --log=/var/log/anaconda/post-install.log --erroronfail
cp /run/install/repo/cloud-init/user-data /mnt/sysroot/var/lib/cloud/seed/nocloud/
cp /run/install/repo/cloud-init/meta-data /mnt/sysroot/var/lib/cloud/seed/nocloud/

# Enable cloud-init services
chroot /mnt/sysroot systemctl enable cloud-init
chroot /mnt/sysroot systemctl enable cloud-config
chroot /mnt/sysroot systemctl enable cloud-final

# workaround for eject media after install (https://access.redhat.com/solutions/5488251)
/usr/bin/eject -i 0
/usr/bin/eject -r
%end