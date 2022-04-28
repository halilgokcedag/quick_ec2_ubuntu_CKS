# quick_ec2_ubuntu_CKS

This EC2 is for quick testing for CKS preparation. 

Uses Ubuntu AMI. 40G root volume.

Installs Docker, Git via user data.


update etc/hosts file with the output from hostscript.py script.

# workaround başlangıç - kubelet systemd için
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
# workaround son

create cluster with kubeadm:

'''
 kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0
 '''



sonuç!!
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 172.31.9.249:6443 --token rs2bkd.utdhn7jmiao0n6ke \
        --discovery-token-ca-cert-hash sha256:030f242c3dc2fa125f5d403df6b782901bc152eaf2d2750e5fab3ce697e65060
ubuntu@ubuntuk8s-1:~$


# calico

kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml

kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

watch kubectl get pods -n calico-system

kubectl taint nodes --all node-role.kubernetes.io/master-
