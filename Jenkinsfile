pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS = 'docker-creds'
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
                bat 'docker build --no-cache -t sganesh3010/pizza-app:%GIT_COMMIT% -f Dockerfile .'
            }
        }
        stage('Push Image to DockerHub') {
            steps {
                withCredentials([string(credentialsId: 'docker-creds', variable: 'DOCKER_CREDENTIALS')]) {
                    bat '''
                    docker login -u sganesh3010 --password-stdin
                    docker push sganesh3010/pizza-app:%GIT_COMMIT%'
                    '''
                }
            }
        }
        stage('Deploying Container') {
            steps {
                bat 'docker run -d --name pizzashop -d 3000:3000 sganesh3010/pizza-app:%GIT_COMMIT%'
            }
        }
    }
}
