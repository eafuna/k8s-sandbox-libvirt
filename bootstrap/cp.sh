#!/bin/bash

kubeadm config images pull

kubeadm init \
--apiserver-advertise-address=$(/sbin/ifconfig eth1| grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}') \
--pod-network-cidr=10.244.0.0/16 --node-name=$(hostname)

mkdir ~/.kube

ln -s /etc/kubernetes/admin.conf /root/.kube/config 

kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
# kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.18/manifests/calico.yaml

kubeadm token create --print-join-command > /joincluster.sh

mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config || true
