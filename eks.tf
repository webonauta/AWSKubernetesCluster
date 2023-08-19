module "eks"{
    source = "terraform-aws-modules/eks/aws"
    version = "~>19.0"

    cluster_name = "demo-eks"
    cluster_version = "1.24"

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
    cluster_endpoint_public_access = true 
    cluster_endpoint_private_access = true

    cluster_addons = {
        coredns = {
            resolve_conflic = "OVERWRITE"
        }

        vpc-cni = {
            resolve_conflic = "OVERWRITE"
        }

        kube-proxy = {
            resolve_conflic = "OVERWRITE"
        }

        csi = {
            resolve_conflic = "OVERWRITE"
        }
    }

    manage_aws_auth_configmap = true

        aws_auth_users = [
            {
                userarn = data.aws_iam_user.me.arn,
                username = "developer",
                groups = [
                    "system:masters",
            ],
            }
        ]

    eks_managed_node_groups = {
        node_groups = {
            derired_capacity = 1
            max_capacity = 2
            min_capacity = 1
            instance_types = ["t3.medium"]
            disk_size = 20
            subnets = module.vpc.private_subnets
            tags = {
                Enviroment = "demo"
            }
        }

        tags = {
            Terraform = "true"
            Enviroment = "demo"
        }

        data = "aws_eks_cluster" "cluster" {
            name = module.eks.cluster_name
        }

        data = "aws_eks_cluster_auth" "cluster" { 
            name = module.eks.cluster_name
        }

        provider "kubernetes" {
            host = data.aws.eks.cluster.endpoint
            cluster_ca_certificate = base64code(data.aws_eks_cluster_certificate_author)
            token = data.aws_eks_cluster_auth.cluster.token
        }
    }
}
