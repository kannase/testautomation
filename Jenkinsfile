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
                    cmd /c start "" "C:\\Android\\Sdk\\emulator\\emulator.exe" -avd TestDevice -no-snapshot-load -no-audio
                    
                    Write-Host "Waiting for device to connect via ADB..."
                    adb wait-for-device
                    
                    Write-Host "Waiting for Android OS boot sequence to fully complete..."
                    $timeout = 120 # 2 minutes timeout
                    $sw = [System.Diagnostics.Stopwatch]::StartNew()

                    while ($true) {
                            # Fetch the boot status property and trim whitespace/newlines
                              $bootCompleted = (adb shell getprop sys.boot_completed).Trim()
    
                              if ($bootCompleted -eq "1") {
                                          Write-Host "Android OS is fully booted and ready!"
                                          break
                                }
    
                              if ($sw.Elapsed.TotalSeconds -gt $timeout) {
                                  Write-Error "Timed out waiting for sys.boot_completed!"
                                  exit 1
                                }
    
                              Start-Sleep -Seconds 3
                    }
                    $sw.Stop()
                '''
            }
        }
     }
	 post {
        always {
            // Automatically cleans up the workspace files after the run finishes
            cleanWs deleteDirs: true, notFailBuild: true
        }
    }
}