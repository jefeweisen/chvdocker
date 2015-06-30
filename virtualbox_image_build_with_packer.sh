#/bin/bash
#
# see: https://github.com/mitchellh/boot2docker-vagrant-box

git clone https://github.com/jefeweisen/boot2docker-vagrant-box.git -b vary_by_docker_version
pushd boot2docker-vagrant-box
make
make packer-virtualbox
popd
# now have boot2docker_virtualbox_1-6-0.box
vagrant box add boot2docker_virtualbox_1-6-0.box --name=boot2docker_virtualbox_1-6-0
