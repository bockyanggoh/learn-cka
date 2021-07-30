To Drain/Cordon a node means that pods that are running on it
will be removed. 

Notes:
- If a pod is created without deployment, then the pods will be removed without rescheduling onto other nodes
- If a pod is part of a deployment, then the pod will be created on other available nodes

Nodes that are cordoned off will be unavailable for scheduling, meaning new deployments or pods will not be created on those nodes.