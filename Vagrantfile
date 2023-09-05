# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

VAGRANT_BOX         = "generic/alpine317"
VAGRANT_BOX_VERSION = "4.2.10"

MASTER_NODES_COUNT  = 1
WORKER_NODES_COUNT  = 2
PRIVATE_NETWORK     = "172.16.16.100"

CPUS_MASTER_NODE    = 2
MEMORY_MASTER_NODE  = 2048
CPUS_WORKER_NODE    = 1
MEMORY_WORKER_NODE  = 1024
DOMAIN              = "example.com"


PN_SEG = PRIVATE_NETWORK.split('.')

Vagrant.configure(2) do |config|
  
  # @TODO 
  # Configure HAproxy for multi-master cluster

  config.vm.provision "shell", path: "bootstrap/generic.sh", args: ["#{PRIVATE_NETWORK}","#{MASTER_NODES_COUNT}","#{WORKER_NODES_COUNT}", "#{DOMAIN}"]

  base_address  = "#{PN_SEG[0]}.#{PN_SEG[1]}.#{PN_SEG[2]}."
  host_address  = PN_SEG[3].to_i

  (1..MASTER_NODES_COUNT).each do |i|
    
    config.vm.define "kmaster#{i}" do |node|

      host_address              += 1
      node.vm.box               = VAGRANT_BOX
      node.vm.box_check_update  = false
      node.vm.hostname          = "kmaster#{i}.#{DOMAIN}"
      this_network_addr         = "#{base_address}"+host_address.to_s
      node.vm.network "private_network", ip: "#{this_network_addr}"
    
      node.vm.provider :virtualbox do |v|
        v.name    = "kmaster#{i}"
        v.memory  = MEMORY_MASTER_NODE
        v.cpus    = CPUS_MASTER_NODE
      end
    
      node.vm.provider :libvirt do |v|
        v.memory  = MEMORY_MASTER_NODE
        v.nested  = true
        v.cpus    = CPUS_MASTER_NODE
      end
    
      node.vm.provision "shell", path: "bootstrap/cp.sh"
    
    end

  end

  # Kubernetes Worker Nodes
  (1..WORKER_NODES_COUNT).each do |i|

    config.vm.define "kworker#{i}" do |node|

      host_address              += 1
      node.vm.box               = VAGRANT_BOX
      node.vm.box_check_update  = false
      node.vm.hostname          = "kworker#{i}.#{DOMAIN}"
      this_network_addr         = "#{base_address}"+host_address.to_s
      node.vm.network "private_network", ip: "#{this_network_addr}"

      node.vm.provider :virtualbox do |v|
        v.name    = "kworker#{i}"
        v.memory  = MEMORY_WORKER_NODE
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provider :libvirt do |v|
        v.memory  = MEMORY_WORKER_NODE
        v.nested  = true
        v.cpus    = CPUS_WORKER_NODE
      end

      node.vm.provision "shell", path: "bootstrap/worker.sh"

    end

  end

end

