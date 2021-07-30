## Notes

### Steps for Upgrading Control Plane Node
- Upgrade kubeadm on the control plane node
- Drain the control plane node
- Plan the upgrade using kubeadm
- Apply the upgrade using kubeadm
- Upgrade kubelet and kubectl on the control plane node
- Uncordon the control plane node

```bash
kubectl drain k8s-control --ignore-daemonsets
# Upgrade Kubeadm
sudo apt-get upgrade && \
sudo apt-get install -y --allow-change-held-packages kubeadm=1.21.1-00
# Show kubeadm version
kubeadm version
# Generate Upgrade Plane
sudo kubeadm upgrade plan v1.21.1
# Install Update of held packages
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubelet=1.21.1-00 kubectl=1.21.1-00
# Restart services
sudo systemctl daemon-reload
sudo systemctl restart kubelet
# Uncordon node
kubectl uncordon k8s-control
# Check
kubectl get nodes
```

#### Output from Plan
```
W0730 08:14:27.846526   21428 kubelet.go:275] The 'cgroupDriver' value in the KubeletConfiguration is empty. Starting from 1.22, 'kubeadm upgrade' will default an empty value to the 'systemd' cgroup driver. The cgroup driver between the container runtime and the kubelet must match! To learn more about this see: https://kubernetes.io/docs/setup/production-environment/container-runtimes/
Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       TARGET
kubelet     3 x v1.21.0   v1.21.1

Upgrade to the latest version in the v1.21 series:

COMPONENT                 CURRENT    TARGET
kube-apiserver            v1.21.0    v1.21.1
kube-controller-manager   v1.21.0    v1.21.1
kube-scheduler            v1.21.0    v1.21.1
kube-proxy                v1.21.0    v1.21.1
CoreDNS                   v1.8.0     v1.8.0
etcd                      3.4.13-0   3.4.13-0

You can now apply the upgrade by executing the following command:

	kubeadm upgrade apply v1.21.1

_____________________________________________________________________


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
_____________________________________________________________________
```


### Steps for Upgrading Worker Node
- Drain the node
- Upgrade kubeadm
- Upgrade kubelet configuration
- Upgrade kubelet and kubectl
- Uncordon the node

```bash
# Drain Node
kubectl drain k8s-worker1 --ignore-daemonsets --force
# Upgrade Kubeadm
sudo apt-get upgrade && \
sudo apt-get install -y --allow-change-held-packages kubeadm=1.21.1-00
# Upgrade kubeadm
sudo kubeadm upgrade node
# Install Update of held packages
sudo apt-get update && \
sudo apt-get install -y --allow-change-held-packages kubelet=1.21.1-00 kubectl=1.21.1-00
# Restart services
sudo systemctl daemon-reload
sudo systemctl restart kubelet
# Uncordon node
kubectl uncordon k8s-control
```
