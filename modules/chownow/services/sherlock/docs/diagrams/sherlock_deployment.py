from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, ECR
from diagrams.aws.devtools import Codebuild
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import Jenkins
from diagrams.onprem.client import Users


with Diagram("Sherlock Deployment", direction="LR"):
    user = Users("Users")
    github = Github("Sherlock-API Repo")

    with Cluster("Virtual Private Cloud (VPC)"):
        jenkins = Jenkins("Deploy DMS")

        with Cluster("Amazon Web Services"):
            codebuild = Codebuild("Codebuild")

            with Cluster("Elastic Container Service"):
                ecr = ECR("Sherlock Repo")
                sherlock_api = ECS("Sherlock API")
                sherlock_scanner = ECS("Sherlock Scanner")

    user >> jenkins  >> codebuild >> ecr
    ecr >> sherlock_api
    ecr >> sherlock_scanner
    github >> codebuild
    github >> jenkins

