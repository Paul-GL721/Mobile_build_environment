//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent { 	
		label 'buildnode'		
	}	
	stages {
		stage('test cordova environment') {
			steps { //list cordova envirionment variables
				echo 'Hello cordova'
				#sh 'node --version'
				#sh 'npm -v'
				#sh 'cordova --version'
				//sh 'java --version'
				//sh '${ANDROID_HOME}/tools/bin/sdkmanager --licenses'
			}
		}

		stage('build cordova application') {
			steps {
				echo 'Building cordova appliication'         
                //make the script-files executables                
                sh 'chmod +x ./jenkins-scripts/build-step.sh'
			}
		}
	}
}