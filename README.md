# ops-tf-modules

A repository for terraform modules.

These should be called from the relevant environments defined in [ops.git/terraform/](https://github.com/ChowNow/ops/tree/master/terraform).



### Module Tagging

Tag module releases for consumption, ie after merge to master:
```
$ git tag -a ec2-base-v1.0.0 -m "first release for new extended ec2 module"
$ git push --follow-tags
Enumerating objects: 1, done.
Counting objects: 100% (1/1), done.
Writing objects: 100% (1/1), 189 bytes | 189.00 KiB/s, done.
Total 1 (delta 0), reused 0 (delta 0)
To github.com:ChowNow/ops-tf-modules.git
 * [new tag]         ec2-base-v1.0.0 -> ec2-base-v1.0.0
```


#### Terraform Version to Git Tag Map

* We talked about the tagging overlap that would occur between terraform version upgrades and decided to map the terraform version to a specific `major` SemVer number. This means that every terraform modules is bound by this rule and "major"/breaking changes would be addressed in `minor` versions.

| Terraform Version | Git Tag | Notes |
| :---------------- | :------ | :---- |
| 0.11.x            | 1.x.x   |       |
| 0.14.x            | 2.x.x   |       |
| 0.15.x            | 3.x.x   |       |
| 1.x.x             | 4.x.x   |       |

## Refs

* [Terraform Modules](https://chownow.atlassian.net/wiki/spaces/CE/pages/789709050/Terraform+Modules)
* [Terraform Best Practices](https://chownow.atlassian.net/wiki/spaces/CE/pages/796360739/Terraform+Best+Practices)
* [Terraform File Layout](https://chownow.atlassian.net/wiki/spaces/CE/pages/865567399/Terraform+Restructure)
