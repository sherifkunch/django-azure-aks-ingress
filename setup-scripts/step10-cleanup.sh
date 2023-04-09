#Clean up resources
#If you want to get rid of the created resources, you can clean them up. I will present two clean up options!

#Keep the Azure resources, wipe the cluster namespace
#When you want to keep the Azure resources, then you are good to go by deleting the namespace in which we created the cluster resources.

kubectl delete namespace djaks
#Delete all resources
#When you want to get back to a clean slate and make sure the paid Azure resources are removed as well, delete the Azure resource group we created in the beginning.

az group delete --name djangoAKS
