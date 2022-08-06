Prerequisites:
- Helm
- Docker
- kubectl
- k8s cluster

* Run ``sh deploy_anchore_jenkins_to_k8s.sh``
* Get the Jenkins password: ``kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo``
* Port forward to the Jenkins pod: ``kubectl --namespace jenkins port-forward svc/jenkins 8080:8080``
* Access http://127.0.0.1:8080 with "admin" user and the pass retrieved from step 2
* Install *Docker Pipeline* and *Kubernetes CLI* plugins
* Configure GitHub credentials