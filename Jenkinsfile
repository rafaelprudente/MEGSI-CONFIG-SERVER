pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  restartPolicy: Never
  containers:
      - name: kaniko
        image: gcr.io/kaniko-project/executor:debug
        command:
          - /busybox/sh
        args:
          - -c
          - sleep 999999
        volumeMounts:
          - name: docker-config
            mountPath: /kaniko/.docker
  volumes:
    - name: docker-config
      secret:
        secretName: onedev-registry
"""
    }
  }

  environment {
    REGISTRY   = "192.168.56.214:30610"
    PROJECT    = "uminho"
    IMAGE_NAME = "configuration-server"
    IMAGE_TAG  = "${env.BUILD_NUMBER}"
  }

  stages {

    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Push Image (Kaniko)') {
      steps {
        container('kaniko') {
          sh '''
            /kaniko/executor \
              --context $WORKSPACE \
              --dockerfile Dockerfile \
              --destination $REGISTRY/$PROJECT/$IMAGE_NAME:$IMAGE_TAG \
              --destination $REGISTRY/$PROJECT/$IMAGE_NAME:latest \
              --insecure \
              --skip-tls-verify
          '''
        }
      }
    }
  }

  post {
    success {
      echo "Imagem criada com sucesso:"
      echo "$REGISTRY/$PROJECT/$IMAGE_NAME:$IMAGE_TAG"
    }
    failure {
      echo "Falha no build da imagem."
    }
  }
}
