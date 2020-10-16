terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.10.0"
    }
  }
}

provider "aws" {
  region      = var.aws_region
  profile     = var.aws_profile
}

locals {
  lb_name     = "example"

  s3_buckets  = ["jolt23-repository", "jolt23-digital"]
}

module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
   count  = length(local.s3_buckets)

  bucket = local.s3_buckets[count.index]
  acl    = "private"
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.9"

  name               = local.lb_name

  load_balancer_type = "application"

  internal           = true

  vpc_id             = var.aws_vpc_id
  subnets            = var.aws_subnet_ids
  security_groups    = var.aws_sg_ids

  target_groups      = [
    {
      name             = "${local.lb_name}-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      health_check     = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      tags                = {
        Environment = "sandbox"
        ManagedBy   = "Terraform"
      }
    }
  ]

  http_tcp_listeners  = [
    {
      port                = 80
      protocol            = "HTTP"
      target_group_index  = 0
    }
  ]

  tags                = {
    Environment = "sandbox"
    ManagedBy   = "Terraform"
  }
}