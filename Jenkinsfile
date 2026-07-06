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
                withSonarQubeEnv('sonarqube') {  
                    sh '''
                    cd backend
                    mvn clean package -DskipTests sonar:sonar   -Dsonar.projectKey=studentapp   -Dsonar.projectName=\'studentapp\'
                    '''
       }
              }
        }
        stage('Quality-gate'){
            steps{
                timeout(10) {
    waitForQualityGate abortPipeline: true, credentialsId: 'sonar-cred'
            }
        }
        }
       
        stage('Deploy') {
            steps {
                echo 'Deploying done....'
            }
        }
    }
}