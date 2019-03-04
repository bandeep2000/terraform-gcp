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
        stage ('Construct Img name') {
            steps {
                script {
                    def jobBaseName = sh(
                        script: "terraform output ip",
                        returnStdout: true,
                    )
                }   
            }
        }
        
        stage('Test') {
            steps {
                
                script {
                    jobBaseName = sh(
                        script: "terraform output ip",
                        returnStdout: true,
                    )
                }   
                echo 'Testing..'
                sh 'ip=$(terraform output ip)'
                sh 'echo $(terraform output ip)'
                sh 'terraform output ip > commandResult'
                script {
                    result = readFile('commandResult').trim()
                    println result
                }
                sh 'echo Ip is $ip'
                sh 'export IP=$ip'
                sh 'echo $USER'
                sh 'echo ${BUILD_TAG}'
                sh 'echo ${jobBaseName}'
                sh 'inspec exec test/influx-disk.rb -t ssh://$USER@$IP -i /var/ssh/key.pem'
              
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
