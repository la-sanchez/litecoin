pipeline {
    environment {
        REGISTRY = "lsvazquez/litecoin"
        registryCredential = 'dockerhub'
        dockerImage = ''
    }
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                  containers:
                  - name: docker
                    image: docker:latest
                    command:
                    - cat
                    tty: true
                    volumeMounts:
                     - mountPath: /var/run/docker.sock
                       name: docker-sock
                  volumes:
                  - name: docker-sock
                    hostPath:
                      path: /var/run/docker.sock
            '''
        }
    }
    stages {
        stage('Clone repository') {
            steps {
                script{
                    checkout scm
                }
            }
        }

        stage('Building image') {
            steps {
                container('docker') {
                    script {
                        dockerImage = docker.build(env.REGISTRY + ":${env.BUILD_NUMBER}")
                    }
                }
            }
        }

        stage('Anchore analyse') {
            steps {
                writeFile file: 'anchore_images', text: 'docker.io/maartensmeets/spring-boot-demo'
                anchore name: 'anchore_images'
            }
        }

        stage('Deploy to K8s') {
            steps {
                withKubeConfig([credentialsId: 'jenkins_sa_token']) {
                    sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"'
                    sh 'chmod u+x ./kubectl'
                    sh './kubectl apply -f litecoin.yaml'
                }
            }
        }
    }
}