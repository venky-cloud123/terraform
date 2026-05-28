pipeline {
    agent any
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                withCredentials([file(credentialsId: 'demo-pem', variable: 'PEM_FILE')]) {

                    sh '''
                    mkdir -p keypair
                    cp "$PEM_FILE" keypair/Demo.pem
                    chmod 400 keypair/Demo.pem

                    terraform plan -out=tfplan
                    '''
                }
            }
        }
        
    }
    post {
        always {
            cleanWs()
        }
    }
} 
