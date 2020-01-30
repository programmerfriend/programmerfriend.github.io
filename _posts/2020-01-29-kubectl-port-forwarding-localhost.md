---
layout: post
title: "Use Kubectl port-forwarding to Forward Ports to Localhost"
bigimg: /img/content/kubectl_port_forward-title.jpg
share-img: https://programmerfriend.com/img/content/kubectl_port_forward-title.jpg
tags: [developers, kubernetes]
---

More often than I'd like to admit, I use Port Forwarding to troubleshoot issues with my deployed Kubernetes services.

Port Forwarding can be setup for *Pods*, *Deployments* *ReplicaSets* and *Services*.

## Quick reference for different resource types:

The syntax is:
```
kubectl port-forward <kubernetes-resource-name> <locahost-port>:<pod-port>
```

For example:
`kubectl port-forward my-awesome-pod 1337:8080` will forward *8080* from the pod to *1337* on localhost.

### Pods

```
kubectl port-forward nginx-master-345fadbad1-abcd 1337:80 
```

alternative syntax for pods

```
kubectl port-forward pods/nginx-master-345fadbad1-abcd 1337:80
```
### Deploymemts

```
kubectl port-forward deployment/nginx-master 1337:80 
```

### ReplicaSets
```
kubectl port-forward rs/nginx-master 1337:80
```

### Services
```
kubectl port-forward svc/nginx-master 1337:80
```

After you run these commands the Pod/Deployment/ReplicaSet/Service is available on your machine on port 1337.
Port forwarding has already saved my life in many debugging sessions.