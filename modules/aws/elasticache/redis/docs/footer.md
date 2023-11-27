### Initialization

#### Unencrypted Connection

* ssh/ssm into ec2 instance in the same VPC
  * Take a look at the jumpbox module
* Verify network connectivity to redis: `nc -zv service-redis.uat.aws.chownow.com 6379` (change `service` to actual service name)
* Connect to redis via `redis-cli`: `redis-cli -h service-redis.uat.aws.chownow.com` (change `service` to actual service name)
* Once connected, run `info` to get information about the instance

#### Encrypted Connection

* ssh/ssm into ec2 instance in the same VPC
  * Take a look at the jumpbox module
* Verify network connectivity to redis: `nc -zv service-redis.uat.aws.chownow.com 6379` (change `service` to actual service name)
* Install redli
* with redli:
  * uri way:  `redli --tls -u rediss://admin:PASSWORDGOESHERE@master.service-redis-uat.gt24gi.use1.cache.amazonaws.com -p 6379`
  * host way: `redli --tls -h master.service-redis-uat.gt24gi.use1.cache.amazonaws.com -p 6379 -a PASSWORDGOESHERE`
* Once connected, run `info` to get information about the instance

### Lessons Learned

* If you switch from a parameter created inside the module to one outside, you might run into resource deletion issues. You should change the cluster's parameter group in the console to allow the old parameter group to be deleted.

### References
