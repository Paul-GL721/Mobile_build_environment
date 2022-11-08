//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent { 
		dockerfile {
			label 'buildnode'
		}		
	}
	environment {
        HOME = '.'
	}
	stages {
		stage('test cordova environment') {
			steps {
				echo 'Hello cordova'
				sh 'node -v'
				sh 'npm -v'
				sh 'cordova --version'				
			}
		}

		stage('build cordova application') {
			steps {
				echo 'Building cordova appliication'
			}
		}
	}
}