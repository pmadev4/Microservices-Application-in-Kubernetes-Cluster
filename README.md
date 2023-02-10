# Microservices-Application-in-Kubernetes-Cluster
Deploying a microservices application to a Kubernetes cluster - Ubuntu - AWS

## Installation
Run the following script:

```bash
#!/bin/bash

# ----- 1 -- Install docker

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
sudo usermod -aG docker ${USER}
sudo chmod 666 /var/run/docker.sock
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc


# ----- 2 --- Install docker-compose

# Install docker-compose
echo "sudo apt-get update ... NOW"
sudo apt-get update
echo "DONE"
echo "Installing docker-compose ... NOW"
sudo curl -L "https://github.com/docker/compose/releases/download/v2.10.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo "DONE"
echo "Change the version in the script if needed"
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc


# ----- 3 --- Install unzip, awscliv2 and kubectl

sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.13/2022-10-31/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
kubectl version --short --client


# ------ 4 --- Install eksctl

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
eksctl version

# ------ 5 --- Install helm

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
helm version

```
## Create the Cluster

```bash
eksctl create cluster
```
By default, “eksctl create cluster” creates worker nodes with the following specifications:
2 vCPUs
8 GiB of memory
AWS instance type: m5.large

## Create a namespace
```bash
kubectl create ns microservices
```

## 1. Deploy the microservices into the namespace using a config file
```bash
kubectl apply -f config.yaml -n microservices
```
```bash
kubectl get svc -n microservices
```
```bash
kubectl get pod -n microservices
```
Copy the LoadBalancer address and paste it into a browser.
#### Delete the app
```bash
kubectl delete -f config.yaml -n microservices
```
## 2. Deploy the microservices into the namespace using Helm Charts
#### Create microservice
```bash
helm create microservice
cd ~/microservice/templates
rm -r tests _helpers.tpl hpa.yaml ingress.yaml NOTES.txt serviceaccount.yaml
```
#### Install helmfile

#!/bin/bash
```bash
# Download the latest release
curl -LO https://github.com/roboll/helmfile/releases/download/v0.144.0/helmfile_linux_amd64

# Rename the file
mv helmfile_linux_amd64 helmfile

# Move the binary to a directory in PATH
sudo mv ./helmfile /usr/local/bin/

# Make the binary executable
sudo chmod +x /usr/local/bin/helmfile

# Verify the installation
helmfile version
```
### Deploy the helmfile
```bash
helmfile sync
```


