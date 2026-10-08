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