# Minimal Kickstart file
install
text
reboot
lang en_US.UTF-8
keyboard us
network --bootproto dhcp
#Choose a saner password here.
rootpw testpasswd
firewall --enabled --ssh
selinux --enforcing
timezone --utc America/New_York
#firstboot --disable
bootloader --location=mbr --append="crashkernel=auto"
zerombr
clearpart --all --initlabel
autopart

#Just core packages
%packages
@core
%end
