pipeline {
    agent any

    environment {
        // The name of the SonarQube server as configured in Jenkins
        SONARQUBE_SERVER = 'SonarQube'
        SONARQUBE_HOST = 'http://34.201.116.83:9000' // Update with your SonarQube server IP or URL
    }

    tools {
        // Use the SonarQube Scanner named "qube" that you've defined in Jenkins Global Tool Configuration
        sonarQubeScanner 'qube'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/rohith1750/devops-flask-app.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -r requirements.txt
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Run SonarQube analysis using the scanner configured as "qube"
                    echo 'Running SonarQube Analysis for Flask App'
                    withCredentials([string(credentialsId: 'sonarqube', variable: 'SONAR_AUTH_TOKEN')]) {
                        sh '''
                            sonar-scanner \
                            -Dsonar.projectKey=devops-flask-app \
                            -Dsonar.projectName=DevOps Flask App \
                            -Dsonar.host.url=${SONARQUBE_HOST} \
                            -Dsonar.login=${SONAR_AUTH_TOKEN}
                        '''
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    def qualityGate = waitForQualityGate()
                    if (qualityGate.status != 'OK') {
                        error "SonarQube Quality Gate failed: ${qualityGate.status}"
                    }
                    echo "SonarQube Quality Gate passed"
                }
            }
        }

        stage('Fetch SonarQube Results') {
            steps {
                script {
                    // Fetch the results from SonarQube API
                    def sonarResults = sh(script: '''
                        curl -u ${SONAR_AUTH_TOKEN}: ${SONARQUBE_HOST}/api/qualitygates/project_status?projectKey=devops-flask-app
                    ''', returnStdout: true).trim()

                    echo "SonarQube Analysis Results: ${sonarResults}"

                    // Extract IP Address or other relevant information from the response
                    def ipAddress = "${SONARQUBE_HOST}"
                    echo "SonarQube Analysis is done at: ${ipAddress}"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-flask-app .'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
