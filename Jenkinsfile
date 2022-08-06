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
                    - name: trivy
                      image: aquasec/trivy:0.30.4
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
                script {
                    checkout scm
                }
            }
        }

        stage('Build image') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    container('kaniko') {
                        sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --insecure --skip-tls-verify --no-push --tarPath image.tar --destination=lsvazquez/litecoin:latest'
                    }
                }
            }
        }

        stage('Scan image') {
            steps {
                container('trivy') {
                    sh 'trivy image --input image.tar'
                }
            }
        }

        stage('Push image') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    container('crane') {
                        sh 'crane auth login -u lsvazquez -p dckr_pat_7Uss7PQOPOEjs2YRNRTW5rfyEkQ docker.io'
                        sh 'crane push image.tar docker.io/lsvazquez/litecoin:latest'
                    }
                }
            }
        }

        stage('Deploy to K8s') {
            steps {
                script {
                    kubernetesDeploy(configs: "litecoin.yaml", kubeconfigId: "kubernetes")
                }
            }
        }
    }
}