from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, ECR
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.network import ELB, Route53
from diagrams.aws.security import SecretsManager

graph_attr = {
    "ranksep": "1.5",
    "nodesep": "1.0"
}

with Diagram("Integrations Diagram", graph_attr=graph_attr):
    dns_1 = Route53("integ1.env.svpn.chownow.com")
    rds_dns_1 = Route53("integ1-master.env.aws.chownow.com")
    redis_dns_1 = Route53("integ1-redis.env.aws.chownow.com")
    lb_1 = ELB("integ1-alb-env")

    with Cluster("ECS Web 1"):
        web_group_1 = [
                        ECS("integ1-web1-env"),
                        ECS("integ1-web2-env")
                    ]

    with Cluster("Databases 1"):
        pg_1 = RDS("integ1-pg-env")
        redis_1 = ElastiCache("integ1-ec-env")

    dns_2 = Route53("integ2.env.svpn.chownow.com")
    rds_dns_2 = Route53("integ2-master.env.aws.chownow.com")
    redis_dns_2 = Route53("integ2-redis.env.aws.chownow.com")
    lb_2 = ELB("integ2-alb-env")

    with Cluster("ECS Web 2"):
        web_group_2 = [
                        ECS("integ2-web1-env"),
                        ECS("integ2-web2-env")
                    ]

    with Cluster("Databases 2"):
        pg_2 = RDS("integ2-pg-env")
        redis_2 = ElastiCache("integ2-ec-env")


    dns_1 >> lb_1 >> web_group_1
    web_group_1 >> rds_dns_1 >> pg_1
    web_group_1 >> redis_dns_1 >> redis_1

    dns_2 >> lb_2 >> web_group_2
    web_group_2 >> rds_dns_2 >> pg_2
    web_group_2 >> redis_dns_2 >> redis_2
