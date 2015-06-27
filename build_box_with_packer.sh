#/bin/bash
#
# see: https://github.com/mitchellh/boot2docker-vagrant-box

#git clone git@github.com:mitchellh/boot2docker-vagrant-box.git
#cd boot2docker-vagrant-box
vagrant up
vagrant ssh -c 'cd /vagrant && sudo ./build-iso.sh'
vagrant destroy --force
packer build -only=virtualbox-iso template.json
# now have boot2docker_virtualbox.box
vagrant box add boot2docker_virtualbox.box --name=boot2docker_virtualbox
