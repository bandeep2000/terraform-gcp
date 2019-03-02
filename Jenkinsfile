pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                teraform init
                terraform plan -out planfile
                terraform apply
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
