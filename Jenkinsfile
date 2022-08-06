pipeline {
    agent {
        kubernetes {
            yaml '''
                apiVersion: v1
                kind: Pod
                spec:
                    containers:
                    - name: kaniko
                      image: gcr.io/kaniko-project/executor:v1.6.0-debug
                      imagePullPolicy: Always
                      command:
                      - sleep
                      args:
                      - 99d
                      volumeMounts:
                        - name: jenkins-docker-cfg
                          mountPath: /kaniko/.docker
                    - name: crane
                      image: gcr.io/go-containerregistry/crane:debug
                      imagePullPolicy: Always
                      command:
                      - sleep
                      args:
                      - 99d
                    volumes:
                    - name: jenkins-docker-cfg
                      projected:
                        sources:
                        - secret:
                            name: regcred
                            items:
                              - key: .dockerconfigjson
                                path: config.json
            '''
        }
    }
    stages {
        stage('Clone repository') {
            steps {
                script {
                    checkout scm
                }
            }
        }

        stage('Build image') {
            steps {
                container('kaniko') {
                    sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --insecure --no-push --tarPath image.tar --skip-tls-verify --cache=true --destination=lsvazquez/litecoin:latest'
                }
            }
        }

        //stage('Anchore analyse') {
        //    steps {
        //        writeFile file: 'anchore_images', text: 'docker.io/lsvazquez/litecoin'
        //        anchore name: 'anchore_images'
        //    }
        //}

        //stage('Push image') {
        //    steps {
        //        container('kaniko') {
        //            sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --insecure --no-push --tarPath image.tar --skip-tls-verify --cache=true --destination=lsvazquez/litecoin:latest'
        //        }
        //    }
        //}

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