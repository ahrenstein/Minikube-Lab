#!/bin/bash
echo "WARNING!: This script assumes minikube and VMware Fusion are installed"

echo "Starting MiniKube with the following settings:"
echo "Provider: vmware"
echo "CPUs: 4"
echo "RAM: 4GB"
echo "Insecure Registry Subnet: 172.16.148.0/24"
minikube start --vm-driver=vmware --memory 4096 --cpus 4 --insecure-registry="172.16.148.0/24"

echo "Running \"minikube status\" to verify IP space for registry and MetalLB"
minikube status
