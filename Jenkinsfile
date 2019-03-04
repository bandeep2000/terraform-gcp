pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Creating infra..'
                sh 'terraform init'
                sh 'terraform plan -out planfile'
                sh 'terraform apply planfile'
                sh 'terraform destroy --force'
                
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'ip=$(terraform output ip)'
                sh 'echo $ip'
              
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
