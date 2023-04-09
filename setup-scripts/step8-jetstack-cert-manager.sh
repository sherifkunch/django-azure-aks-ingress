#The just created Ingress controller applies the TLS layer 
#to the Load Balancer and therefore the decryption burden 
#is put on the Load Balancer and not the server itself. 
#This improves performance of your service and also let us 
#configure HTTPS certificates using Jetstack/Cert-Manager 
#which provides automated Let’s Encrypt certificates for our service.

#Install Jetstack/Cert-Manager
#In step 4 we configured Helm 3 and added their stable chart repository, 
#in this repository resides a cert-manager chart as well.
# But this version is depreciated, therefore use the official chart repository of jetstack.io.

 helm repo add jetstack https://charts.jetstack.io

 #Update the local Helm chart repository cache to fetch any updates.

helm repo update

#We have to apply the Custom Resource Definitions (CRDs) to the cluster as part of the Helm 3 release.

#Note that it is important that you have the earlier defined
# Kubernetes version 1.16.8+ running on your cluster. 
#Also don’t apply the CRDs manually to your cluster, 
#they can have issues with custom namespace names.

#Install Jetstack/Cert-Manager.
helm install \
  cert-manager jetstack/cert-manager \
  --namespace djaks \
  --version v1.11.0 \
  --set installCRDs=true

#You can verify that the installation was successful by checking the namespace for running pods. 
#You should see three cert-manager pods running!

kubectl get pods --namespace djaks

#Create an ACME ClusterIssuer

#ACME stands for Automated Certificate Management Environment (ACME). 
#This issuer type represents a single account and generates a private key with which it identifies 
#the service with the provided ACME server. 
#As we want to issue the certificates for the scope of the cluster,
#let’s use a ClusterIssuer resource. You can find more on Issuers here (https://cert-manager.io/docs/concepts/issuer/). 
#Let’s checkout the ClusterIssuer manifest file.

# k8s/cluster-issuer.yaml

#As you can see I have added both the configuration for staging and production.
#We specify the v2 API ACME server that Let’s Encrypt provides, you can check out their
#API announcements to see if there are any updates. Furthermore we 
#specify a HTTP01 solver to complete the validation challenge.
#This means that cert-manager will spin up a small web server with a verification file so Let’s Encrypt can validate our domain ownership.

cd k8s
 kubectl apply -f cluster-issuer.yaml --namespace djaks