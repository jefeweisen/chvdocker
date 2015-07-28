# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'
require 'fileutils'

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

def writeFile(afile, stContents)
  fl = File.open(afile, "w")
  fl.write(stContents)
  fl.close()
end

# makeVirtualboxImageStayPut is for allowing us to use "chvdocker" capabilities from any starting
# directory across our physical host.  Normally, this is a dangerous source of non-reproducible state,
# but since all we're doing is hosting docker, it gives us a valuable way to reuse our local docker
# image cache.
#
# I wish vagrant would just let us set the parameters.
#
# https://github.com/mitchellh/vagrant/blob/master/plugins/providers/virtualbox/action/set_name.rb
#
def makeVirtualboxImageStayPut(chvdockerMachine)
  adirVbox = Pathname.new(File.dirname(__FILE__)).join('.vagrant/machines/default/virtualbox')

  machine_name = chvdockerMachine["vm_machine_name"]
  if(machine_name.nil?) then raise "key vm_machine_name is required" end
  uuid = chvdockerMachine["vm_machine_name"]
  if(uuid.nil?) then raise "key vm_uuid is required" end

  FileUtils.mkdir_p(adirVbox)
  writeFile(adirVbox.join("action_set_name"), machine_name)
  writeFile(adirVbox.join("id"), chvdockerMachine["vm_uuid"])
end

vms = chvdocker["vm_default"] ? chvdocker["vm_default"] : []
vm0 = vms[0] ? vms[0] : {}
makeVirtualboxImageStayPut(vm0)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "boot2docker_virtualbox_1-6-0"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

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
    vb.name = chvdocker["vm_friendly_name"]
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Enable provisioning with CFEngine. CFEngine Community packages are
  # automatically installed. For example, configure the host as a
  # policy server and optionally a policy file to run:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.am_policy_hub = true
  #   # cf.run_file = "motd.cf"
  # end
  #
  # You can also configure and bootstrap a client to an existing
  # policy server:
  #
  # config.vm.provision "cfengine" do |cf|
  #   cf.policy_server_address = "10.0.2.15"
  # end

  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file default.pp in the manifests_path directory.
  #
  # config.vm.provision "puppet" do |puppet|
  #   puppet.manifests_path = "manifests"
  #   puppet.manifest_file  = "site.pp"
  # end

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding
  # some recipes and/or roles.
  #
  # config.vm.provision "chef_solo" do |chef|
  #   chef.cookbooks_path = "../my-recipes/cookbooks"
  #   chef.roles_path = "../my-recipes/roles"
  #   chef.data_bags_path = "../my-recipes/data_bags"
  #   chef.add_recipe "mysql"
  #   chef.add_role "web"
  #
  #   # You may also specify custom JSON attributes:
  #   chef.json = { mysql_password: "foo" }
  # end

  # Enable provisioning with chef server, specifying the chef server URL,
  # and the path to the validation key (relative to this Vagrantfile).
  #
  # The Opscode Platform uses HTTPS. Substitute your organization for
  # ORGNAME in the URL and validation key.
  #
  # If you have your own Chef Server, use the appropriate URL, which may be
  # HTTP instead of HTTPS depending on your configuration. Also change the
  # validation key to validation.pem.
  #
  # config.vm.provision "chef_client" do |chef|
  #   chef.chef_server_url = "https://api.opscode.com/organizations/ORGNAME"
  #   chef.validation_key_path = "ORGNAME-validator.pem"
  # end
  #
  # If you're using the Opscode platform, your validator client is
  # ORGNAME-validator, replacing ORGNAME with your organization name.
  #
  # If you have your own Chef Server, the default validation client name is
  # chef-validator, unless you changed the configuration.
  #
  #   chef.validation_client_name = "ORGNAME-validator"
end
