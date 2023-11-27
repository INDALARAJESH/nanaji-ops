# Toast POS Service API Lambda Module

### General

* Description: A module for creating lambdas that are fronted by the private API gateway that exposes this service.
* Created By: Kareem Shahin
* Providers : `aws`
* Terraform Version: 0.14.x

Note: Ensure that when adding a lambda, you are updating the [OpenAPI](../../templates/private_api.json) spec for the API Gateway in order to include the new route to the lambda resource.
