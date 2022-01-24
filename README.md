# Telerik DevOps upskill final exam

# TL;DR

This repo contains a workflow that combines GitHub Actions, Docker and terraform. Main purpose is repo is demonstrating the capabilities of the three technologies combined with a branching strategy and a pinch of security.

## Branching strategy
For this repo I'm using Feature Branching/GitHub flow strategy, because:
* Features that are introduced are very small and self sufficient;
* I want to keep close to the master branch;
* Fast feedback loops for the CI part;
* Minimal number of branches (ideally one working branch at a time) to avoid merge conflicts.

## GitHub Actions

The trigger of the GitHub Actions is pushing a code to the master branch. Then number of actions are started:
* Linter (rubocop);
* Vulnerability scanners (brakeman, Snyk);
* Static Application Security Testing - SonarCloud
* Notifications via Slack
* Build Docker image and push it to Docker Hub

When triggered the first three steps are running simultaneously and building the docker image and slack notification starts when the first are completed successfully.

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