#!/bin/bash

# Setup for brew
brew update
brew install kubectl
brew cask install minikube

# Utilize Xhyve on Mac
# brew install docker-machine-driver-xhyve
# sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
# sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
# minikube start --vm-driver=xhyve

# Without Xhyve
minikube start

# Give it a little bit
sleep 15s

# Checks
# kubectl config set-context minikube
kubectl get componentstatus
kubectl cluster-info

# Throw dashboad
# kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
minikube dashboard

###  Deploy Traefik

# Set up Role Based Access Control
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-rbac.yaml

# Set up Traefik DaemonSet
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/traefik-ds.yaml

# Show nodes
kubectl --namespace=kube-system get pods

# Wakeup cURL
curl $(minikube ip)

# Set up Traefik UI
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/ui.yaml

# Verify pods are running
kubectl --namespace=kube-system get pods

# Set up mock sites
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/cheese-deployments.yaml
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/cheese-services.yaml
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/master/examples/k8s/cheese-ingress.yaml

# Put in hosts
echo "$(minikube ip) stilton.minikube cheddar.minikube wensleydale.minikube traefik-ui.minikube" | sudo tee -a /etc/hosts

# Throw UI
minikube service --namespace=kube-system traefik-web-ui

echo "Visit http://traefik-ui.minikube/"
