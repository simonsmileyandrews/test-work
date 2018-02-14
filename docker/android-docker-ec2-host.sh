#!/bin/bash
#
# Description: 
# This is the script you must run in order to build the docker file
# This should be on run on the host of the docker file.
# Usage: ./android-docker-ec2-host.sh -r
# This script relies on md5 being installed. 
################################################################################

################################################################################
# Constants
################################################################################

REGISTRY="registry.omdev.io"
REGISTRY_PORT="443"
IMAGE_BASE_NAME="om-project-kotlin"
IMAGE_NAME="${REGISTRY}:${REGISTRY_PORT}/${IMAGE_BASE_NAME}"
OMSCRIPTS="git@bitbucket.org:outware/omscripts.git"
OMSCRIPTS_FOLDER="omscripts.git"
NUMARGS=$#
SCRIPT=$(basename "${BASH_SOURCE[0]}")
REMOVE_IMAGES=false

################################################################################
# Methods 
################################################################################

# Print help message to STDOUT
help_message() {
  echo -e \\n"Help documentation for ${SCRIPT}"\\n
  echo -e "Basic usage: ${SCRIPT}"\\n
  echo -e "-r  Removes any images or containers with the same name before running"
  echo -e "-h  Displays this help message. "\
          "No further functions are performed."\\n
  exit 1
}

# Remove any old images with the same name as the one we want to use. 
remove_docker_images(){
    OLD_IMAGES=$(docker images "${IMAGE_NAME}" --format "{{.ID}}")
    if [[ ! -z "${OLD_IMAGES}" ]]; then
      OLD_IMAGES_ARRAY=($OLD_IMAGES)
      echo "Removing all dangling docker images"
      docker rmi --force $(docker images --filter "dangling=true" -q --no-trunc)
      for i in ${OLD_IMAGES_ARRAY[@]};
        do echo "Forcefully deleting image:";
        docker rmi --force "${i}"
      done
    else
        echo "no images to remove"
    fi
}

# Remove any other images with the same name that we want to use.
remove_docker_containers(){
    OLD_CONTAINERS=$(docker ps -a --filter ancestor="${IMAGE_NAME}" --format "{{.ID}}")
    if [[ ! -z "${OLD_CONTAINERS}" ]]; then
      OLD_CONTAINERS_ARRAY=($OLD_CONTAINERS)
      for i in ${OLD_CONTAINERS_ARRAY[@]};
        do echo "Forcefully deleting container:";
        docker rm --force "${i}"
      done
    else
        echo "no containers to remove"
    fi
}

# Only try to clone omscripts if the folder doesn't exist. 
clone_omscripts(){
    if [[ ! -d "${OMSCRIPTS_FOLDER}" ]]; then
        git clone --bare "${OMSCRIPTS}"
    fi
    cd "${OMSCRIPTS_FOLDER}"
    git fetch -pat
    cd ..
}

# Run the Dockerbuild command 
# Tag the image with the hash of the Dockerfile
build_docker_image(){
	docker build \
  -t "${IMAGE_NAME}:$(md5sum -b --status Dockerfile | md5sum | awk '{print $1}')" \
  -t "${IMAGE_NAME}:latest" .
}

publish_docker_image(){
	docker push "${IMAGE_NAME}"
}

# Pull the image from the registry to make sure that it is working
test_docker_pull(){
	docker pull "${IMAGE_NAME}"
}

################################################################################
# Command line arguments
################################################################################

# Parse command line flags
while getopts h:r OPT; do
  case "${OPT}" in
    h) 
      help_message
      ;;
    r)
	  REMOVE_IMAGES="true"
      ;;
  esac
done

shift $((OPTIND-1))


################################################################################
# Start of scripts 
################################################################################

if [[ "${REMOVE_IMAGES}" == "true" ]]; then
remove_docker_images
remove_docker_containers
else
	echo "remove images: ${REMOVE_IMAGES}"
fi

clone_omscripts
build_docker_image
publish_docker_image
test_docker_pull