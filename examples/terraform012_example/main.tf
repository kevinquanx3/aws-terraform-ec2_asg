###############################################################################
# Providers
###############################################################################
provider "aws" {
  version             = "~> 2.0"
  region              = var.region
  allowed_account_ids = [var.aws_account_id]
}

provider "random" {
  version = "~> 2.0"
}

provider "template" {
  version = "~> 2.0"
}

terraform {
  required_version = ">= 0.12"
}


###############################################################################
# Other Resources
###############################################################################

data "aws_region" "current_region" {
}

module "vpc" {
  source   = "git@github.com:rackspace-infrastructure-automation/aws-terraform-vpc_basenetwork?ref=tf_0.12-upgrade"
  vpc_name = "${var.environment}-${var.app_name}"
}

resource "aws_elb" "my_elb" {
  subnets = module.vpc.public_subnets
  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_sns_topic" "my_test_sns" {
  name = "user-notification-topic"
}

data "aws_ami" "asg_ami" {
  most_recent = true
  owners      = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn-ami-hvm-2018.03.0.*gp2"]
  }
}

resource "aws_iam_policy" "test_policy_1" {
  name = "test_policy_1"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "test_policy_2" {
  name = "test_policy_2"
  path = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}