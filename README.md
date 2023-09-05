# lightweight-k8s-sandbox

A lightweight K8s environment using [libvirt](https://libvirt.org/) for virtualization, running [Alpine linux](https://www.alpinelinux.org/) distribution.

Here I am merely using [Vagrant (Hasicorp)](https://www.vagrantup.com/) to provision the VM's

> [!IMPORTANT]
> HA Proxy is not yet configured to support multi-master/control-plane. However, I will be updating soon


## Tested on
Host OS Ubuntu 22.04 / Corei7

## Why?
First, I created this because I could not find any resource that use Alpine linux distribution to spin up Kubernetes cluster. The combination of Alpine and libvirt provides a "lightweight" k8s that can run multiple nodes without taking too much compute power. 

Second, I created this to remove all the possible abstraction on the k8s environment and work directly on VM's in order to better understand k8s.

Third, I do not want to spend tons of time configuring k8s when I just wanted to explore other tools in the ecosystem. This provides a convinient way to spin up/down bare k8s.

## What you can do with this?
This can be used to learn [kubernetes (the-hard-way)](https://github.com/kelseyhightower/kubernetes-the-hard-way), or you can use this as development sandbox to explore other tools under the kubernetes ecosystem. 

## How to
Download the requirements (see above for links) then modify the following on the Vagrantfile:
```
MASTER_NODES_COUNT  = 1
WORKER_NODES_COUNT  = 4
```  
> [!IMPORTANT]
> HA Proxy is not yet configured to support multi-master/control-plane. However, I will be updating soon

After this, you can issue the command:
```
Vagrant up --provider libvirt
```
Once vagrant is done, you should expect "runnung" state when you issue:
```
Vagrant status
``` 
Gain ssh access on your nodes using:
```
Vagrant ssh <Node>
```

## Enjoy!