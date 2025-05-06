pipeline {
    agent any
    
    tools {
        // Define the SonarQube Scanner tool configured in Jenkins
        sonarqubeScanner 'SonarQubeScanner'
    }
    
    stages {
        stage('Checkout') {
            steps {
                // Get code from source control
                checkout scm
            }
        }
        
        stage('Setup Python Environment') {
            steps {
                // Create and activate virtual environment
                sh '''
                    python -m venv venv
                    . venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                    pip install pytest pytest-cov
                '''
            }
        }
        
        stage('Run Tests') {
            steps {
                sh '''
                    . venv/bin/activate
                    python -m pytest
                '''
            }
        }
        
        stage('Test with Coverage') {
            steps {
                sh '''
                    . venv/bin/activate
                    python -m pytest --cov=. --cov-report=xml:coverage.xml
                '''
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=flask-app \
                        -Dsonar.projectName="Flask Application" \
                        -Dsonar.sources=. \
                        -Dsonar.python.coverage.reportPaths=coverage.xml \
                        -Dsonar.exclusions=**/*.pyc,venv/**,tests/**,.git/**,.pytest_cache/**
                    '''
                }
                
                // Extract and echo the SonarQube URL for visibility
                script {
                    def sonarUrl = "${env.SONAR_HOST_URL}/dashboard?id=flask-app"
                    echo "-------------------------------------------------------"
                    echo "ANALYSIS SUCCESSFUL, you can find the results at: ${sonarUrl}"
                    echo "-------------------------------------------------------"
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                // Wait for SonarQube Quality Gate to complete
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Build') {
            steps {
                sh '''
                    . venv/bin/activate
                    # Add your Flask app build steps here
                    # For example, compiling static assets, etc.
                '''
            }
        }
        
        stage('Deploy') {
            steps {
                echo 'Deploying Flask application...'
                // Add your deployment steps here
            }
        }
    }
    
    post {
        always {
            // Clean up workspace
            cleanWs()
        }
        success {
            echo 'Pipeline executed successfully!'
            // Display SonarQube URL again for convenience
            script {
                def sonarUrl = "${env.SONAR_HOST_URL}/dashboard?id=flask-app"
                echo "SonarQube Analysis Results: ${sonarUrl}"
            }
        }
        failure {
            echo 'Pipeline execution failed!'
        }
    }
}
