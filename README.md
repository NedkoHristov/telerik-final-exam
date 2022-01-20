# Telerik DevOps upskill final exam

This repo contains the final exam for the DevOps upskill course.

The repo contains three main points:

1. GitHub - code itself, CI, etc
2. docker files - will be here temporarely before being moved to the terraform part

Create a docker image that runs a ruby script:
```
docker build -t tcp_server .
```

Run the container and expose port 80:
```
docker run -i -t -p 80:80 tcp_server:latest
```
Room for improvement:
* Implementing volume may be a good idea for the demo purpose, because creating and uploading docker images may take some time

3. terraform to create the infrastructure
* Prerequisites to run terraform:
You need to export you DigitalOcean API Token as an environment variable
```
export DIGITALOCEAN_TOKEN="Put Your Token Here"
```