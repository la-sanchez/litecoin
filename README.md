Prerequisites:
- Helm
- Docker
- kubectl
- k8s cluster

* Fruit
  * Apple
  * Orange
  * Banana 

* Run ``sh deploy_anchore_jenkins_to_k8s.sh``
* Get the Jenkins password running ``kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo``
* Port forward to the Jenkins pod: ``kubectl --namespace jenkins port-forward svc/jenkins 8080:8080``
* Access http://127.0.0.1:8080 with "admin" user and the pass retrieved from step 2
* Install *Anchore Container Image Scanner plugin*
* Go to /configure, *Anchore Container Image Scanner* section. Add the following data: 
  * URL: http://anchore-release-anchore-engine-api.anchore.svc.cluster.local:8228/v1/ 
  * user: admin 
  * pass: Welcome01 (in anchore_params.values)