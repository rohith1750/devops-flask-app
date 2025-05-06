pipeline {
    agent any
    environment {
        // Set the SonarQube environment variable to the name of your SonarQube server in Jenkins
        SONARQUBE_SERVER = 'SonarQube'  // Make sure this matches the SonarQube server name in Jenkins
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/rohith1750/devops-flask-app.git'
            }
        }
        stage('Install Dependencies') {
            steps {
                script {
                    // Creating and activating the virtual environment
                    sh '''
                        python3 -m venv venv
                        . venv/bin/activate
                        pip install -r requirements.txt
                    '''
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                script {
                    // Running the SonarQube scanner to analyze the project
                    withSonarQubeEnv(SONARQUBE_SERVER) {
                        // For Python projects, use the sonar-scanner CLI
                        sh 'sonar-scanner -Dsonar.projectKey=devops-flask-app -Dsonar.sources=.'
                    }
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
            script {
                // Wait for SonarQube quality gate result
                waitForQualityGate()
            }
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
