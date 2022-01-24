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

I tested the execution times and if we're running the all steps waiting for each other vs running the first three simultaneously the time improvement is nearly a minute.

Building a docker image and publishing on a public DockerHub repo is done using [Moby BuildKit](https://github.com/moby/buildkit) which includes caching.

## Docker

Dockerfile had it's evolution from a pre-baked image (ruby.2.6) to using alpine. The size and compilation times are gigantic.

The optimisation is easy and contains next steps:
* Use linux `alpine`;
* Use `apk` package manager to install some basic packages (as `bash`, `build-base`, `curl-dev`) and `ruby`;
* Delete the `apk` cache.

Results:
```
REPOSITORY              TAG       IMAGE ID       CREATED              SIZE
(pre-baked) tcp_server              v0.2        21215c31dd1e   40 seconds ago       819MB
(alpine)   tcp_server              v0.1        39cec07d698f   About a minute ago   253MB
```

## Terraform
Terraform is a declarative IaC tool that enables easily to deploy infrastructure on more than a 100 providers.

This is a manual step, because deployments don't need to be done on every merge.


## Code


Future improvements:

Terraform remote state
Host docker on a docker registry and use DigitalOcean's Kubernetes
Automatically update docker image (using bash script, watchtower or )

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