# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "hana.test"

  config.vm.provider "virtualbox" do |v, override|
    v.gui = false
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.vm.network :forwarded_port, guest:80, host:80
  config.vm.network :private_network, type: "dhcp"

  config.vm.provision "shell" do |s|
    s.path = "install.sh"
    s.args = ["lemonldap-ng"]
  end
end
