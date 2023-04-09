#We specify a few parameters to let Azure know how we want to configure the Kubernetes cluster. 
#We make sure that the AKS cluster is put in the same resource group as the ACR registry. 
#We give it a convenient name that is easy to remember. 
#Then we define that the cluster has to be build on top of two nodes which — 
#in this case — are assigned the smallest available cluster Virtual Machine size. 
#We are obviously not going to run resource demanding services in the cluster and we also don’t expect that many traffic for now. 
#Now set the Kubernetes version to one of the latest stable supported versions on Azure and auto-generate the SSH keys.

az aks create \
--resource-group djangoAKS \
--name djangoaks-cluster \
--node-count 2 \
--node-vm-size Standard_B2s \
--generate-ssh-keys 

#To manage your Kubernetes cluster, you will need kubectl,
# the Kubernetes command-line client tool. You can easy install kubectl with the Azure CLI.

az aks install-cli

#Now configure kubectl to connect to your AKS cluster, the credentials will be downloaded on the background
#and the context of the Kubernetes command-line tool will be set to your cluster.

az aks get-credentials --resource-group djangoAKS --name djangoaks-cluster

#Verify that the connection from your development machine to the AKS cluster is working by checking the status of the nodes you created previously.

kubectl get nodes

#You should see an output describing the two nodes with the status Ready.

#Now as your first act as cluster-manager, create a Kubernetes namespace for the resources we are going to create in the next steps.

kubectl create namespace djaks

