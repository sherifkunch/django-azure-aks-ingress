
#Connect AKS with ACR with Azure AD

# As we host some of our application container images in ACR, it is essential that the AKS cluster
# can communicate with the container registry. When we configure the communication between the two services,
# Active Directory will handle the authentication on the background.

az aks update -n djangoaks-cluster -g djangoAKS --attach-acr djangoaksregistrytest