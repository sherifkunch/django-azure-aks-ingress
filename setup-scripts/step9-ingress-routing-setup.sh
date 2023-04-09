#The Django web application is now only exposed internally on your cluster. 
#As you can see in the listed services from the previous’ step last command, 
#the application is now internally accessible via port 80. 
#You won’t be able to access your application via your public IP yet. 
#For that we need to configure the Ingress routing! 
#As we have already set up the Ingress controller in step 6 we now only have to supply it with the Ingress routing rules.

#Define the Ingress rules
#Let’s have a look at the Ingress routing file.

# k8s/ingress-routing.yaml

# --- kind — This object is declared an Ingress.
# --- metadata.name — The Ingress is named ingress-resource-rules.
# --- annotations.kubernetes.io/ingress.class — We specify that we want this Ingress to be applied at the nginx Ingress controller we installed in step 6.
# --- annotations.cert-manager.io/cluster-issuer — We let the cert-manager sub-component ingress-shim know that we want to automatically create a certificate object for our host.
# --- annotations.nginx.ingress.kubernetes.io/rewrite-target — This is a very useful method to configure rewrite annotations for your host paths, i.e. configuring sub-domains.
# --- hosts — The earlier assigned FQDN.
# --- hosts.secretName — The TLS private key and certificate reference to the Secret resource that secures the channel from the client tot the Load balancer with TLS.
# --- backend.serviceName — The reference to the earlier created Service.
# --- backend.servicePort — The internal port where the service is exposed.
# --- backend.path — The public path where we want to expose the service, in this case at the root domain level.

#Apply the Ingress to your cluster.

kubectl apply -f ingress-routing.yaml --namespace djaks

#Configure the Django allowed host
#Now navigate to your application domain i.e. django-aks-ingress.westeurope.cloudapp.azure.com.
#
#If you haven't changed the DEBUG = True setting in your Django settings.py file, you should see that the application throws a disallowed host error. Let’s fix this!
#
#Go to the settings.py file and add your FQDN domain to the ALLOWED_HOSTS list.

ALLOWED_HOSTS = ['django-aks-ingress.westeurope.cloudapp.azure.com']

#Note that some guides or tutorials advice you to set ALLOWED_HOSTS = [*], but this is a serious security loophole. Don’t do this!

#Now re-build the Docker container image of your new application version locally.

docker build -f Dockerfile -t django-aks:v1.0.1 .

#I highly recommend making a clear distinction between building container images on your local development machine and on your remote registry. 
#By building them twice you can work safely with local back-ups and easily retrace your steps when something goes wrong. 
# Perhaps superfluously, make sure to tag your images properly with your own versioning convention — 
#I recommend semantic versioning — as this makes a rollback to a previous application version easier.

#Tag the image for your remote ACR registry.

docker tag django-aks:v1.0.1 djangoaksregistrytest.azurecr.io/django-aks:v1.0.1

#Push the image to the ACR registry.

docker push djangoaksregistrytest.azurecr.io/django-aks:v1.0.1

#If you get an authentication error, login to the ACR registry and try again.

az acr login --name djangoaksregistrytest

#Now we have to let the cluster know that we want to update our django-web-app Deployment.

kubectl set image deployment django-web-app django-web-container=djangoaksregistrytest.azurecr.io/django-aks:v1.0.1 --namespace djaks

#That’s it! Browse to your FQDN domain in a new tab in the browser and you should see the 
#web application up and running with a secured ‘lock’ sign in your browser bar. 
#If you still see an insecure HTTP warning, make sure to remove your browser cache.



