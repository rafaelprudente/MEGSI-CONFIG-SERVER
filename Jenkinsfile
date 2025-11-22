pipeline {
    agent any

    tools { maven 'MVN' }
    
    environment {
        IMAGE_NAME = "configuration-server"
    }

    stages {
        stage('Prepare SSH') {
            steps {
                withCredentials([sshUserPrivateKey(
                credentialsId: 'GitHubSSH',
                keyFileVariable: 'SSH_KEY'
                )]) {
                    sh '''
                    cp "$SSH_KEY" megsi-config-server
                    '''
                }
            }
        }
        stage('Prepare Pub SSH') {
            steps {
                withCredentials([sshUserPrivateKey(
                credentialsId: 'GitHubSSHPub',
                keyFileVariable: 'SSH_KEY'
                )]) {
                    sh '''
                    cp "$SSH_KEY" megsi-config-server.pub
                    '''
                }
            }
        }
        stage('Build Package') {
            steps {
                sh 'mvn -B -DskipTests clean package'
            }
        }
        stage('Build Image') {
            steps {
                script {
                    image = docker.build("uminho/${env.IMAGE_NAME}:latest", ".")
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('http://192.168.56.213:6610', 'OneDev') {
                        image.push()
                    }
                }
            }
        }
    }
}