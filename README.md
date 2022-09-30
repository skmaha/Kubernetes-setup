# Kubernetes-setup
Setup Kubernetes on Centos7
## Pre-requisites
1. Vagrant installed
2. Oracle Virtual Box installed
3. Create virtual network connection on VirtualBox
4. Update the Vagrant file with IP Address as per the network connection created.

5. clone the repo
6. cd Kubernetes-setup
7. vagrant up

### Kubernetes Commands
1. kubectl get all --all-namespaces
2. kubectl get pod --all-namespaces
3. kubectl get service --all-namespaces
4. kubectl get serviceaccount --all-namespaces
5. kubectl describe deployment deployment-name
6. kubectl describe po pod-name
7. kubectl describe svc svc-name
8. kubectl cp file-name pod-name:/path/to/file/location/
9. kubectl rollout restart deployment [deployment_name]
10. kubectl set env deployment [deployment_name] DEPLOY_DATE="$(date)"
11. kubectl scale deployment [deployment_name] --replicas=1
13.


### Kubernetes full course
https://www.youtube.com/watch?v=d6WC5n9G_sM
### Docker commands
```
kubectl create secret docker-registry private-docker-cred \
    --docker-server=myregistry
    --docker-username=registry-user
    --docker-password=registry-password
    --docker-email=registry-user@example.com
                                # Create a secret for docker-registry

ocker login -u USER_NAME -p TOKEN REGISTRY_URL   # before we push images, we need to 
                                                    login to docker registry.
                                  
docker login -u developer -p ${TOKEN} docker-registry-default.apps.lab.example.com  # TOKEN can be get as TOKEN=$(oc whoami)
                                
docker images --no-trunc --format ' ' --filter "dangling=true" --filter "before=IMAGE_ID"
                                # list image with format and 
                                # using multiple filters       
docker create [IMAGE]           # Create a new container from a particular image.
docker search [term]            # Search the Docker Hub repository for a particular term.
docker login                    # Log into the Docker Hub repository.
docker pull [IMAGE]             # Pull an image from the Docker Hub repository.
docker push [username/image]    # Push an image to the Docker Hub repository.
docker tag [source] [target]    # Create a target tag or alias that refers to a source image.
docker build [OPTIONS] PATH
docker build --help
  -t, --tag - set the name and tag of the image
  -f, --file - set the name of the Dockerfile
  --build-arg - set build-time variables
docker start [CONTAINER]        # Start a particular container.
docker stop [CONTAINER]         # Stop a particular container.
docker exec -ti [CONTAINER] [command]  # Run a shell command inside a particular container.
docker run -ti — image [IMAGE] [CONTAINER] [command]  # Create and start a container at the same time, and then run a command inside it.
docker run -ti — rm — image [IMAGE] [CONTAINER] [command] # Create and start a container at the same time, 
                                                          # run a command inside it, and then remove container 
                                # after executing the command.
docker pause [CONTAINER]        # Pause all processes running within a particular container.
docker history [IMAGE]          # Display the history of a particular image.
docker ps                       # List all of the containers that are currently running.
docker version                  # Display the version of Docker that is currently installed on the system.
docker images                   # List all of the images that are currently stored on the system.
docker inspect [object]         # Display low-level information about a particular Docker object.
docker kill [CONTAINER]         # Kill a particular container.
docker kill $(docker ps -q)     # Kill all containers that are currently running.
docker rm [CONTAINER]           # Delete a particular container that is not currently running.
docker rm $(docker ps -a -q)    # Delete all containers that are not currently running.
docker network ls               # list available networks
```
Dockerfile
FROM - to set the base image RUN - to execute a command COPY & ADD - to copy files from host to the container CMD - to set the default command to execute when the container starts EXPOSE - to expose an application port
###Sample Docker file
```
FROM registry.access.redhat.com/rhscl/nodejs-6-rhel7
EXPOSE 3000
# Mandate that all Node.js apps use /usr/src/app as the main folder (APP_ROOT).
RUN mkdir -p /opt/app-root/
WORKDIR /opt/app-root

# Copy the package.json to APP_ROOT
ONBUILD COPY package.json /opt/app-root

# Install the dependencies
ONBUILD RUN npm install

# Copy the app source code to APP_ROOT
ONBUILD COPY src /opt/app-root

# Start node server on port 3000
CMD [ "npm", "start" ]
```
