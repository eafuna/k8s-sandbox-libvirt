#!/bin/bash

set -e

# exit 1

echo "[TASK 0] Update /etc/hosts file"
start_ip_address=$1

IFS='.';ip=($start_ip_address); unset $IFS;
for (( kmaster=1; kmaster<=$(($2)); kmaster++ ))
do 
    host=$(( ${ip[3]}+kmaster ))
    echo "${ip[0]}.${ip[1]}.${ip[2]}.$host kmaster$kmaster.$4 kmaster$kmaster" >> /etc/hosts
done

for (( kworker=1; kworker<=$(($3)); kworker++ ))
do 
    host=$(( ${ip[3]}+kworker+$2 ))
    echo "${ip[0]}.${ip[1]}.${ip[2]}.$host kworker$kworker.$4 kworker$kworker" >> /etc/hosts
done
cat /etc/hosts

echo "[TASK 1] Setup basic stuff"   
# turn off swap
# add neccessary repositories
cat <<EOF >> /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/v3.17/main
http://dl-cdn.alpinelinux.org/alpine/v3.17/community
#http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
http://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF
# fetch updates
# apk update
cat /etc/fstab 


echo "[TASK 2] Setup kernel/networking"
echo "br_netfilter" > /etc/modules-load.d/k8s.conf
modprobe br_netfilter
echo 1 > /proc/sys/net/ipv4/ip_forward
apk add cni-plugin-flannel
apk add cni-plugins
apk add flannel
apk add flannel-contrib-cni
apk add 'kubelet=~1.28'
apk add 'kubeadm=~1.28'
apk add 'kubectl=~1.28'
apk add containerd
apk add uuidgen
apk add nfs-utils
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
sysctl net.bridge.bridge-nf-call-iptables=1

# fix id error messages
echo "[TASK 3] Add additional services and fix id"
uuidgen > /etc/machine-id
rc-update add containerd || true
rc-update add kubelet || true
rc-update add ntpd || true

# sync time
echo "[TASK 4] sync time and flannel fix"
ln -s /usr/libexec/cni/flannel-amd64 /usr/libexec/cni/flannel || true

# fix prometheus errors
echo "[TASK 5] Setup kernel/networking"
mount --make-rshared /
cat <<EOF > /etc/local.d/sharemetrics.start 
#!/bin/sh
mount --make-rshared
EOF
chmod +x /etc/local.d/sharemetrics.start
rc-update add local

echo "[TASK 6] Set root password"
sed -i 's/PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

rc-service sshd restart

echo "[TASK 6] Set root password"
echo -e "kubeadmin\nkubeadmin" | passwd root 
echo "export TERM=xterm" >> /etc/bash.bashrc

/etc/init.d/ntpd start || true
/etc/init.d/containerd start || true


echo "[....DONE Basic Bootstrap....]"
