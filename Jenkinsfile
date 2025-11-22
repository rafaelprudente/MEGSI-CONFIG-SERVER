pipeline {
    agent any

    tools { maven 'MVN' }
    
    environment {
        IMAGE_NAME = "configuration-server"
    }

    stages {
        stage('Create settings.xml') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'OneDev',
                    usernameVariable: 'MVN_USER',
                    passwordVariable: 'MVN_PASS'
                )]) {
                    sh '''
                    cat << 'EOF' > settings.xml
                    <settings>
                        <servers>
                            <server>
                                <id>onedev</id>
                                <username>${MVN_USER}</username>
                                <password>${MVN_PASS}</password>
                            </server>
                        </servers>

                        <mirrors>
                            <mirror>
                                <id>maven-default-http-blocker</id>
                                <mirrorOf>dummy</mirrorOf>
                                <name>Dummy mirror to override default blocking mirror that blocks http</name>
                                <url>http://0.0.0.0/</url>
                            </mirror>
                        </mirrors>
                    </settings>'''
                }
            }
        }
        stage('Build Package') {
            steps {
                sh 'mvn -s settings.xml -B -DskipTests clean package'
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
                    docker.withRegistry('http://artifactory:6610', 'OneDev') {
                        image.push()
                    }
                }
            }
        }
    }
}