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
                'dependency-check --scan . --out target --format HTML'
            }
        }
    }
}