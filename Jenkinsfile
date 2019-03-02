pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'teraform init'
                sh 'terraform plan -out planfile'
                sh 'terraform apply'
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
