## Lessons Learned

* The cluster and instance parameter groups were intentionally created outside of the module for better visibility and more flexibility
* NOTE: DB ENGINE VERSION AND PARAMETER GROUPS FAMILY MUST HAVE THE MATCHING MAJOR VERSION:
  * db_engine_version == 12.10 && family == aurora-postgresql12
  * db_engine_version == 13.6 && family == aurora-postgresql13
* If you restore from a snapshot, there's a chance that terraform will timeout on you and give the error below. AWS will continue to restore the database and it will come up fine.
```
Error: Error waiting for RDS Cluster state to be "available": timeout while waiting for state to become 'available' (last state: 'migrating', timeout: 2h0m0s)
```

RDS Aurora versions availability can slightly differ from the RDS Community.
For instance, at the moment of writing this module the newest available versions for each were the following:

- RDS Community PostgreSQL = 14.2
- RDS Aurora PostgreSQL = 13.6

One can easily verify the availability by invoking the `aws rds describe-db-engine-versions` API call:

`$ aws rds describe-db-engine-versions --engine aurora-postgresql | jq '.DBEngineVersions | .[] | .EngineVersion'`

```
"10.14"
"10.14"
"10.16"
"10.17"
"10.18"
"10.19"
"10.20"
"11.9"
"11.11"
"11.12"
"11.13"
"11.14"
"11.15"
"12.4"
"12.6"
"12.7"
"12.8"
"12.9"
"12.10"
"13.3"
"13.4"
"13.5"
"13.6"
```

## References
