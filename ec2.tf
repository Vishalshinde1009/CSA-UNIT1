# ============================================================
# AMAZON LINUX 2023 AMI
# ============================================================

data "aws_ssm_parameter" "amazon_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}


# ============================================================
# PBL WEB / SSH OBSERVATION EC2
# ============================================================

resource "aws_instance" "pbl_web_server" {
  ami           = data.aws_ssm_parameter.amazon_linux_ami.value
  instance_type = "t3.micro"

  subnet_id = aws_subnet.web_subnet.id

  vpc_security_group_ids = [
    aws_security_group.observation_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash

              dnf update -y

              dnf install -y nginx

              systemctl enable nginx
              systemctl start nginx

              cat > /usr/share/nginx/html/index.html <<'HTML'
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Cloud Security PBL</title>
              </head>
              <body>
                  <h1>Cloud Security PBL Web Server</h1>
                  <p>Web server is running successfully.</p>
              </body>
              </html>
              HTML

              systemctl restart nginx

              echo "PBL observation server initialized at $(date)" \
                >> /var/log/pbl-observation.log
              EOF

  root_block_device {
    encrypted   = true
    volume_size = 8
    volume_type = "gp3"
  }

  monitoring = true

  tags = {
    Name        = "PBL-Web-Observation-EC2"
    Project     = "Cloud-Security-PBL"
    Environment = "Lab"
    Purpose     = "Web and SSH Threat Observation"
  }
}