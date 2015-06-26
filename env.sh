
# usage:
#
# . ./env.sh

C="$HOME/.docker/boot2docker"

errecho () {
    echo "$1" 1>&2
}

if [ ! -e "$C" ]
then
  errecho "could not find docker certificates at: $C"
  errecho ""
  errecho "These certificates are present in the generated chvdocker boot"
  errecho "image.  They can be obtained and placed as:"
  errecho ""
  errecho "mkdir -p $C"
  errecho "scp -i ~/.vagrant.d/insecure_private_key -P 2200 -r docker@127.0.0.1:.docker $C"
else
  # set environment:
  export DOCKER_HOST=tcp://127.0.0.1:2376
  export DOCKER_CERT_PATH="$C"
  export DOCKER_TLS_VERIFY=1
fi


