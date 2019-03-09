pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Creating infra..'
                sh 'terraform init'
                sh 'terraform destroy --force'
                sh 'terraform plan -out planfile'
                sh 'terraform apply planfile'
                
            }
        }
        
        
        // This stage get the new ips from terraform created and pushes to another repository
        stage('Push IPs to grafana git') {
            steps {
                
                sh 'sudo rm -rf terraform-grafana1'
                
                sh 'git clone https://github.com/bandeep2000/terraform-grafana1.git'
                script {
                    // Adding on the top as before cd to directory as terraform output will
                    // fail other wise
                    env.ip_influx = sh(script: 'terraform output ip', returnStdout: true).trim()
                    env.ip_grafana = sh(script: 'terraform output ip-grafana', returnStdout: true).trim()
                    //cd to directory checked out in prev step
                    dir ('terraform-grafana1') {
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
                        sh script: "sed -i 's/GRAFANA/" + ip_grafana + "/'"  + " terraform-url.tfvars"
                        
                        sh script: "git add terraform-url.tfvars"
                        try {
                          sh script: "git commit -m 'Modified url tfvars file'"
                          sh script: "git push https://bandeep2000:$GIT_BAN_PASSWD@github.com/bandeep2000/terraform-grafana1.git"
                        } 

                        catch(Exception e) {
                            echo 'e'
                        }
                        
                        
                        
                    }
                }
                
                
                
            }
        }

        
}
