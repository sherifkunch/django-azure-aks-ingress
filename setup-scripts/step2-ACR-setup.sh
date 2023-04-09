#First login to your Azure account, you will be redirected to a login page in your browser. 
#After a successful login you should see a welcome message.

az login

#In order to bundle the Azure-resources for the scope of this article, create a resource group named djangoAKS based at a preferred resource location. 
#We can simply delete this resource group later when we are finished. 
#Deletion of the resource group will clean up all the Azure services and resources related to it.

az group create --name djangoAKS --location westeurope

#Create the ACR resource in the newly created resource group specifying the basic service level. 
#The output should be stating that the operation was successful. Take note of the loginServer variable, 
#this is the qualified registry name, in my case djangoaksregistrytest.azurecr.io.

#Note that the ACR name is public, so choose a convenient and unique lowercase name.

az acr create --resource-group djangoAKS --name djangoaksregistrytest --sku Basic
 
#Pushing the application image to ACR
#We have already built and tagged the Django application container image locally in step 1, 
#with the django-aks:v1.0.0 tag. As the local deployment of the application was successful
#we can now push the local image to the remote ACR container registry.

#First we need to log in to the ACR registry using the Azure CLI.

az acr login --name djangoaksregistrytest

#Then we need to tag the container image with the container repository name and the version. 
#Azure also expects you to provide the registry URI.

docker tag django-aks:v1.0.0 djangoaksregistrytest.azurecr.io/django-aks:v1.0.0

#Complete this part by pushing the container image to your remote ACR registry.

docker push djangoaksregistrytest.azurecr.io/django-aks:v1.0.0

#The container image will be pushed to the remote registry. 
#This process is well-nigh to the process that is the result of the 
#local docker build command. 
#Writing cache-aware Dockerfiles is highly recommended as you pay per build second with ACR.
