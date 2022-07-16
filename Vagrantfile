# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "base_setup.sh"

  # Kubernetes Master Server
  config.vm.define "master" do |master|
    master.vm.box = "jeffnoxon/ubuntu-20.04-arm64"
    master.vm.hostname = "k8smaster.example.com"
    master.vm.network "private_network", ip: "10.37.129.10"
    master.vm.provider "parallels" do |v|
      v.name = "k8sMaster"
      v.memory = 2048
      v.cpus = 2
      # Prevent VirtualBox from interfering with host audio stack
      #v.customize ["modifyvm", :id, "--audio", "none"]
    end
    master.vm.provision "shell", path: "master.sh"
  end

  NodeCount = 1

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}" do |node|
      node.vm.box = "jeffnoxon/ubuntu-20.04-arm64"
      node.vm.hostname = "k8sworker#{i}.example.com"
      node.vm.network "private_network", ip: "10.37.129.1#{i}"
      node.vm.provider "parallels" do |v|
        v.name = "k8sWorker#{i}"
        v.memory = 1024
        v.cpus = 1
        # Prevent VirtualBox from interfering with host audio stack
        #v.customize ["modifyvm", :id, "--audio", "none"]
      end
      node.vm.provision "shell", path: "worker.sh"
    end
  end
end
