# Guusto_Project _solution
Solution for Guusto project

This project is to deploy java-based merchant-service and shopping-service applications. The microservies is hosted in Eks kubernetes cluster with infrastructure provisioned using Terraform.

# Step 1: Cloning the bitbucket repo unto local machine
Create a directory Guusto_Project _solution on the local
On the local, run the git clone <url> to clone the repo unto your local computer.
  Check the files including the pom.xml
  Create the deployment and k8s-eks-aws folders in this same directory.
  
# Step 2: Creating the docker images
  Create a Dockerfile which is used to create docker image for application. Since the application is a java based, Maven is as build tool to create the .jar artifacts in target folder. The Docker file contains instructions to use maven as a base image and then copies the the pom.xml and src files to build an artiifact. 
  Then use dependencies from this artifact along with an image from alphine to create a new image for the merchant and shopping applications 
  To build the image in the local repo, run the following commands on a docker server on Ubuntu

  docker build - t <nameofImage>:Tag . e.g. docker build -t steph/merchant:latest .
                                            docker build -t steph/shopping:latest .

  The image is then used to to Run the container in detachable mode,

  docker run -d -p 8081:8081 steph/merchant:latest
  docker run -d -p 8082:8082 steph/shopping:latest
  (-d = detachable mode -p = port forwarding)
  
  Push the image to a public registry (Note: you may be required to authenticate in docker) This will allow for developers to be able to pull the image directly to their local repo
  docker push <ImageName>:Tag  e.g. docker push steph/merchant:latest
                                    docker push steph/shopping:latest
  
# Step 3: Creating a docker-compose file
  
  Create a docker-compose.yml file for the merchant and shopping services application. This generates the manifest files
    Run kompose convert 
    to convert the docker-compose.yml file into the corresponding deployment.yml, service.yml and cicdnetwork-networkpolicy.yml files.
  
  These files are used to deploy the corresponding applications in the eks cluster using
    kubectl apply -f <NameofDeployment>,<NameofService>,<NameofNetworkPolicy>  #(This stage is done only after the eks infrastructure has been provisioned as in Step 3 below)
  
# Step 4: Provision an AWS Kubernetes cluster (eks) using Terraform
  
  Navigate to the Terraform manifest file k8s-eks-aws, and run Terraform init, Terraform validate, Terraform Plan, Terraform Apply
    terraform apply --auto-approve will provision the entire infrastructure by automating the process.
  
  Two outputs are generated which will be used to copy the kubeconfig file from kubernetes.
    Run the following to copy the kubeconfig file
    aws eks update-kubeconfig --name main-vpc-cluster --region us-east-1 #(Enure that your AWS CLI is running the latest version)
    This copies the kubeconfig from aws to the local repo which allows for the ability to run your k8s CLI (kubectl) for access of Kubernetes cluster
  
  To check running pods, run the following command
    kubectl get pods -o wide
  
  Deploy the application to the eks cluster using
    kubectl apply -f <NameofDeployment>,<NameofService>,<NameofNetworkPolicy>
  
  To check for running deployments, run the following command
    kubectl get deployments
  
# Step 5: Push all the working folders to GitHub
  From the local environment, run the following commands to push the work unto GitHub
    git add .
    git commit -am "message"
    git remote add origin <urlofGitHubRepo>
    git branch -M main
    git push -u origin main
  
  
  
