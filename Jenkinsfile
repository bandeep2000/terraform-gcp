pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Creating infra..'
                sh 'terraform init'
                //sh 'terraform destroy --force'
                sh 'terraform plan -out planfile'
                sh 'terraform apply planfile'
                
            }
        }
        
        stage('Test disks') {
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
                    env.ret = sh(script: 'terraform output ip', returnStdout: true).trim()
                    println ret
                    
                    //sh script: 'sudo inspec exec test/influx-test-disk.rb  -t ssh://${USER}@${ret} -i /var/ssh/key.pem'
                } 
            }
        }

        

        stage('Configure grafana') {
            steps {
                
                script {
                    dir ('terraform-grafana') {
                        sh script: 'pwd'
                    
                        git(
                        url: 'https://github.com/bandeep2000/terraform-grafana.git',
                        credentialsId: '818d7b6d-e83c-4a03-9df4-fd2cac801b55',
                        branch: "master"
                        )
                    }

                        sh script: "ls -lat"
                
                        
                        sh script: 'pwd'
                        
                        //sh script: 'rm -rf terraform-url.tfvars'
                        //sh script: 'cp terraform-url.tmpl terraform-url.tfvars'
                        //sh script: "sed -i 's/INFLUX/35.197.76.191/' terraform-url.tfvars"
                        //sh script: "sed -i 's/GRAFANA/35.203.163.82/' terraform-url.tfvars"
                        //sh script: "git add terraform-url.tfvars"
                        //sh script: "git commit -m 'Modified url tfvars file'"
                        
                        //sh script: "git push https://bandeep2000:$GIT_BAN_PASSWD@github.com/bandeep2000/terraform-grafana.git"
                    
                }
                
                
            }
        }

        stage('Configure influx') {
            steps {
                sh 'rm -rf ansibile-influx'
                sh 'git clone https://github.com/bandeep2000/ansibile-influx.git'
                sh 'cd ansibile-influx'
                //cd ansibile-influx
                sh 'pwd'
                sh 'ls'
                //Uncomment this!!
                //sh 'sudo ansible-playbook -s -u $USER   --private-key=/var/ssh/key.pem -i ansibile-influx/inventories/test/ ansibile-influx/playbook/gcp-influx.yml'
            }
        }

        stage('Test influx') {
            steps {
                script { 
                            // made in env variable, so it could interpolate
                            env.ret = sh(script: 'terraform output ip', returnStdout: true)
                            println ret
                            
                            sh script: 'sudo inspec exec test/influx-service-up.rb  -t ssh://${USER}@${ret} -i /var/ssh/key.pem'
                            //sh script : "sudo sed -i 's/GCP_INFLUX/${ret}/' test/influx-ping.rb"
                            //env.GCP_INFLUX = sh(script: 'terraform output ip', returnStdout: true)
                            //sh script 'export GCP_INFLUX=$GCP_INFLUX'
                            //print GCP_INFLUX
                            //sh script: 'sudo inspec exec test/influx-ping.rb'
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
