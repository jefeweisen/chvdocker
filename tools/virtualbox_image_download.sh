#/bin/bash
set -e

curl -L https://github.com/jefeweisen/boot2docker-vagrant-box/releases/download/adhoc_docker_1.6.0/boot2docker_virtualbox_1-6-0.box -o boot2docker_virtualbox_1-6-0.box

vagrant box add boot2docker_virtualbox_1-6-0.box --name=boot2docker_virtualbox_1-6-0
