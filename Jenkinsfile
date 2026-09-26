pipeline {
    agent {
	    label 'windows-agent'
		}
	stages {
		stage("Checkout code"){
			steps {
				checkout scm
			}
		}
        stage ("deploy"){
			steps {
				
        		dir("environments"){
					bat 'vagrant up'
				}
			}
        }
      
    }
	
}	
	