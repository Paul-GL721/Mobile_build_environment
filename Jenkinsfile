//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent { 
		dockerfile {
			label 'buildnode'
		}		
	}
	stages {
		stage('test cordova environment') {
			steps {
				echo 'Hello cordova'
				sh 'node -v'
				sh 'cordova -v'				
			}
		}

		stage('build cordova application') {
			steps {
				echo 'Building cordova appliication'
			}
		}
	}
}