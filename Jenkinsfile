pipeline {
    agent any
    options {
        ansiColor('xterm')
    }

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
                sh 'terraform init'
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