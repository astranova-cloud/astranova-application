pipeline {

    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timestamps()
    }

    parameters {
        string(name: 'IMAGE_TAG', defaultValue: 'latest', description: 'Docker image tag')
    }

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "806889657148.dkr.ecr.us-east-1.amazonaws.com/astranova-app"
    }

    stages {

        stage('Clean Workspace') {
            steps {
                deleteDir()
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/astranova-cloud/astranova-application.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t astranova-app:${IMAGE_TAG} .'
            }
        }

        stage('Push Image to ECR') {
            steps {

                sh '''
                aws ecr get-login-password --region $AWS_REGION \
                | docker login --username AWS --password-stdin $ECR_REPO
                '''

                sh 'docker tag astranova-app:${IMAGE_TAG} $ECR_REPO:${IMAGE_TAG}'
                sh 'docker push $ECR_REPO:${IMAGE_TAG}'
            }
        }

    }

}
