# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "base_setup.sh"

  # Kubernetes Master Server
  config.vm.define "master" do |master|
    master.vm.box = "centos/7"
    master.vm.hostname = "master.example.com"
    master.vm.network "private_network", ip: "192.168.48.10"
    master.vm.provider "virtualbox" do |v|
      v.name = "Master"
      v.memory = 2048
      v.cpus = 2
      # Prevent VirtualBox from interfering with host audio stack
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
    master.vm.provision "shell", path: "master.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}" do |node|
      node.vm.box = "centos/7"
      node.vm.hostname = "worker#{i}.example.com"
      node.vm.network "private_network", ip: "192.168.48.1#{i}"
      node.vm.provider "virtualbox" do |v|
        v.name = "Worker#{i}"
        v.memory = 1024
        v.cpus = 1
        # Prevent VirtualBox from interfering with host audio stack
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
      node.vm.provision "shell", path: "worker.sh"
    end
  end

end
