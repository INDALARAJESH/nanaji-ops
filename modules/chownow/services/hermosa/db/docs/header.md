# Hermosa DB Module

### General

* Description: Hermosa DB terraform module. This module creates the aurora cluster for hermosa
* Created By: Joe Perez
* Module Dependencies:
* Module Components:
  * `random password`
  * `aws secret`
  * `aurora cluster`
  * `aurora database instance`
  * `aurora endpoint cnames`
* Providers : `aws`, `random`
* Terraform Version: 0.14.x

![chownow-services-hermosa-db](https://github.com/ChowNow/ops-tf-modules/workflows/chownow-services-hermosa-db/badge.svg)

![hermosa_aurora_cluster](docs/diagrams/hermosa_aurora_cluster.png)
_Note: Not pictured is the aurora reader endpoint cname which follows the pattern `db-replica.env.aws.chownow.com`_

### Versions

* *cn-hermosa-db-v2.1.0*
  * this version is to be used just before upgrading a cluster from 5.6 to 5.7
* *cn-hermosa-db-v2.1.1*
  * this version is to be used right after upgrading a cluster from 5.6 to 5.7
  * remove the current cluster from the TF state (terraform state rm)
  * import the upgraded 5.7 cluster into terraform (terraform import)
  * replan and apply

### Initialization

### Terraform

* Example directory structure:
```
.
├── global
└── us-east-1
    ├── core
    └── db
        └── hermosa
            └── mysql
              ├── hermosa_db.tf
              ├── provider.tf
              └── variables.tf
```
