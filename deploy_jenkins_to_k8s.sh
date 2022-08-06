#!/usr/bin/env bash

 helm repo add jenkins https://charts.jenkins.io
 helm repo update

 kubectl create ns jenkins
 helm upgrade --install jenkins -n jenkins jenkins/jenkins

 kubectl create secret -n jenkins docker-registry dockercred \
    --docker-server=https://index.docker.io/v1/ \
    --docker-username=lsvazquez \
    --docker-password=dckr_pat_zHeGlnrUcUmD_YI60oTWe39H4KE\
    --docker-email=lsvazquez@outlook.com