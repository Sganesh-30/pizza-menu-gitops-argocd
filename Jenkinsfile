pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-creds'
        REPO_URL = 'https://github.com/Sganesh-30/pizza-menu-gitops-argocd.git'
        LOCAL_DIR = 'pizza-menu-gitops-argocd'
        IMAGE_NAME = "sganesh3010/pizza-app:%GIT_COMMIT%"
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
                    bat 'docker build --no-cache -t %IMAGE_NAME% -f Dockerfile .'
                }
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-creds', url: "") {
                    bat 'docker push %IMAGE_NAME%'
                }
            }
        }
        stages {
        stage('Checkout Manifest & Update Image Tag') {
            steps {
                script {
                    bat '''
                    if exist %LOCAL_DIR% rmdir /s /q %LOCAL_DIR%
                    git clone %REPO_URL% %LOCAL_DIR%
                    
                    powershell -Command "(Get-Content %LOCAL_DIR%/kubernetes/deployment.yaml) -replace 'image: .*', 'image: %IMAGE_NAME%' | Set-Content %LOCAL_DIR%/kubernetes/deployment.yaml"
                    '''
                }
            }
        }

        stage('Commit and Push') {
            steps {
                script {
                    dir('pizza-menu-gitops-argocd/kubernetes') {
                        bat '''
                        git config --global user.email "ganeshsg430@gmail.com"
                        git config --global user.name "Ganesh"
                        git add deployment.yaml
                        git commit -m "Update image to %IMAGE_NAME%"
                        git push origin main
                        '''
                    }
                }
            }
        }
    }
}
