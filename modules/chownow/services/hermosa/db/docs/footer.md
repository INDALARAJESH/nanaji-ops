### Lessons Learned

* This is more for the aurora module, but if you pass a password to the module, a `count` parameter on the aurora module's random password resource won't work. This is because the random password outside of the module won't be created until after the apply and the random password resource INSIDE the aurora module will need that information to decide whether or not it should be created. Yeah, you're probably confused, but that's ok.

* There might be a scenario where the master password is updated by hand on the aurora cluster, but it won't be updated in secrets manager. If you update that password, terraform will try to replace that "new" password with the randomly generated password it created during the first run. This won't matter to aurora though because the aurora module is ignoring changes to the master password parameter.

* When provisioning multiple database instances, there's no telling which instance will come online first. That first database instance will become the writer. So you may end up in a scenario where "database instance 4" is the writer and you want to scale down the cluster. You will need to failover to "database instance 0" first, then change the value in terraform and run terraform apply to scale down. If you just scale down without failing over, aurora will failover on it's own, but I imagine it won't be as graceful as manually failing over first.


### References
