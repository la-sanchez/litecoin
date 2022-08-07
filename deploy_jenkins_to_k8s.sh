#!/usr/bin/env bash

 helm repo add jenkins https://charts.jenkins.io
 helm repo update

 kubectl create ns jenkins
 helm upgrade --install jenkins -n jenkins jenkins/jenkins

 # secret used by Jenkins to push the Docker Litecoin image
 kubectl create secret -n jenkins docker-registry dockercred \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=lsvazquez \
    --docker-password=dckr_pat_7Uss7PQOPOEjs2YRNRTW5rfyEkQ \
    --docker-email=lsvazquez@outlook.com