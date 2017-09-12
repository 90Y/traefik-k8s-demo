#!/bin/bash

minikube delete
sudo sed -i '' '/minikube/d' /etc/hosts
