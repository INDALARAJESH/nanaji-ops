# Marketplace App

## General

* Description: Marketplace NextJS Terraform module
* Created By: Allen Dantes & Jobin Muthalaly
* Module Dependencies: 
* Module Components:
* Providers : `aws`
* Terraform Version: ~> 0.14.6

![chownow-services-marketplace-app](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-marketplace-app/badge.svg)

## Workspace

* Example directory and terraform workspace structure:

`ops/terraform/environments/ENV`
```
├── env_global.tf
├── global
└── us-east-1
    ├── api-gateway
    ├── base
    ├── core
    ├── db
    └── services
        └── marketplace
            ├── app
            ├──── alb.tf
            ├──── ecs.tf
```
