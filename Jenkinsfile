pipeline {
    agent any

    stages {

        stage('Configure grafana') {
            steps {
                
                sh 'sudo rm -rf terraform-grafana'
                sh 'git clone https://github.com/bandeep2000/terraform-grafana.git'
                script {
                    dir ('terraform-grafana') {
                        sh script: 'pwd'
                    
                        /*git(
                        url: 'https://github.com/bandeep2000/terraform-grafana.git',
                        credentialsId: '818d7b6d-e83c-4a03-9df4-fd2cac801b55',
                        branch: "master"
                        )
                        */
                        
                    }

                        
                  
                        //
                        
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

        

        


        
    }
}
