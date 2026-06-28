pipeline {

    agent any

    environment {

        AWS_ACCESS_KEY_ID = credentials('aws-access-key')

        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')

        AWS_DEFAULT_REGION = 'us-east-1

    }

    stages {

        stage('Checkout') {

            steps {

                checkout scm

            }

        }

        stage('Terraform Init') {

            steps {

                sh 'terraform init'
            }

        }

        stage('Validate') {

            steps {

                sh 'terraform validate'
            }

        }

        stage('Format Check') {

            steps {

                sh 'terraform fmt -check'
            }

        }

        stage('Plan') {

            steps {

                sh 'terraform plan -out=tfplan'
            }

        }

        stage('Approval') {

            steps {

                input "Deploy Infrastructure?"
            }

        }

        stage('Apply') {

            steps {

                sh 'terraform apply -auto-approve tfplan'
            }

        }

    }

}
