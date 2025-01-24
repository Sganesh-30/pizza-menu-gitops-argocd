pipeline {
    agent any

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
                bat 'npm run coverage'
            }
        }
        stage('Static Code Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonarqube-token', variable: 'Sonar-Token')]) {
                    bat '''
                    sonar-scanner.bat 
                    -D"sonar.projectKey=pizza_app" \
                    -D"sonar.sources= /src/index.js" \
                    -D"sonar.host.url=http://localhost:9000"
                    '''
                }
            }
        }
    }
}