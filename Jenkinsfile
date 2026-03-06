pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "806889657148.dkr.ecr.us-east-1.amazonaws.com/astranova-app"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('SonarQube Scan') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    sonar-scanner \
                    -Dsonar.projectKey=astranova-app \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://54.83.177.215:9000 \
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t astranova-app:latest .'
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                trivy image --exit-code 1 --severity HIGH,CRITICAL astranova-app:latest
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin 806889657148.dkr.ecr.us-east-1.amazonaws.com

                docker tag astranova-app:latest $ECR_REPO:$IMAGE_TAG
                docker push $ECR_REPO:$IMAGE_TAG
                '''
            }
        }
    }
}