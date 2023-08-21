#!/bin/bash

# required if the docker image needs to be created and cannot just use sfucsssorg/wall_e
if [ -z "${WALL_E_PYTHON_BASE_IMAGE}" ]; then
    echo "WALL_E_PYTHON_BASE_IMAGE is not set"
    exit 1
fi
if [ -z "${DOCKER_HUB_PASSWORD}" ]; then
    echo "DOCKER_HUB_PASSWORD is not set"
    exit 1
fi
if [ -z "${DOCKER_HUB_USER_NAME}" ]; then
    echo "DOCKER_HUB_USER_NAME is not set"
    exit 1
fi

export wall_e_bottom_base_image="wall_e_python_base_image"
export wall_e_bottom_base_image_dockerfile="CI/server_scripts/build_wall_e/Dockerfile.python_base"

docker image rm -f "${wall_e_bottom_base_image}" || true
docker build --no-cache -t ${wall_e_bottom_base_image} -f ${wall_e_bottom_base_image_dockerfile} .
export WALL_E_BASE_ORIGIN_NAME="${wall_e_bottom_base_image}"

docker tag ${wall_e_bottom_base_image} ${WALL_E_PYTHON_BASE_IMAGE}
echo "${DOCKER_HUB_PASSWORD}" | docker login --username=${DOCKER_HUB_USER_NAME} --password-stdin
docker push ${WALL_E_PYTHON_BASE_IMAGE}