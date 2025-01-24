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
                bat 'dependency-check --scan . --out target --format HTML'
            }
        }
    }
}