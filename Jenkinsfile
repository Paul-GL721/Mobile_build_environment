//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent { 	
		label 'buildnode'		
	}
	environment {
	    VERSION="1.1.${BUILD_NUMBER}"
		REMOTE_REPO_NAME='mobile_build_environment'
		DOCKER_ACCOUNT='paulgl721'
    }	
	stages {
		stage('Build and publish Android images') {
			steps {
				sh '''
                    set -eu
                    for dockerfile in Dockerfile-API*; do
                        if [ ! -f "$dockerfile" ]; then
                            echo "No API Dockerfiles found" >&2
                            exit 1
                        fi
                        APIVERSION="${dockerfile#Dockerfile-API}" bash ./jenkins-scripts/build-step.sh
                    done
                '''
			}
		}
	}
}
