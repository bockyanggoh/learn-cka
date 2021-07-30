# Overview

Namespaces are virtual clusters backed by the same physical cluster. Kubernetes objects such as pods and containers
live in namespaces. Namespaces are a way to seperate and organize objects in your cluster.


```kubectl get namespaces```

Default namespace is used if no namespace is specified

```kubectl get pods --namespace my-namespace```

```kubectl create namespace my-namespace```
