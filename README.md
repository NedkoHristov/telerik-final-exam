# Telerik DevOps upskill final exam

# TL;DR

This repo contains a workflow that combines GitHub Actions, Docker and terraform. Main purpose is repo is demonstrating the capabilities of the three technologies combined with a branching strategy and a pinch of security.

## Workflow graph
```
┌──────── GitHub                       GitHub actions    ────────────────────►      Terraform
│           │                                │                                          │
│           │                                │                                          │
│           ▼                                │                                          │
│                                            ▼                                          ▼
│     Commit in branch ────────┬───────►  inters                                  Create VM in DO
│                              │             │                                          │
│                              │             │                                          │
│                              │             │                                          │
│                              │             ▼                                          ▼
└────► Push to master  ┌───────┴──►  Build Docker image                         Pull docker image
                       │           (if pushed to `main`)                          from DockerHub
                       │                     │                                          │
                       │                     │                                          │
                       │                     │                                          ▼
                       │                     ▼                                  Run docker image
                       └────────►   Publish docker image                            serve @ :80
                                        on DockerHub
```

## Branching strategy
For this repo I'm using Feature Branching/GitHub flow strategy, because:
* Features that are introduced are very small and self sufficient;
* I want to keep close to the `main` branch;
* Fast feedback loops for the CI part;
* Minimal number of branches (ideally one working branch at a time) to avoid merge conflicts.

## GitHub project
For a basic project management I used [GitHub Project](https://github.com/users/NedkoHristov/projects/1/views/1).

## GitHub Actions

The trigger of the GitHub Actions is pushing a code to the `main` branch. Then number of actions are started:
* Linter (`rubocop`);
* Vulnerability scanners (`brakeman`, `Snyk`);
* Static Application Security Testing - `SonarCloud`
* Notifications via `Slack`
* Build Docker image and push it to Docker Hub

When triggered the first three steps are running simultaneously and building the docker image and slack notification starts when the first are completed successfully.

I tested the execution times and if we're running the all steps waiting for each other vs running the first three simultaneously **the time improvement is nearly a minute**.

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
(alpine)    tcp_server              v0.1        39cec07d698f   About a minute ago   253MB
```

## Terraform
Terraform is a declarative IaC tool that enables easily to deploy infrastructure on more than a 100 providers.
This is a manual step, because deployments don't need to be done on every merge.

Project contains a:
* Provider (`digitalocean` in this case);
* Defining the `droplet` (instance) parameters (`instance type`, `region`, `name` as variables in `variables.tf`);
* User data (in `cloud-init.yaml`)
* Defining SSH key to connect be able to connect to the instance once created;
* cloud-init that provision the instance containing:
    * New group (`hashicorp`) and user (`terraform`), public SSH key;
    * Series of commands that install docker (and sets the correct permissions), pull the docker image and run it

## Code
Very simple http server written in Ruby that responds to a GET request and return a value.

## Repo security
Repo security is done mostly by:
* Using secrets for all tokens and usernames;
* `brakeman` is running as a scheduled action everyday @ `0300`
* Enabled `dependabot security updates` and `dependabot alerts`;

## Observability

Monitoring is done trough two systems:
* Advanced DigitalOcean monitoring system;
* NewRelic (containers and host monitoring).

## Future improvements:

* Terraform remote state;
* Use `containerd` (or `systemd unit`) to keep the docker alive when something went wrong (ex OOM);
* Docker image versioning;
* Show Docker container logs for debugging purposes;
* Host Docker on a DO docker registry and use DO Kubernetes;
* Automatically update docker image (using bash script, watchtower or webhooks);
* Use `terraform vault` for secret management;
* Protected branches.
* Use Git Semantic Version action to tag versions automatically
* Test the glorious webserver on multiple ruby versions and OS
* Implement ArgoCD
* Implement terraform plan as artefact and then use it to tf apply

## Feature workflow improvments
Trigger github action on new issue, build docker with  and scan it (with ArgoCD

## Demo walkthrough

* Documentation
* Walk around the GitHub Actions and Docker code
* Show secrets and GitHub repo based security settings
* Create new branch and commit something, make a PR
* Show the GitHub Actions workflows
* Show SonarCloud results
* Show the NewRelic and DigitalOcean metrics
* Show Docker Hub
* Show slack notification
* Walk around the terraform code
* terraform plan

* `curl` the instance

* Commit/Merge changes on the Ruby code
	* Demo the workflow again
	* From the instance - get new version of the docker image and run it
	* Demo the changes deployed

```
docker ps
docker stop INSTANCE-ID
docker pull nedko/tcp_server:latest
docker run --rm -d -p 80:80 nedko/tcp_server:latest
curl localhost
```


## Changelog

Changes that are worth mentioning no matter that the exam is passed

* In the previous implementation SNYK tested the uploaded image BEFORE I upload it so it was scanning the previous successful build. Now we're building the docker image while running the SNYK. As a side effect there's even a small performance gain (42 sec for the previous method vs 33 secounds now). Who said we can't be in a win-win situation here? 

