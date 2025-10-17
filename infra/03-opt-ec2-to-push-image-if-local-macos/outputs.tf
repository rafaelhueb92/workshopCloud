output "instance_id" {
  value = aws_instance.ecr_builder.id
}

output "ssm_connect_command" {
  value = "aws ssm start-session --target ${aws_instance.ecr_builder.id}"
}