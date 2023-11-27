# POS Toast Integration Service

### General

* Description: A module to POS toast integration service
* Created By: Torri Haines, Mike Lane, and Kareem Shahin
* Module Dependencies:
* Provider Dependencies: `aws`
* Terraform Version: 0.14.x

### Description

The goal is to implement a POS Toast microservice, which integrates Toast with the ChowNow system. The service will be a "proxy" between ChowNow and the Toast API and handle all restaurant traffic for restaurants that use Toast.

### Contributing
Looking to create a lambda for the private REST API? See the [api_lambda submodule](api_lambda/README.md).
Looking to create a lambda for handling messages with SQS? See the [sqs_lambda submodule](sqs_lambda/README.md).
Looking to create a scheduled lambda? See the [scheduled_lambda submodule](scheduled_lambda/README.md).

Once you've made changes to this repository, ensure you update the tag in the example this README and create a PR.  Once the PR is approved and merged, tag this module and push the tag by doing the following:

```sh
# pull the latest on master
$ git checkout master
$ git pull

# tag the module and push the tags - make sure you verify the latest tag in github or this README
$ git tag -f -a pos-integration-toast-v1.2.10 -m '<message with details>'
$ git push --follow-tags
```
Note: make sure you specify the proper tag version.

### Updating Documenation
To keep documentation up to date and to automatically generate variable and output information, we use [terraform-docs](https://terraform-docs.io/user-guide/introduction/). Also see the [guide](https://chownow.atlassian.net/wiki/spaces/CE/pages/2726166529/Terraform+-+Documenting+Service+Modules) on documenting service modules in confluence.

To re-generate the README after updating entries in the respective docs/ folder, simply run the following command from the root directory of the module:
```
terraform-docs -c ~/github/chownow/ops-tf-modules/.tfdocs.d/.terraform-docs.yml --output-file README.md .
```
