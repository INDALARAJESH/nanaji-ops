# Terraform Modules

## Development process

### Repositories

* ops-tf-modules: all modules code lives here
* ops: contains the deployments in various environments

### Service

* Identify a reusable service to build
* Implement it in a branch named after a Jira ticket
* Use the branch reference in ops repository to test and deploy
* Submit a Pull Request for ops-tf-module
* Once approved, merge code into master branch of ops-tf-module
* Pull changes from master branch and tag your module according to convention in /README.md
* In ops reppository, change references to use the tag(s) of the module(s) you updated
* Submit a Pull Request for ops

## Folder structure

| Folder                     | Description                     |
| :------------------------- | :------------------------------ |
| aws                        | modules around aws resources to embed best practices and common customizations    |
| chownow                    | chownow composed services that combine aws modules and resources |
