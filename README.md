# quick_ec2_ubuntu_CKS

This EC2 is for quick testing for CKS preparation. 1 control and 2 worker nodes. 

Uses Ubuntu AMI. 40G root volume.

Installs Docker, Git, k8s via user data.

# Deployment

1. Run the terraform apply command.
2. Once apply is complete. Run  hostscript.py python file. update etc/hosts file with the output from hostscript.py script.
3. Login to all 3 nodes and add the hostname ve ips from step 2.


4. create cluster with kubeadm:

```
 sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.23.0
 ```

5. Once you see below command. Run the below commands.

Your Kubernetes control-plane has initialized successfully!
```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

6. Run kubeadm join command from worker nodes.
```
sudo kubeadm join 172.31.9.249:6443 --token rs2bkd.utdhn7jmiao0n6ke \
        --discovery-token-ca-cert-hash sha256:030f242c3dc2fa125f5d403df6b782901bc152eaf2d2750e5fab3ce697e65060

```

7. Install network solution calico
### calico
```
kubectl create -f https://projectcalico.docs.tigera.io/manifests/tigera-operator.yaml

kubectl create -f https://projectcalico.docs.tigera.io/manifests/custom-resources.yaml

watch kubectl get pods -n calico-system

Weave : 
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```
8. Remove the taint from control node
```
kubectl taint nodes --all node-role.kubernetes.io/master-
```

