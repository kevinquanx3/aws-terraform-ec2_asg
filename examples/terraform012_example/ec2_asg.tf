
module "ec2_asg" {
  source = "git@github.com:rackspace-infrastructure-automation/aws-terraform-ec2_asg?ref=tf_0.12-upgrade"

  resource_name       = "ec2_asg"
  ec2_os              = "amazon"
  asg_count           = "4"
  security_group_list = [module.vpc.default_sg]
  subnets             = module.vpc.private_subnets
  key_pair            = "key_pair_oregon"

  #   # If ALB target groups are being used, one can specify ARNs like the commented line below.
  #   #target_group_arns                      = ["${aws_lb_target_group.my_tg.arn}"]
  load_balancer_names         = [aws_elb.my_elb.name]
  enable_rolling_updates      = true
  detailed_monitoring         = true
  environment                 = var.environment
  image_id                    = "${data.aws_ami.asg_ami.image_id}"
  backup_tag_value            = "True"
  instance_type               = "t2.micro"
  scaling_min                 = "1"
  scaling_max                 = "2"
  enable_scaling_notification = true
  scaling_notification_topic  = aws_sns_topic.my_test_sns.arn
  notification_topic          = [aws_sns_topic.my_test_sns.arn]
  tenancy                     = "default"
  terminated_instances        = "30"


  instance_role_managed_policy_arns      = [aws_iam_policy.test_policy_1.arn, aws_iam_policy.test_policy_2.arn]
  instance_role_managed_policy_arn_count = "2"

  ssm_association_refresh_rate = "rate(1 day)"
  enable_ebs_optimization      = false
  cloudwatch_log_retention     = "7"
  rackspace_managed            = true
  ec2_scale_up_adjustment      = "1"
  ec2_scale_up_cool_down       = "60"
  ec2_scale_down_adjustment    = "-1"
  ec2_scale_down_cool_down     = "60"

  health_check_grace_period    = "300"
  health_check_type            = "EC2"
  cw_high_evaluations          = "3"
  primary_ebs_volume_iops      = "0"
  primary_ebs_volume_type      = "gp2"
  primary_ebs_volume_size      = "60"
  secondary_ebs_volume_iops    = "0"
  secondary_ebs_volume_size    = "60"
  secondary_ebs_volume_type    = "gp2"
  encrypt_secondary_ebs_volume = false

  cw_high_operator   = "GreaterThanThreshold"
  cw_high_period     = "60"
  cw_high_threshold  = "60"
  cw_low_operator    = "LessThanThreshold"
  cw_low_evaluations = "3"
  cw_low_period      = "300"
  cw_low_threshold   = "30"
  cw_scaling_metric  = "CPUUtilization"

  install_codedeploy_agent  = true
  initial_userdata_commands = "#initial_userdata_commands"

  perform_ssm_inventory_tag     = "True"
  asg_wait_for_capacity_timeout = "5m"
  ssm_patching_group            = "MyPatchGroup1"

  additional_ssm_bootstrap_step_count = "2"
  additional_ssm_bootstrap_list = [
    {
      ssm_add_step = <<EOF
        {
            "action": "aws:runDocument",
            "inputs": {
            "documentPath": "arn:aws:ssm:${data.aws_region.current_region.name}:507897595701:document/Rack-Install_Package",
            "documentParameters": {
                "Packages": "bind bindutils"
            },
            "documentType": "SSMDocument"
            },
            "name": "InstallBindAndTools",
            "timeoutSeconds": 300
        }
    EOF
    },
    {
      ssm_add_step = <<EOF
        {
            "action": "aws:runDocument",
            "inputs": {
            "documentPath": "AWS-RunShellScript",
            "documentParameters": {
                "commands": ["touch /tmp/myfile"]
            },
            "documentType": "SSMDocument"
            },
            "name": "CreateFile",
            "timeoutSeconds": 300
        }
    EOF
},
]

additional_tags = [
  {
    key                 = "MyTag1"
    value               = "Myvalue1"
    propagate_at_launch = true
  },
  {
    key                 = "MyTag2"
    value               = "Myvalue2"
    propagate_at_launch = true
  },
  {
    key                 = "MyTag3"
    value               = "Myvalue3"
    propagate_at_launch = true
  },
]
}
