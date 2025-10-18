module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                    = local.name
  cluster_endpoint_public_access = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  cluster_addons = {
    coredns = {
      addon_version            = "v1.10.1-eksbuild.2"
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    }

    kube-proxy = {
      addon_version            = "v1.27.1-eksbuild.2"
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    }

    vpc-cni = {
      addon_version            = "v1.14.1-eksbuild.2"
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = null
    }
  }

  eks_managed_node_group_defaults = {
    ami_type                               = "AL2_x86_64"
    instance_types                         = ["m5.large"]
    attach_cluster_primary_security_group  = true
  }

  eks_managed_node_groups = {
    cluster-wg = {
      desired_size = 1
      min_size     = 1
      max_size     = 2

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  tags = local.tags
}
