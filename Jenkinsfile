pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "rohith1750/devops-flask-app"  // Change to your Docker Hub image name
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/rohith1750/devops-flask-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    dockerImage = docker.build("${DOCKER_IMAGE}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushing Docker image to Docker Hub...'
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        dockerImage.push('latest')
                    }
                }
            }
        }

        // Optional: Add test or quality check stages here (e.g., SonarQube)
        // stage('SonarQube Analysis') {
        //     steps {
        //         script {
        //             echo 'Running SonarQube analysis...'
        //             // Run SonarQube analysis here
        //         }
        //     }
        // }
    }

    post {
        success {
            echo 'Pipeline execution completed successfully!'
        }
        failure {
            echo 'Pipeline execution failed.'
        }
    }
}
