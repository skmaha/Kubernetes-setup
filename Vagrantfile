# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "k_setup.sh"

  # Kubernetes Master Server
  config.vm.define "master" do |kmaster|
    kmaster.vm.box = "centos/7"
    kmaster.vm.hostname = "master.example.com"
    kmaster.vm.network "private_network", ip: "172.16.16.100"
    kmaster.vm.provider "virtualbox" do |v|
      v.name = "Master"
      v.memory = 2048
      v.cpus = 2
      # Prevent VirtualBox from interfering with host audio stack
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
    kmaster.vm.provision "shell", path: "k_master.sh"
  end

  NodeCount = 2

  # Kubernetes Worker Nodes
  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}" do |workernode|
      workernode.vm.box = "centos/7"
      workernode.vm.hostname = "worker#{i}.example.com"
      workernode.vm.network "private_network", ip: "172.16.16.10#{i}"
      workernode.vm.provider "virtualbox" do |v|
        v.name = "Worker#{i}"
        v.memory = 1024
        v.cpus = 1
        # Prevent VirtualBox from interfering with host audio stack
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
      workernode.vm.provision "shell", path: "k_worker.sh"
    end
  end

end
