### Lessons Learned

* This model of building out ALB resources (listener/listener rules) seems like a good way to keep the environments with cloudflare in sync.
* There are still some manual steps in Cloudflare that need to be completed for new subdomains to be added:
  * The subdomain to web-origin cname
  * Firewall allow rule based on subdomain regex
  * Page rule to force HTTPS


### References
