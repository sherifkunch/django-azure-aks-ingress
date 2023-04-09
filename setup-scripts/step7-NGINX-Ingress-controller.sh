#Create the NGINX Ingress controller

#It is time to start using the magic from Helm 3. 
#We can instantly deploy an nginx-ingress chart that is already available in de stable Helm repository!


# --- Make sure that you replace the IP address in the command below under --set controller.service.loadBalancerTP with the static IP address you created in the previous step.

# --- Specify your preferable DNS name label under the --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name" 
# --- Azure will create a Fully Qualified Domain Name (FQDN) with the provided DNS prefix.

# --- Note that we install the Ingress controller in the earlier created namespace djaks.

helm install nginx-ingress stable/nginx-ingress \     
--namespace djaks \     
--set controller.replicaCount=2 \     
--set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
--set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
--set controller.service.loadBalancerIP="13.95.20.174" \
--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-dns-label-name"="django-aks-ingress"

#As the response should note, the allocation of the Load Balancer IP can take several minutes.
# You can monitor the progress to see when the EXTERNAL-IP is bound to the nginx-ingress-controller. Use CTRL-C to stop the monitoring

kubectl --namespace djaks get services -o wide -w nginx-ingress-controller

#Azure has created a FQDN when we created the Ingress controller,
# we can access our service via this domain as well. Let’s find out what the domain name is.

az network public-ip list \
--resource-group MC_djangoAKS_djangoaks-cluster_westeurope \
--query "[?name=='djangoAKSPublicIP'].[dnsSettings.fqdn]" -o tsv

