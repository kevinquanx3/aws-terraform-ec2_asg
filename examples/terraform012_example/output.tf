###############################################################################
# Outputs
# terraform output summary
###############################################################################

output "summary" {
  value = <<EOF

## Outputs
| asg_image_id      | ${module.ec2_asg.asg_image_id} |
| asg_name_list     | ${join(",", module.ec2_asg.asg_name_list)} |
| iam_role          | ${module.ec2_asg.iam_role} |
EOF

  description = "ec2_asg output summary"
}
