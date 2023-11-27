from diagrams import Cluster, Diagram
from diagrams.aws.network import Route53,ELB
from diagrams.oci.connectivity import DNS
from diagrams.aws.compute import EC2


with Diagram("admin_alb", show=False, direction="TB"):


    with Cluster ("Cloudflare"):
        admin_cloudflare = DNS("admin.chownow.com.cdn.cloudflare.net")

    with Cluster("AWS"):
        with Cluster("Public"):
            admin_alb        = ELB("admin-hermosa-pub-prod")
            admin            = Route53("admin.chownow.com")
            admin_origin     = Route53("admin-origin.chownow.com")
        with Cluster("Private"):
            admin_ec2        = [
                EC2("admin_green0"),
                EC2("admin_green1"),
                EC2("admin_green2"),
                EC2("admin_green3")
            ]

    admin >> admin_cloudflare >> admin_origin >> admin_alb >> admin_ec2
