pipeline {
    agent {
        label 'windows-agent'
    }
	parameters {
        string(name: 'TA_ENV_BRANCH', defaultValue: 'feat/appium-system-tests', description: 'Git branch to checkout and test')
    }
    stages {
        stage("Checkout code"){
            steps {
                // Checks out the branch specified in the Jenkins UI trigger parameter
                git branch: "${params.TA_ENV_BRANCH}", url: 'https://github.com/kannase/testautomation.git'
            }
        }
        stage("Start Android Emulator"){
            steps {
                powershell '''
                    Write-Host "Starting Android Emulator..."
                    Start-Process "C:\\Android\\Sdk\\emulator\\emulator.exe" -ArgumentList "-avd TestDevice -no-audio"
                    
                    Write-Host "Waiting for device to connect via ADB..."
                    adb wait-for-device
                    
                    # Brief pause to ensure system services are fully awake
                    Start-Sleep -Seconds 10
                '''
            }
        }
     }
}