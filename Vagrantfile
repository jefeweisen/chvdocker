# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'

#*** BEGIN duplicate in dockerrun.rb
# find and read chvdocker yaml file
$filepathYaml = ENV["CHVDOCKER_YAML"]
$filepathYaml = $filepathYaml ?
  $filepathYaml :
  Pathname.new(File.dirname(__FILE__)).join('chvdocker.yaml')
chvdocker = YAML.load_file($filepathYaml)

def pathGuestFromShare(share)
    Pathname.new(share["guest"]["path"])
end
#*** END duplicate


# Resolve relative paths, with respect to the location of chvdocker.yaml.
# Yes really: not with respect to the location of Vagrantfile.
def filepathFromAbsOrRel(absOrRel)
  if(absOrRel["isRelative"].to_i != 0) then
    adir = Pathname.new(File.dirname($filepathYaml)).join(absOrRel["path"])
  else
    Pathname.new(absOrRel["path"])
  end
end

def pathsFromShare(share)
  guest = pathGuestFromShare(share)
  host = filepathFromAbsOrRel(share["host"])
  [guest,host]
end

# emit a dockerrun.sh script according to vagrant configuration
adir = File.dirname(__FILE__)
fnDockerrunSh = File.join(adir, "tools", "dockerrun.sh")
fnDockerrunRb = File.join(adir, "tools", "dockerrun.rb")
dockerrunSh = File.open(fnDockerrunSh, "w")
dockerrunSh.puts("\#!/bin/bash")
dockerrunSh.write("env CHVDOCKER_YAML='#{$filepathYaml}' '#{Gem.ruby}' '#{fnDockerrunRb}' \"\$@\"")
dockerrunSh.close()


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "boot2docker_virtualbox_1-6-0"

  docker_port = chvdocker["docker_port"]
  docker_port.each do |port|
    config.vm.network "forwarded_port", guest: port["guest"], host: port["host"]
  end

  ports = chvdocker["container_ports"] ? chvdocker["container_ports"] : []
  ports.each do |port|
    config.vm.network "forwarded_port", guest: port["guest"], host: port["host"]
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # If true, then any SSH connections made will enable agent forwarding.
  # Default value: false
  # config.ssh.forward_agent = true

  config.ssh.private_key_path = "./cert/insecure_private_key"

  shares = chvdocker["shares"] ? chvdocker["shares"] : []
  shares.each do |share|
    # Share an additional folder to the guest VM. The first argument is
    # the path on the host to the actual folder. The second argument is
    # the path on the guest to mount the folder. And the optional third
    # argument is a set of non-required options.
    adirGuest, adirHost = pathsFromShare(share)
    config.vm.synced_folder adirHost, adirGuest
  end

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.name = "chvdocker_1-6-0"
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "4096"]
  end
end
