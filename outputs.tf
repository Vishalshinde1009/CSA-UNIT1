output "vpc_id" {
  description = "ID of the PBL VPC"
  value       = aws_vpc.pbl_vpc.id
}

output "web_subnet_id" {
  description = "ID of the public web subnet"
  value       = aws_subnet.web_subnet.id
}

output "app_subnet_id" {
  description = "ID of the private application subnet"
  value       = aws_subnet.app_subnet.id
}

output "db_subnet_id" {
  description = "ID of the private database subnet"
  value       = aws_subnet.db_subnet.id
}

output "s3_bucket_name" {
  description = "Name of the PBL S3 bucket"
  value       = aws_s3_bucket.pbl_bucket.id
}

output "ec2_instance_id" {
  description = "ID of the observation EC2 instance"
  value       = aws_instance.pbl_web_server.id
}

output "ec2_public_ip" {
  description = "Public IP address of the observation EC2 instance"
  value       = aws_instance.pbl_web_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS name of the observation EC2 instance"
  value       = aws_instance.pbl_web_server.public_dns
}

output "observation_security_group_id" {
  description = "Security group used for SSH and HTTP observation"
  value       = aws_security_group.observation_sg.id
}