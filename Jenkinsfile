pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
    }
    stages {
        stage('Create New PROD Docker Image'){
            when {
                branch 'master'
            }
            steps {
                withCredentials(
                    [
                        usernamePassword(
                            credentialsId: 'docker-hub-perms',
                            passwordVariable: 'DOCKER_HUB_PASSWORD',
                            usernameVariable: 'DOCKER_HUB_USER_NAME'
                        )
                    ]
                ) {
                    sh label: '', script : """bash -c \'
                        export DOCKER_HUB_PASSWORD="'"${DOCKER_HUB_PASSWORD}"'";
                        export DOCKER_HUB_USER_NAME=${DOCKER_HUB_USER_NAME};
                        export WALL_E_PYTHON_BASE_IMAGE=wall_e_python;
                        ./build.sh;
                    \'"""
                }
            }
        }
    }
    post {
        always {
            cleanWs(
            cleanWhenAborted: true,
            cleanWhenFailure: true,
            cleanWhenNotBuilt: false,
            cleanWhenSuccess: true,
            cleanWhenUnstable: true,
            deleteDirs: true,
            disableDeferredWipeout: true
        )
        }
    }
}
