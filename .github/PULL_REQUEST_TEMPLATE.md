##### Jira Issue: [OPS-xxxx](https://chownow.atlassian.net/browse/OPS-xxxx)

## Description

_Please summarize the changes made to the terraform module(s):_

## Type of change

_Check all that apply_

- [ ] Vendor Specific module change (`aws`, `modules/aws`, and `modules/datadog` folders)
- [ ] Composed Service module change (`chownow` and `modules/chownow` folders)
- [ ] Data only module (`modules/data/`)
- [ ] Legacy module change (all other folders)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation change
- [ ] Terraform Version Upgrade
- [ ] Github Action
- [ ] Other
  - [ ] Details:

## How Has This Been Tested?

_Please make sure these changes have been tested in all environments._

- [ ] Lower Environments module version bump
- [ ] Prod Environment module version bump
- [ ] Other services which rely on a common module
- [ ] Other
  - [ ] Details:

**Test Configuration**:
* Terraform Version:
* Jenkins Workspace output links for lower environment change and prod:
  * Lower:
  * Prod:


## Checklist:

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have bumped the module version in the README
- [ ] I have updated the "inputs/outputs" section in the README
- [ ] I have updated the "Lessons Learned" heading in the README with any additional insight
- [ ] My changes generate no new warnings
- [ ] I have an identical branch in the `ops` repo and have deployed the composed service module changes to every environment
- [ ] I have verified that a github action exists for the new/existing module
- [ ] I have checked my code and corrected any misspellings


# Remaining tasks after approval:

* Create new tag for services changed
* Bump the tag version for all of the environments which have this module deployed in `ops` repo
* Test every environment to make sure tag is working as intended
* Submit a PR for changes in `ops` repo
