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
                    volumes:
                    - name: jenkins-docker-cfg
                      projected:
                        sources:
                        - secret:
                            name: dockercred
                            items:
                              - key: .dockerconfigjson
                                path: config.json
            '''
        }
    }
    stages {
        stage('Clone repository') {
            steps {
                git branch: main,
                    credentialsId: litecoin_ssh,
                        url: 'git@github.com:la-sanchez/litecoin.git'
            }
        }

        stage('Build image') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    container('kaniko') {
                        sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --insecure --skip-tls-verify --cache=true --destination=lsvazquez/litecoin:latest'
                    }
                }
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