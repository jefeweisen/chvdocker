# Container Host via Vagrant and (boot2)Docker

## Synopsis

Easy Docker-based Linux development for teams with mixed-OS development PCs.

- Boot2docker (the Linux distribution, not boot2docker-cli the utilities) focuses on being a lightweight "Docker server" (aka container host).
- Virtualbox on OS X and Windows makes it possible to see one operating system from all OSes on developent PCs.
- Virtualbox guest additions provide an efficient Linux VM filesystem device driver for mounting directories from the physical host.

Combined together, these pieces could be a very quick to start single stop solution for docker-based development.  Vagrant provides a way that is both portable and understood by a broad developer base.

## Requirements

- Filesystem and Networking:
    - Share filesystem folders between containers and the physical host
    - Share ports between containers and the physical host
- Configuration:
    - Override all configuration with one environment variable
    - Allow invocation of chvdocker as a git submodule
- VM and container:
    - Provide a docker container host (aka docker server)
    - Share one VM instance between different chvdocker working copies (e.g. from two different git modules consuming chvdocker as a submodule).  Vagrant seeks out to keep each Vagrantfile instance describing a VM unique to that absolute path, for reproducibility.  But since the only state we are recording in the docker container host is the docker image cache, sharing the VM is good.
- Nonfunctional requirements:
    - Run on Mac OS X 10.10
    - Run on Windows 7 and Windows 8
    - Headless installation
    - Traceable upstream OS builds

## Technology choices

- For ongoing operation:
    - Vagrant
    - Virtualbox
    - Virtualbox Guest Extensions for file sharing
    - boot2docker Linux distribution
    - boot2docker image building using packer
- For installation:
    - brew, for installation on OS X
    - chocolatey, for installation on Windows

Upstream repositories helping behind the scenes:
- https://github.com/jefeweisen/boot2docker-vagrant-box - a fork of:
- https://github.com/mitchellh/boot2docker-vagrant-box


# Operation

These instructions presume you want to run chvdocker from its own directory.

(For alternative usage as a submodule, see https://github.com/jefeweisen/dockerpipeline as an example.)

Most functionality is available by running vagrant, just as normal, so long as the current directory is chvdocker:

    vagrant up
    vagrant halt

The directory tools/ contains additional script commands:

- Commands for running docker:

    - dockerrun.sh - runs "docker run" for ad-hoc jobs.
        - dockerrun.rb - helper for dockerrun.sh

- Commands for setting up at each session:

    - . env.sh - Add docker TLS configuration to the current environment.
    - extract_my_docker_certs.sh - a tool for obtaining the docker TLS keys

- Commands for setting up the first time:

    - virtualbox_image_build_with_packer.sh - a tool for building the boot2docker image
    - virtualbox_image_download.sh - a tool for downloading a binary of the boot2docker image build with virtualbox_image_build_with_packer.sh



## Configuration

The environment variable CHVDOCKER_YAML is the global configuration override.  It is an absolute path to a chvdocker.yaml configuration file.  An example configuration file is included at config/chvdocker.yaml, containing:

    ---
    vm_default:
      -
        vm_friendly_name: chvdocker_1-6-0
        vm_machine_name: 1437695885
        vm_uuid: b870f096-23d8-4ddf-9746-d677a9735454
    docker_port:
      -
        host: 2376
        guest: 2376
    container_ports:
      -
        host: 4000
        guest: 4000
    shares:
      -
        host:
          isRelative: 1
          path: chvdocker_data
        guest:
          path: /chvdocker_data

## Installation

Installation support for [Windows](windows/InstallationOnWindows.md).

Installation instructions for [OS X](MacOSX/InstallationOnMacOSX.md).

## FAQ

<b>Q</b>: Doesn't boot2docker already do what chvdocker does?

<b>A</b>: Boot2docker is actually two different things:

1. https://github.com/boot2docker/boot2docker
    - a Linux distribution.
    - 5300 followers and 545 forks on github.
2. https://github.com/boot2docker/boot2docker-cli
    - command line utilites for manipulating Virtualbox.
    - 307 followers and 97 forks.

I've had great experience with boot2docker and very poor experience with boot2docker-cli.  Boot2docker-cli startup, teardown, and VM configuration all seem unreliable compared to how Vagrant+Virtualbox perform by default.  Boot2docker-cli seems to expose an odd subset of capabilities.  Note the lack of shared directory support:

- https://github.com/boot2docker/boot2docker/issues/413
- https://github.com/docker/docker/issues/4023

Think of chvdocker as an "If Vagrant ain't broken, don't fix it" solution.
