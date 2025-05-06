pipeline {
    agent any
    environment {
        // SonarQube environment variable, set this to the name of your SonarQube server configuration in Jenkins
        SONARQUBE_SERVER = 'SonarQube'
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
                        sh 'mvn clean verify sonar:sonar'
                        // For Python, use a different command, e.g., using sonar-scanner CLI
                        // sh 'sonar-scanner -Dsonar.projectKey=your_project_key'
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
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
