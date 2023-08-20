#!/bin/bash

# required if the docker image needs to be created and cannot just use sfucsssorg/wall_e
if [ -z "${JENKINS_HOME}" ]; then
    echo "JENKINS_HOME is not set"
    exit 1
fi

export wall_e_bottom_base_image=$(echo "${COMPOSE_PROJECT_NAME}_wall_e_python_base_image" | awk '{print tolower($0)}')
export wall_e_bottom_base_image_dockerfile="CI/server_scripts/build_wall_e/Dockerfile.python_base"

docker image rm -f "${wall_e_bottom_base_image}" || true
docker build --no-cache -t ${wall_e_bottom_base_image} -f ${wall_e_bottom_base_image_dockerfile} .
export WALL_E_BASE_ORIGIN_NAME="${wall_e_bottom_base_image}"