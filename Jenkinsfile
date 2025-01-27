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
        stage('Trivy Vulnarability Scanning'){
            steps {
                bat '''
                trivy image sganesh3010/pizza-app:%GIT_COMMIT% \
                    --severity LOW,MEDIUM \
                    --exit-code 0 \
                    --quiet \
                    --format json --output trivy-MEDIUM-results.json

                trivy image sganesh3010/pizza-app:%GIT_COMMIT% \
                    --severity HIGH, CRITICAL \
                    --exit-code 1 \
                    --quiet \
                    --format json --output trivy-CRITICAL-results.json
                '''
            }
        }
    }
}
