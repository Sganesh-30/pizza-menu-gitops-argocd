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
                dependencyCheck additionalArguments: 'dependency-check --scan . --out target --format ALL', odcInstallation: 'OWSAP-10'

                junit keepProperties: true, stdioRetention: '', testResults: 'dependency-check-report.xml'
            }
        }
        stage('Static Code Analysis') {
            steps {
                bat '''
                sonar-scanner.bat -D"sonar.projectKey=pizza_app" -D"sonar.sources=." -D"sonar.host.url=http://localhost:9000" -D"sonar.token=sqp_51330c256369e8437583416456f5c384708ce4b0"
                '''
            }
        }
    }
}