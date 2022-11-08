//pipeline to automatically create a cordova_mobile application build environment
pipeline {
	agent {
		dockerfile true
		label 'buildnode'
	}
	stages {
		stage('test cordova environment') {
			steps {
				echo 'Hello cordova'
				sh 'cordova -v'
				sh 'node -v'
			}
		}

		stage('build cordova application') {
			steps {
				echo 'Building cordova appliication'
			}
		}
	}
}