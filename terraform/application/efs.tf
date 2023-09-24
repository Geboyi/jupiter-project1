data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  region = "eu-west-1"
  name   = "efs-ex-${replace(basename(path.cwd), "_", "-")}"

  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Name       = local.name
    Example    = local.name
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-efs"
  }
}

################################################################################
# EFS Module
################################################################################

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.3.0"

  # File system
  name           = local.name
  creation_token = local.name
  encrypted      = true
  ##kms_key_arn    = module.kms.key_arn

  performance_mode                = "maxIO"
  throughput_mode                 = "provisioned"
  provisioned_throughput_in_mibps = 256

  lifecycle_policy = {
    transition_to_ia                    = "AFTER_30_DAYS"
    transition_to_primary_storage_class = "AFTER_1_ACCESS"
  }

  # File system policy
  attach_policy                      = true
  bypass_policy_lockout_safety_check = false
  policy_statements = [
    {
      sid     = "Example"
      actions = ["elasticfilesystem:ClientMount", "elasticfilesystem:ClientWrite"]
      principals = [
        {
          type        = "AWS"
          identifiers = [data.aws_caller_identity.current.arn]
        },
        ##{
        ##  type        = "AWS"
        ##  identifiers = ["arn:aws:iam::777595570545:role/demo-asg-iam-role"]
        ##}
      ]
    }
  ]

  # Mount targets / security group
  mount_targets              = { for k, v in zipmap(local.azs, "${data.terraform_remote_state.remote.outputs.private_subnets}") : k => { subnet_id = v } }
  security_group_description = "Example EFS security group"
  security_group_vpc_id      = data.terraform_remote_state.remote.outputs.vpc_id
  security_group_rules = {
    vpc = {
      # relying on the defaults provided for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = "${data.terraform_remote_state.remote.outputs.private_subnets_cidr_blocks}"
      ##source_security_group_id =
    }
  }


  # Access point(s)
  access_points = {
    posix_example = {
      name = "posix-example"
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002]
      }

      tags = {
        Additionl = "yes"
      }
    }
    root_example = {
      root_directory = {
        path = "/example"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
  }

  tags = local.tags
}

resource "aws_ssm_parameter" "efs_id" {
  name  = "/A4L/Wordpress/EFSFSID"
  type  = "String"
  value = module.efs.id
}
