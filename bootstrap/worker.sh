#!/bin/bash

# Not the best practice at all, but we need a cluster with worker nodes already attached on dev
echo "[TASK 1] Add sshpass"
apk add sshpass

echo "[TASK 2] Join node to Kubernetes Cluster"
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster1:/joincluster.sh /joincluster.sh 

chmod +x /joincluster.sh

bash /joincluster.sh
