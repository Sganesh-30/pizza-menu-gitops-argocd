pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-creds'
        REPO_URL = 'https://github.com/Sganesh-30/pizza-menu-gitops-argocd.git'
        LOCAL_DIR = 'pizza-menu-gitops-argocd'
    }

    stages {
        stage('Installing Dependencies') {
            steps {
                bat 'npm install'
            }
        }
        stage('Scanning Dependencies') {
            steps {
                dependencyCheck additionalArguments: 'dependency-check --scan . --out target --disableYarnAudit --format ALL', odcInstallation: 'OWSAP-10'
            }
        }
        stage('Code Coverage'){
            steps {
                catchError(buildResult: 'SUCCESS', message: 'OOPS! WE MISSED COVERAGE!!!', stageResult: 'UNSTABLE') {
                    bat 'npm run coverage'
                }
            }
        }
        stage('SAST - SonarQube') {
            steps {
                withSonarQubeEnv('sonarserver') {
                    bat '''
                    sonar-scanner.bat \
                    -D"sonar.projectKey=pizza_app" \
                    -D"sonar.sources=."  
                    '''
                }
            }
        }

        stage('Building Docker Image'){
            steps {
                retry(2) {
                    bat 'docker build --no-cache -t sganesh3010/pizza-app:%GIT_COMMIT% -f Dockerfile .'
                }
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-creds', url: "") {
                    bat 'docker push sganesh3010/pizza-app:%GIT_COMMIT%'
                }
            }
        }
        stage('Checkout Manifest & Update Image Tag') {
            steps {
                script {
                    bat '''
                    @echo off
                    echo "Cleaning up existing repository..."
                    if exist pizza-menu-gitops-argocd (
                        rmdir /s /q pizza-menu-gitops-argocd
                        echo "Deleted existing repository."
                    )

                    echo "Cloning repository..."
                    git clone https://github.com/Sganesh-30/pizza-menu-gitops-argocd.git pizza-menu-gitops-argocd
                    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

                    echo "Updating deployment.yaml with new image tag..."
                    powershell -Command "& { (Get-Content pizza-menu-gitops-argocd\\kubernetes\\deployment.yaml) -replace 'image: .*', 'image: sganesh3010/pizza-app:%GIT_COMMIT%' | Set-Content pizza-menu-gitops-argocd\\kubernetes\\deployment.yaml }"
                    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

                    echo "File updated successfully!"
                    '''
                }
            }
        }

        stage('Commit and Push') {
            steps {
                script {
                    bat '''
                    @echo off
                    cd pizza-menu-gitops-argocd\\kubernetes

                    echo "Configuring Git..."
                    git config --global user.email "ganeshsg430@gmail.com"
                    git config --global user.name "Ganesh"

                    echo "Checking Git status..."
                    git status

                    echo "Force staging deployment.yaml..."
                    git add --force deployment.yaml
                    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

                    echo "Verifying staged changes..."
                    git status

                    echo "Committing changes..."
                    git commit -m "Update image to %IMAGE_NAME%"
                    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

                    echo "Pushing changes..."
                    git push origin main
                    if %ERRORLEVEL% neq 0 exit /b %ERRORLEVEL%

                    echo "Changes pushed successfully!"
                    '''
                }
            }
        }
    }
}
