pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Creating infra..'
                sh 'terraform init'
                sh 'terraform plan -out planfile'
                sh 'terraform apply planfile'
                
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
                sh 'ip=$(terraform output ip)'
                sh 'echo $ip'
                sh 'echo $USER'
                sh 'inspec exec test/influx-disk.rb -t ssh://$USER@${ip} -i /var/ssh/key.pem'
              
            }
        }

        stage('Approval') {
            steps {
                script {
                def userInput = input(id: 'confirm', message: 'Apply Terraform?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
                }
            }
        }
        stage('Cleanup') {
            steps {
                echo 'Deploying....'
                sh 'terraform destroy -force'
                
            }
        }
    }
}
