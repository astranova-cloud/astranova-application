pipeline {
    agent any

    environment {
        AWS_REGION = "us-east-1"
        ECR_REPO = "806889657148.dkr.ecr.us-east-1.amazonaws.com/astranova-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
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
                    -Dsonar.host.url=http://54.83.177.215:9000
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Filesystem Security Scan') {
            steps {
                sh '''
                trivy fs --security-checks vuln,secret,config .
                '''
            }
        }

        stage('Dockerfile Security Scan') {
            steps {
                sh '''
                hadolint Dockerfile
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t astranova-app:$IMAGE_TAG .
                '''
            }
        }

        stage('Trivy Image Scan') {
            steps {
                sh '''
                trivy image --exit-code 1 --severity HIGH,CRITICAL astranova-app:$IMAGE_TAG
                trivy image --format table -o trivy-report.txt astranova-app:$IMAGE_TAG
                '''
            }
        }

        stage('Archive Trivy Report') {
            steps {
                archiveArtifacts artifacts: 'trivy-report.txt', fingerprint: true
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | \
                docker login --username AWS --password-stdin 806889657148.dkr.ecr.us-east-1.amazonaws.com

                docker tag astranova-app:$IMAGE_TAG $ECR_REPO:$IMAGE_TAG
                docker push $ECR_REPO:$IMAGE_TAG
                '''
            }
        }

    }

    post {
        always {
            echo "Pipeline execution completed"
        }
    }
}
