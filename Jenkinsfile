//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent { 	
		label 'buildnode'		
	}
	environment {
	    VERSION="1.1.${BUILD_NUMBER}"
		APIVERSION="34"
		REMOTE_REPO_NAME='mobile_build_environment'
		DOCKER_ACCOUNT='paulgl721'
    }	
	stages {
		stage('build cordova application') {
			steps {
				echo 'Building cordova appliication'         
				//make the script-files executables                
					sh 'chmod +x ./jenkins-scripts/build-step.sh'
				//run script file
					sh './jenkins-scripts/build-step.sh'
			}
		}
	}
}