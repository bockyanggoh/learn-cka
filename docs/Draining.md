## Notes
To Drain/Cordon a node means that pods that are running on it
will be removed. 

Notes:
- If a pod is created without deployment, then the pods will be removed without rescheduling onto other nodes
- If a pod is part of a deployment, then the pod will be created on other available nodes

Nodes that are cordoned off will be unavailable for scheduling, meaning new deployments or pods will not be created on those nodes.


## Command to Drain
```kubectl drain node_name```

If you have daemonset pods on there, you should see the following error.

```
error: unable to drain node "k8s-worker2", aborting command...

There are pending nodes to be drained:
 k8s-worker2
cannot delete DaemonSet-managed Pods (use --ignore-daemonsets to ignore): kube-system/calico-node-4p2lw, kube-system/kube-proxy-77vkv
cannot delete Pods not managed by ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet (use --force to override): default/my-pod
```

To overcome this, use the --ignore-daemonsets command. This will skip draining of daemonsets.

```kubectl drain k8s-worker2 --ignore-daemonsets --force```