pipeline {
    agent any

    tools {
        nodejs 'node' // El nombre debe coincidir con el configurado en Jenkins
        dockerTool 'docker'
    }

    environment {
        // Asigna el puerto según la rama
        PORT = "${env.BRANCH_NAME == 'main' ? '3000' : (env.BRANCH_NAME == 'dev' ? '3001' : '')}"
        IMAGE_NAME = "${env.BRANCH_NAME == 'main' ? 'nodemain:v1.0' : (env.BRANCH_NAME == 'dev' ? 'nodedev:v1.0' : '')}"
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
                sh 'npm run build'
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
                        docker ps -q --filter "name=cicd-app-${env.BRANCH_NAME}" | xargs -r docker stop
                        docker ps -aq --filter "name=cicd-app-${env.BRANCH_NAME}" | xargs -r docker rm
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