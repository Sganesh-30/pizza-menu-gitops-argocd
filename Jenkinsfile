pipeline {
    agent any

    environment {
        SONAR_SERVER_HOME = tool 'SonarServer-610';
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
                bat 'npm run coverage'
            }
        }
        stage('Static Code Analysis') {
            steps {
                bat 'echo $SONAR_SERVER_HOME'
                bat '''
                $SONAR_SERVER_HOME/bin/sonar-scanner.bat 
                -D"sonar.projectKey=pizza_app" \
                -D"sonar.sources= /src/index.js" \
                '''
            }
        }
    }
}