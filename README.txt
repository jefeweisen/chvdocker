
# TODO: obtain binary boot2docker_virtualbox.box
#MD5 (boot2docker_virtualbox.box) = 1fdffb3a5d1ba83ec41bd3415be4df27

vagrant box add boot2docker_virtualbox.box --name=boot2docker_virtualbox

# run docker provider:
vagrant up

# get certs from .box:
mkdir -p $HOME/.docker
scp -i ~/.vagrant.d/insecure_private_key -P 2200 -r docker@127.0.0.1:.docker $HOME/.docker/boot2docker

# TODO: get certs from .box as script
# TODO: rebuild .box from source to see if certs different.  checkin certs if unchanged.

# set environment:
export DOCKER_HOST=tcp://127.0.0.1:2376
export DOCKER_CERT_PATH=$HOME/.docker/boot2docker
export DOCKER_TLS_VERIFY=1

# TODO: extract "set environment" into script

# TODO: build source boot2docker_virtualbox.box
git clone git@github.com:mitchellh/boot2docker-vagrant-box.git
cd boot2docker-vagrant-box
vagrant up
vagrant ssh -c 'cd /vagrant && sudo ./build-iso.sh'
vagrant destroy --force
packer build -only=virtualbox-iso template.json
