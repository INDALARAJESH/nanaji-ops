from diagrams import Cluster, Diagram, Edge
from diagrams.aws.compute import ECS, EKS, Lambda, EC2
from diagrams.aws.network import Route53, VPC, ElasticLoadBalancing, ELB, ClientVpn, CF
from diagrams.aws.integration import SQS
from diagrams.aws.storage import S3
from diagrams.onprem.ci import Jenkins
from diagrams.onprem.container import Docker
from diagrams.onprem.client import Users
from diagrams.onprem.inmemory import Redis
from diagrams.aws.database import RDS
from diagrams.aws.management import Cloudwatch



with Diagram("Sherlock Infrastructure Diagram", show=False):
    salesforce = S3('SalesForce')
    admin = CF('ChowNow Dashboard')
    website = CF('Company Website')

    with Cluster("Virtual Private Cloud (VPC)"):
        cloudwatch = Cloudwatch("CloudWatch Events")

        with Cluster("Database"):
            redis = Redis("ElastiCache Redis")
            dynamodb = RDS("DynamoDB")

        with Cluster("Elastic Container Service"):
            sherlock_api = ECS("Sherlock API")
            sherlock_scanner = ECS("Sherlock Scanner")


    cloudwatch >> Edge(color="red") >>  sherlock_scanner >>  Edge(color="red") >> sherlock_api
    sherlock_scanner >>  Edge(color="red") >> website
    sherlock_api >>  Edge(color="blue") >> admin
    dynamodb >>  Edge(color="blue") >> sherlock_api
    dynamodb >> Edge(color="red") >> sherlock_scanner
    redis >> Edge(color="red") >> sherlock_scanner
    salesforce >> Edge(color="red") >> sherlock_scanner

