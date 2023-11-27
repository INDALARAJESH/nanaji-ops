# ECS Ephemeral Volume Example

* Description: This code will use an init container to inject the nginx config onto an ephemeral volume, then mount it to an nginx container.
**DO NOT USE THIS IF THERE ARE SECRETS IN THE CONFIG**
* If you need a way to inject a config with secrets, please look at the `dd-agent` service.


### Resources

* [ECS Fargate Tasks With Ephemeral Volumes](https://chownow.atlassian.net/wiki/spaces/CE/pages/2830795056/ECS+Fargate+tasks+with+ephemeral+volumes)
