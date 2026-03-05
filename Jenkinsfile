pipeline {

    agent { label 'jenkins-agent' }

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "806889657148.dkr.ecr.us-east-1.amazonaws.com/astranova-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/YOUR_USERNAME/astranova-application.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                container('docker') {
                    sh 'docker build -t astranova-app .'
                }
            }
        }

        stage('Login to ECR') {
            steps {
                container('docker') {
                    sh '''
                    aws ecr get-login-password --region $AWS_REGION \
                    | docker login --username AWS --password-stdin $ECR_REPO
                    '''
                }
            }
        }

        stage('Push Image') {
            steps {
                container('docker') {
                    sh '''
                    docker tag astranova-app:latest $ECR_REPO:latest
                    docker push $ECR_REPO:latest
                    '''
                }
            }
        }

    }
}
