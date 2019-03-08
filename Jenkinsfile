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
        

        stage('Push IPs to influx git') {
            steps {
                
                sh 'sudo rm -rf terraform-influx-conf'
                sh 'git clone https://github.com/bandeep2000/terraform-influx-conf.git'
                script {
                    // Adding on the top as before cd to directory as terraform output will
                    // fail other wise
                    env.ip_influx = sh(script: 'terraform output ip', returnStdout: true).trim()
                    //env.ip_grafana = sh(script: 'terraform output ip', returnStdout: true).trim()
                    //cd to directory checked out in prev step
                    dir ('terraform-influx-conf') {
                        sh script: 'pwd'
                    
                        /*git(
                        url: 'https://github.com/bandeep2000/terraform-grafana.git',
                        credentialsId: '818d7b6d-e83c-4a03-9df4-fd2cac801b55',
                        branch: "master"
                        )
                        */  

                        // TODO add catch try  
                                  
                        sh script: 'rm -rf terraform-url.tfvars'
                        // Copy template
                        sh script: 'cp terraform-url.tmpl terraform-url.tfvars'
                        
                        sh script: "sed -i 's/INFLUX/" + ip_influx + "/'"  + " terraform-url.tfvars"
                        //sh script: "sed -i 's/GRAFANA/" + ip_grafana + "/'"  + " terraform-url.tfvars"
                        
                        sh script: "git add terraform-url.tfvars"
                        sh script: "git commit -m 'Modified url tfvars file'"
                        
                        sh script: "git push https://bandeep2000:$GIT_BAN_PASSWD@github.com/bandeep2000/terraform-influx-conf.git"
                    }
                }
                
                
            }
        }

        stage('Approval to delete') {
            steps {
                script {
                    echo 'Skipping this'
                    def userInput = input(id: 'confirm', message: 'Delete everthing?', parameters: [ [$class: 'BooleanParameterDefinition', defaultValue: false, description: 'Apply terraform', name: 'confirm'] ])
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
