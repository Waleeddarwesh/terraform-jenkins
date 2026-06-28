pipeline {
    agent any

    environment {
        // Note: Configure your cloud provider credentials in Jenkins and inject them here.
        // Example for AWS:
        // AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        // AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        TF_IN_AUTOMATION = 'true'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                // Use 'bat' instead of 'sh' if your Jenkins agent is running on Windows
                sh 'terraform init'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Approval') {
            steps {
                input message: 'Do you want to deploy the Terraform plan?', ok: 'Deploy'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -input=false tfplan'
            }
        }
    }

    post {
        always {
            // Clean up the workspace after the build
            cleanWs()
        }
    }
}
