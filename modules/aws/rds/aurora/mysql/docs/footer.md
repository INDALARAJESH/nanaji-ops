### Lessons Learned

* If you restore from a snapshot, there's a chance that terraform will timeout on you and give the error below. AWS will continue to restore the database and it will come up fine.
```
Error: Error waiting for RDS Cluster state to be "available": timeout while waiting for state to become 'available' (last state: 'migrating', timeout: 2h0m0s)
```

* There isn't a way to attach an option group to an aurora database instance [source](https://github.com/hashicorp/terraform-provider-aws/issues/8847)
* The cluster and instance parameter groups were intentionally created outside of the module for better visibility and more flexibility
* Looping change for CIDR block retrieval was a pain because they changed the work-around to grab them


### References

* [Restoring snapshots in RDS](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fmedia.giphy.com%2Fmedia%2FQTvYcj77RjkQ%2Fgiphy.gif&f=1&nofb=1)
