from diagrams import Cluster, Diagram
from diagrams.aws.network import Route53,ELB
from diagrams.oci.connectivity import DNS
from diagrams.aws.compute import EC2


graph_attr = {
    "overlap": "false",
}

with Diagram("web_alb", show=False, direction="TB", graph_attr=graph_attr):


    with Cluster ("Cloudflare"):
        api_cloudflare = DNS("api.chownow.cdn.cloudflare.net")

    with Cluster("AWS"):
        with Cluster("Public"):
            web_alb        = ELB("web-hermosa-pub-prod")
            api            = Route53("api.chownow")
            web_origin     = Route53("web-origin.chownow")
        with Cluster("Private"):
            web_ec2        = [
                EC2("web_green0"),
                EC2("web_green1"),
                EC2("web_green2"),
                EC2("web_green3")
            ]

    api >> api_cloudflare >> web_origin >> web_alb >> web_ec2
