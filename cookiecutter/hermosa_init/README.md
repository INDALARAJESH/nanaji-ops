# Usage

## Generate workspaces

* Collect ids of internal-<env>, vpn-<env> and vpn_web-<env> security groups
* Collect id of static assets Cloudfront distribution that serves cf.<env>.chownowcdn.com
* Run the following command and provide missing inputs, accept other defaults
  ```
  cd ops-tf-modules/cookiecutter
  cookiecutter -o ~/<env> hermosa_init 
  ```

## Copy workspaces to target folders

Under the generated <env> folder you'll find the following structure
```
> workspaces_<env>
  > aws
    > us-east-1
      > services
        > hermosa
          > app-green
          > base
          > cluster
          > routing
  > cloudflare
    > us-east-1
      > services
        > hermosa
          > app-green
          > base
```

* Copy the leaf folders into their respective folder in the ops/terraform/environments/<env> hierarchy
