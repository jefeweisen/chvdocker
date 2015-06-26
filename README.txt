
# TODO: obtain binary boot2docker_virtualbox.box
#MD5 (boot2docker_virtualbox.box) = 1fdffb3a5d1ba83ec41bd3415be4df27

vagrant box add boot2docker_virtualbox.box --name=boot2docker_virtualbox

# run docker provider:
vagrant up

# TODO: rebuild .box from source to see if certs different.  checkin certs if unchanged.

# set environment:
. ./env.sh

# TODO: build source boot2docker_virtualbox.box
git clone git@github.com:mitchellh/boot2docker-vagrant-box.git
cd boot2docker-vagrant-box
vagrant up
vagrant ssh -c 'cd /vagrant && sudo ./build-iso.sh'
vagrant destroy --force
packer build -only=virtualbox-iso template.json
