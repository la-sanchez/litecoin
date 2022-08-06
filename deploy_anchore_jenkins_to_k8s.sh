#!/usr/bin/env bash

 helm repo add anchore https://charts.anchore.io
 helm repo add jenkins https://charts.jenkins.io
 helm repo update

 kubectl create ns anchore
 helm upgrade --install anchore-release -n anchore -f anchore_values.yaml anchore/anchore-engine
 kubectl create ns jenkins
 helm upgrade --install jenkins -n jenkins jenkins/jenkins