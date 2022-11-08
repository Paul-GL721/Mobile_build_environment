//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent { 
		dockerfile {
			label 'buildnode'
		}		
	}
	
	stages {
		stage('test cordova environment') {
			environment {
				// Override HOME to WORKSPACE
		        HOME = "${WORKSPACE}"
			}
			steps {
				echo 'Hello cordova'
				sh 'node -v'
				sh 'npm -v'
				sh 'cordova --version'
				//list java_home
				sh 'update-alternatives --list java'
				sh 'java --version'
			}
		}

		stage('build cordova application') {
			steps {
				echo 'Building cordova appliication'
				sh '${ANDROID_HOME}/tools/bin/sdkmanager --list'
			}
		}
	}
}