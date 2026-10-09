pipeline {
    agent {
        label 'windows-agent'
    }
	parameters {
        string(name: 'TA_ENV_BRANCH', defaultValue: 'feat/appium-system-tests', description: 'Git branch to checkout and test')
		string(name: 'APK_PATH', defaultValue: '\\\\SENTHIL\\release', description: 'Network file share directory containing the APK')
        string(name: 'APK_NAME', defaultValue: 'app-release.apk', description: 'Name of the APK file')
		
    }
	environment {
        PARAM_APK_PATH = "${params.APK_PATH}"
        PARAM_APK_NAME = "${params.APK_NAME}"
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
                    
					# Override the node cookie so Jenkins leaves this process running after build completion
                    $env:JENKINS_NODE_COOKIE = "dontKillMe"
					Start-Process "C:\\Android\\Sdk\\emulator\\emulator.exe" -ArgumentList "-avd TestDevice -no-snapshot-load -no-audio"
					
					#$startInfo = New-Object System.Diagnostics.ProcessStartInfo
					#$startInfo.FileName = "C:\\Android\\Sdk\\emulator\\emulator.exe"
					#$startInfo.Arguments = "-avd TestDevice -no-snapshot-load -no-audio"
					#$startInfo.UseShellExecute = $true
					#[System.Diagnostics.Process]::Start($startInfo) | Out-Null
					
					#cmd /c start "" "C:\\Android\\Sdk\\emulator\\emulator.exe" -avd TestDevice -no-snapshot-load -no-audio > $null 2>&1
                    
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
        stage("Deploy to Emulator") {
            steps {
                powershell '''
                    Write-Host "Preparing local temp directory..."
                    $customTempDir = "C:\\temp"
                    
					# Fallback to default name if environment variable is empty
                    $apkFileName = if ($env:PARAM_APK_NAME) { $env:PARAM_APK_NAME } else { "app-release.apk" }
                    $apkShare = if ($env:PARAM_APK_PATH) { $env:PARAM_APK_PATH } else { "\\\\SENTHIL\\release" }
					
					$sourcePath = Join-Path $apkShare $apkFileName
                    $targetApkPath = Join-Path $customTempDir $apkFileName
					
					Write-Host "Source Path: $sourcePath"
                    Write-Host "Target Path: $targetApkPath"
                    
                    # Ensure C:\\temp exists
                    if (-not (Test-Path $customTempDir)) {
                        New-Item -ItemType Directory -Path $customTempDir | Out-Null
                    }
                    
                    if (-not (Test-Path $sourcePath)) {
                        Write-Error "Could not find APK at: $sourcePath"
                        exit 1
                    }
                    
                    Write-Host "Copying APK from $sourcePath to $targetApkPath..."
                    Copy-Item -LiteralPath $sourcePath -Destination $targetApkPath -Force
					
					if (-not (Test-Path $targetApkPath)) {
                        Write-Error "Target APK not found at $targetApkPath after copy!"
                        exit 1
                    }
					
                    Write-Host "Installing APK from $targetApkPath..."
                    adb install -r $targetApkPath
                    
                    if (\$LASTEXITCODE -eq 0) {
                        Write-Host "App installed successfully!"
                    } else {
                        Write-Error "Failed to install APK!"
                        exit 1
                    }
                    
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