pipeline {
    agent any
    options {
        ansiColor('xterm')
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Environment')
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh """
                terraform init \
                  -backend-config="key=${params.ENV}/terraform.tfstate" \
                  -reconfigure
                """
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh """
                terraform plan \
                  -var-file=env/${params.ENV}.tfvars \
                  -out=tfplan
                """
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: "Deploy ${params.ENV} ?"

                sh """
                terraform apply tfplan
                """
            }
        }

        stage('Terraform Destroy') {
    steps {
        message: "Do you want to destroy ${params.ENV} infrastructure?"
        script {
            def destroy = input(
                message: "Do you want to destroy ${params.ENV} infrastructure?",
                parameters: [
                    choice(name: 'CONFIRM', choices: ['no', 'yes'], description: 'Confirm destroy')
                ]
            )

            if (destroy == 'yes') {
                sh """
                terraform destroy \
                  -var-file=env/${params.ENV}.tfvars \
                  -auto-approve
                """
            } else {
                echo "Destroy skipped"
            }
        }
    }
}
    }

    post {
        success {
            echo "✅ Déploiement ${params.ENV} réussi"
        }
        failure {
            echo "❌ Échec du pipeline"
        }
    }
}