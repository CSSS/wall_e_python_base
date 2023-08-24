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

docker system prune -f
export wall_e_bottom_base_image_dockerfile="Dockerfile"

docker image rm -f "${WALL_E_PYTHON_BASE_IMAGE}" || true
docker build --no-cache -t ${WALL_E_PYTHON_BASE_IMAGE} -f ${wall_e_bottom_base_image_dockerfile} .
export WALL_E_BASE_ORIGIN_NAME="${WALL_E_PYTHON_BASE_IMAGE}"

docker tag ${WALL_E_PYTHON_BASE_IMAGE} sfucsssorg/${WALL_E_PYTHON_BASE_IMAGE}
echo "${DOCKER_HUB_PASSWORD}" | docker login --username=${DOCKER_HUB_USER_NAME} --password-stdin
docker push sfucsssorg/${WALL_E_PYTHON_BASE_IMAGE}

docker rmi sfucsssorg/${WALL_E_PYTHON_BASE_IMAGE}
docker image rm "${WALL_E_PYTHON_BASE_IMAGE}"
docker system prune -f