

# Set no Sudo PW
echo "$USER ALL=(ALL) NOPASSWD: ALL" > sudo visudo

ip1="$1"
hostname1="$2"
ip2="$3"
hostname2="$4"
ip3="$5"
hostname3="$6"

# Adding host and hostnames
sudo echo "$ip1 $hostname1" > /etc/hosts
sudo echo "$ip2 $hostname2" > /etc/hosts
sudo echo "$ip3 $hostname3" > /etc/hosts

cat /etc/hosts

# sys level adjustments

cat << EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward =  1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

# Install Containerd
sudo apt-get update && sudo apt-get install -y containerd

# Configure Containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

sudo systemctl restart containerd

# Turn off Swap
sudo swapoff -a

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Install required packages 
sudo apt-get update && sudo apt-get install -y apt-transport-https curl

# Install Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update

sudo apt-get install -y kubelet=1.21.0-00 kubeadm=1.21.0-00 kubectl=1.21.0-00

sudo apt-mark hold kubelet kubeadm kubectl


# Control Plane only!
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.21.0

# Kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Network Setup
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# Generate Command for worker nodes
kubeadm token create --print-join-command