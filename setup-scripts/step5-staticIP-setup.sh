#We need this resource group name for now, to create a public IP address as public access point for our cluster.
#Without assigning a static IP address to the NGINX Ingress controller later on,
#the IP address created by the controller itself is only valid for the life-span of the controller itself. 
#When we want to point a custom domain name to our service for example, 
#we need a static IP address to work with to keep our web application publicly available.


#Let’s find out what the exact name of the node resource group is.

az aks show --resource-group djangoAKS --name djangoaks-cluster --query nodeResourceGroup -o tsv

#In my case the name of the node resource group is MC_djangoAKS_djangoaks-cluster_westeurope. 
#Now create the public IP address.
# Make sure to use the Standard SKU. 
#The cluster Load Balancer requires that the static IP address is of the same tier.

az network public-ip create \
--resource-group MC_djangoAKS_djangoaks-cluster_westeurope \
--name djangoAKSPublicIP \
--sku Standard \
--allocation-method static \
--query publicIp.ipAdress \
-o tsv

#Now let’s find out what the actual IP address is. The static IPv4 address should be visible under ipAddress.

az network public-ip show \
--resource-group MC_djangoAKS_djangoaks-cluster_westeurope \
--name djangoAKSPublicIP

#In my case is: 13.95.20.174
