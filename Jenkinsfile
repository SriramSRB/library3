pipeline {
    agent any

    stages {
        stage ('1. Checkout code') {
            steps {
                checkout scm
            }
        }
        stage ('2. Build docker image') {
            steps {
                sh 'docker build -t sriramsrb/library3:latest .'
            }
        }
        stage ('3. Push image') {
            steps {
                withCredentials([string(credentialsId: 'library3_user', variable: 'DOCKER_PWD')]) {
                    sh 'echo "$DOCKER_PWD" | docker login -u sriramsrb --password-stdin'
                    sh 'docker push sriramsrb/library3:latest'
                }
            }
        }
        stage ('4. Deploy to kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yml'
                sh 'kubectl rollout restart deployment library3-deployment'
            }
        }
    }
}
