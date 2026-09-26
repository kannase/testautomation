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
					sh 'vagrant up'
				}
			}
        }
        stage ("test") {
            steps {
 				sh './scripts/run_tests.sh'
			}
        }
		
		stage ("Reports") {
			steps {
			    allure includeproperties:false,
			    results: [[path:'allure-results']],
			    reportBuildPolicy: 'ALWAYS',
			    reportName: 'Mobile Test Report'
			}
		}
    }
	post {
		always{
			junit 'reports/junit_reports.xml'
		}
    }
}	
	