from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, ECR
from diagrams.aws.database import ElastiCache, RDS
from diagrams.aws.network import ELB
from diagrams.aws.network import Route53

from diagrams.aws.devtools import Codebuild
from diagrams.onprem.vcs import Github
from diagrams.onprem.ci import Jenkins

with Diagram("DMS", show=False):
    dns = Route53("dms.env.svpn.chownow.com")
    lb = ELB("dms-alb-env")
    cname_rds    = Route53("dms-master.env.aws.chownow.com")
    cname_redis = Route53("dms-redis.env.aws.chownow.com")

    with Cluster("dms-env"):
        web_group = [ECS("dms-web1-env"),
                     ECS("dms-web2-env")]
        task_group = [ECS("dms-task1-env"),
                     ECS("dms-task2-env")]

    with Cluster("DMS data"):
        db_master = RDS("dms-postgres-env")
        redis = ElastiCache("dms-redis-env")


    dns >> lb >> web_group
    web_group >> cname_rds >> db_master
    web_group >> cname_redis >> redis
    task_group >> cname_redis >> redis
