pipeline {
    agent any

    stages {
        stage('Pull') {
            steps {
                echo 'Pulling sccessful'
            }
        }
        stage('Build') {
            steps {
                sh '''
                cd backend
                mvn package -DskipTests
                '''
            }
        }
        stage('Test') {
            steps {
                echo 'Testing done..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying done....'
            }
        }
    }
}