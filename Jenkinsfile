pipeline {
    agent any
    environment {
        SONARQUBE_HOST = 'http://34.60.108.131:9000'  // Fixed URL
        PROJECT_KEY = 'devops-flask-app'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/rohith1750/devops-flask-app.git'
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
                    def sonarIP = sh(script: "echo ${SONARQUBE_HOST} | sed -e 's|^http://||' -e 's|:.*$||'", returnStdout: true).trim()
                    echo "SonarQube Analysis Server IP: ${sonarIP}"

                    withSonarQubeEnv('SonarQube Server') {
                        sh """
                            . venv/bin/activate

                            cat > sonar-project.properties << EOF
sonar.projectKey=${PROJECT_KEY}
sonar.projectName=DevOps Flask App
sonar.sources=.
sonar.python.coverage.reportPaths=coverage.xml
EOF

                            sonar-scanner
                        """
                    }
                }
            }
        }
        stage('Quality Gate') {
            steps {
                script {
                    echo "Checking Quality Gate at ${SONARQUBE_HOST}"
                    try {
                        timeout(time: 2, unit: 'MINUTES') {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                error "Quality Gate failed with status: ${qg.status}"
                            } else {
                                echo "Quality Gate passed!"
                            }
                        }
                    } catch (Exception e) {
                        echo "Quality Gate check failed: ${e.message}"
                    }
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-flask-app .'
            }
        }
     
    }
    post {
        success {
            script {
                def sonarIP = sh(script: "echo ${SONARQUBE_HOST} | sed -e 's|^http://||' -e 's|:.*$||'", returnStdout: true).trim()
                echo "Pipeline completed successfully."
                echo "SonarQube Server IP: ${sonarIP}"
                echo "SonarQube Dashboard: ${SONARQUBE_HOST}/dashboard?id=${PROJECT_KEY}"
            }
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
