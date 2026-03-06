
pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/astranova-cloud/astranova-application.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t astranova-app:latest .'
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region us-east-1 \
                | docker login --username AWS --password-stdin 806889657148.dkr.ecr.us-east-1.amazonaws.com

                docker tag astranova-app:latest 806889657148.dkr.ecr.us-east-1.amazonaws.com/astranova-app:latest

                docker push 806889657148.dkr.ecr.us-east-1.amazonaws.com/astranova-app:latest
                '''
            }
        }

    }
}
