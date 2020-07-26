Minikube-Lab
============
This repo contains a few scripts and YAML files to quickly bootstrap a Minikube lab environment in a semi-production quality fashion
for the purpose of rapid development of Kubernetes resources without having to spin up a full development cluster.  
This repo is really meant for my personal use but I'm open sourcing it for those who may find it useful.

Getting Started
------------
**Assuming a Mac workstation** you will need to do the following to get started:

1. Install [Homebrew](https://brew.sh)
2. `brew cask install minikube vmware-fusion docker` (Note: Installing VMware Fusion outside of brew may cause vmrun errors)
3. `brew install docker-machine-driver-vmware docker`
4. Run the [customStart.sh](SourceCode/customStart.sh) to start Minikube using some custom parameters

Minikube Custom Parameters
--------------------------
The lab environment I use runs Minikube with a few custom parameters:

1. Use VMware as the provider instead of VirtualBox
2. 4 vCPUs
3. 4GB RAM
4. Setting the VMware Fusion subnet as an insecure registries subnet (This permits running a registry inside Minikube)

Configuring The Lab Environment
-------------------------------
Once Minikube is up you should verify the IP it was assigned is in the range inside the code in this repo. If it is not
then you will need to edit [customStart.sh](SourceCode/customStart.sh), and the
[MetalLB yml file](SourceCode/core-infra/05-metallb-loadbalancer.yml) to point to the correct IP range Minikube
uses on your machine and then run `minikube delete` followed re-running the customStart.sh script.

After any IP changes are sorted out to build the lab out to a minimum standard do the following:

1. Set your local docker environment to use the IP of the registry found in `kubectl get svc -n registry`
2. Pull `ahrenstein/debugging:latest` from Docker Hub, tag it as `{YOUR REGISTRY IP:PORT}/ahrenstein/debugging:latest
and push it
3. Edit [01-test-site.yml](SourceCode/pods/01-test-site.yml) to point to the newly pushed container
4. `kubectl apply -f SourceCode/pods/01-test-site.yml`
5. Get the svc address of the test site from the `kube-public` namespace and visit it to verify it works
6. Develop whatever it is you needed to develop!

Kubernetes Dashboard
--------------------
The [Kubernetes Dashboard file](SourceCode/core-infra/04-kubernetes-dashboard.yaml) is provided by "The Kubernetes Authors"
under the Apache 2.0 license and is their original work.  
You can access the [dashboard URL](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default)
using the admin-token secret with `kubectl proxy`.

Caveats
-------
There are a few small caveats that come with this lab:

1. The code in this repo assumes the IP range `172.16.148.0/24` as that is what Minikube is using via VMware Fusion
on my workstation. This may be different on your machine, so you may need to adjust some code to get things working.
2. The [registry](SourceCode/core-infra/06-registry.yml)'s PV stores files in /data on the Minikube VM so deleting Minikube
will result in data loss
