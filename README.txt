
# TODO: obtain binary boot2docker_virtualbox.box
#MD5 (boot2docker_virtualbox.box) = 1fdffb3a5d1ba83ec41bd3415be4df27



# run docker provider:
vagrant up

# TODO: rebuild .box from source to see if certs different.  checkin certs if unchanged.

# set environment:
. ./env.sh

# alternative 1:
run against prebuild image: mitchellh/boot2docker

  config.vm.box = "mitchellh/boot2docker"


# alternative 2: build image from source:

  config.vm.box = "boot2docker_virtualbox"

  bash build_box_with_packer.sh
