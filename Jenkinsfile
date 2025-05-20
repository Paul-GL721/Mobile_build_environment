//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent { 	
		label 'buildnode'		
	}
	environment {
	    VERSION="1.0.${BUILD_NUMBER}"
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