pipeline {
    agent any

    environment {
        // Asigna el puerto según la rama
        PORT = "${env.BRANCH_NAME == 'main' ? '3000' : '3001'}"
        IMAGE_NAME = "cicd-app:${env.BRANCH_NAME}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t ${IMAGE_NAME} .
                    """
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Detiene y elimina cualquier contenedor anterior en el mismo puerto
                    sh """
                        docker ps -q --filter "publish=${PORT}" | xargs -r docker stop
                        docker ps -aq --filter "publish=${PORT}" | xargs -r docker rm
                        docker run -d -p ${PORT}:3000 -e PORT=${PORT} --name cicd-app-${env.BRANCH_NAME} ${IMAGE_NAME}
                    """
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline finished for branch: ${env.BRANCH_NAME} on port ${PORT}"
        }
    }
}