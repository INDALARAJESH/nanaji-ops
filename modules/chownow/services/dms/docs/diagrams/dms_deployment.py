from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, ECR
from diagrams.aws.devtools import Codebuild
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import Jenkins



with Diagram("DMS Deployment", direction="LR"):

    with Cluster("AWS CodeBuild"):
        codebuild = Codebuild("dms-codebuild-env")
        github = Github("delivery-management-service")
        ecr = ECR("dms-env")
        ecs = ECS("dms-env")
        codebuild >> github >> ecr >> ecs
    with Cluster("Jenkins"):
        jenkins = Jenkins("Deploy DMS")
        jenkins >> codebuild
