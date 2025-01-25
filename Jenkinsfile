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
                catchError(buildResult: 'SUCCESS', message: 'OOPS! WE MISSED COVERAGE!!!', stageResult: 'UNSTABLE') {
                    bat 'npm run coverage'
                }
            }
        }
        stage('SAST - SonarQube') {
            steps {
                bat '''
                sonar-scanner.bat \
                -D"sonar.projectKey=pizza_app" \
                -D"sonar.sources=." \
                -D"sonar.host.url=http://localhost:9000" \
                -D"sonar.login=873fcca5fbdd8c33f601b35538bfca8bdc825880"
                '''
            }
        }
    }
}