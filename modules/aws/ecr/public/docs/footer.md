### Lessons Learned

* Lifecycle policies map one to one with ECR repos
* You can add multiple rules to a single lifecyle policy
* When adjusting the lifecycle rule order, you must also adjust the position of the rules. Otherwise terraform will continue to trigger changes.

### References

* [Terraform ECR Lifecycle Policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy)