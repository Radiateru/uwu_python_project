pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'waf', url: 'https://github.com/Radiateru/uwu_python_project.git'
             }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-id-accesskey', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                    export AWS_DEFAULT_REGION=eu-west-1
                    terraform init
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Déployer l'infra ?"
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}