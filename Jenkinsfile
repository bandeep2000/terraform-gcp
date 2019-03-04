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
                
                script {
                    jobBaseName = sh(
                        script: "terraform output ip",
                        returnStdout: true,
                    )
                }   
                echo 'Testing..'
                sh 'ip=$(terraform output ip)'
                sh 'echo $(terraform output ip)'
                
                //Need to delete this
                sh 'terraform output ip > commandResult'
                script {
                    result = readFile('commandResult').trim()
                    println result
                    
                }
                
                sh 'echo ${BUILD_TAG}'
                
                script { 
                    // made in env variable, so it could interpolate
                    env.ret = sh(script: 'terraform output ip', returnStdout: true)
                    println ret
                    
                    sh script: 'inspec exec test/influx-test-disk.rb  -t ssh://${USER}@${ret} -i /var/ssh/key.pem'
                } 
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
