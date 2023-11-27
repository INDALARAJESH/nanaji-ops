## Lessons Learned

- Configuring the `/{proxy+}` resource on API GW is convenient to simply pass the traffic to the application, but the application is then entirely exposed and must handle the filtering itself, even for wrong requests 
- It's much less error-prone to construct the resource tree (endpoints and methods) using OpenAPI which is much easier to read and see the diffs when it's stored in a version control system -- especially when using the application frameworks that allow generating this spec automatically
  - when compared to terraform way -- especially when building a resource tree that would filter the incoming traffic (endpoints and methods) 

## References

[Configuring a REST API using OpenAPI](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-import-api.html)
