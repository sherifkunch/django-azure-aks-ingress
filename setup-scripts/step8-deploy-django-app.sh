#It’s time to deploy the Django application! 
#In order to do so we will apply both a Deployment 
#and a Service manifest to our cluster. 
#I will describe the workings of the files after the code embeds.

#Apply the Deployment manifest

# k8s/webapp-deployment.yaml

# --- kind — This object is declared a Deployment.

# --- metadata.name — The Deployment is named django-web-app.
# --- metadata.labels.app — The app label is used for specification references.
# --- replicas — This is where the earlier discussed ReplicaSet is managed, this means that two Pods of the application will be deployed.
# --- containers.name — The given name for the container instance inside the Pod.
# --- containers.PullPolicy — The PullPolicy is set on Always to force kubelet in always doing an image pull when starting the Pod.
#This configuration comes in handy during the development process when you want to make sure that the 
#Pods are always pulling the latest image with a specific tag when they are created. In production you can use i.e. IfNotPresent.
# --- containers.image — The container image of your application, we pushed the container to the ACR registry in step 2!
# --- containers.ports.containerPort — The port that needs to be exposed inside the Pod, this must be the same port(s) as we specified in the Dockerfile.
# --- env — A very useful method to supply environment variables to your container environment, for example purposes I supplied the hostIP.
# --- imagePullSecrets — Because we have integrated ACR with the AKS cluster in step 5 we can point towards the ACR pull secret for authentication.

#Apply the Deployment manifest to the cluster.
kubectl apply -f webapp-deployment.yaml --namespace djaks

#You can verify that the django-web-app Pods are running correctly by checking them out! First list the pods. 
#The STATUS should be showing that they are RUNNING within a few minutes.

kubectl get pods --namespace djaks

#If something went wrong you can look at the events that happened 
#in the Pod by asking kubectl to describe the Pod. 
#You need to specify a specific Pod name of the Pods you listed in the previous command.

kubectl describe pod django-web-app-bb8c5d45c-4zklt --namespace djaks


#Apply the Service manifest

# k8s/webapp-service.yaml

# --- kind — This object is declared a Service.
# --- metadata.name — The Service is named webapp.
# --- spec.type — The service is exposed on an internal IP with the ClusterIP ServiceSpec. This means that the service is only accessible from within the cluster, the Ingress controller will be publicly exposed and route the traffic to your application as we will see in a moment.
# --- ports.port — The Service will be inside the cluster exposed on port 80, other Pods can communicate with the Service via this port.
# --- ports.targetPort — This is the port where the Service will send requests to, in this case port 8010. The Pod will be listening to this port, the application in the container needs to listen to the same port!
# --- selector.app — Here we specify to which app this Service manifest applies, we apply the Service to the app we created previously in the Deployment.

# Apply the Service manifest to the cluster.

kubectl apply -f webapp-service.yaml --namespace djaks

#You can verify now that the webapp service is available.

kubectl get svc --namespace djaks





