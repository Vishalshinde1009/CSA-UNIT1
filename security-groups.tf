# ============================================================
# Web Tier Security Group
# ============================================================

resource "aws_security_group" "web_sg" {
  name        = "PBL-Web-SG"
  description = "Security group for the web tier"
  vpc_id      = aws_vpc.pbl_vpc.id

  # HTTP - public web access
  ingress {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS - public web access
  ingress {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "PBL-Web-SG"
    Project = "Cloud-Security-PBL"
    Tier    = "Web"
  }
}


# ============================================================
# App Tier Security Group
# ============================================================

resource "aws_security_group" "app_sg" {
  name        = "PBL-App-SG"
  description = "Security group for the application tier"
  vpc_id      = aws_vpc.pbl_vpc.id

  # Application traffic only from Web Tier
  ingress {
    description     = "Application traffic from Web Tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "PBL-App-SG"
    Project = "Cloud-Security-PBL"
    Tier    = "App"
  }
}


# ============================================================
# Database Tier Security Group
# ============================================================

resource "aws_security_group" "db_sg" {
  name        = "PBL-DB-SG"
  description = "Security group for the database tier"
  vpc_id      = aws_vpc.pbl_vpc.id

  # PostgreSQL - only from App Tier
  ingress {
    description     = "PostgreSQL from App Tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "PBL-DB-SG"
    Project = "Cloud-Security-PBL"
    Tier    = "Database"
  }
}


# ============================================================
# SSH Observation Security Group
# ============================================================
# This group is intentionally Internet-facing for the
# 24-48 hour passive observation experiment.
#
# DO NOT use this security group for a production database
# or sensitive application server.
# ============================================================

resource "aws_security_group" "observation_sg" {
  name        = "PBL-SSH-Observation-SG"
  description = "Temporary SG for passive SSH threat observation"
  vpc_id      = aws_vpc.pbl_vpc.id

  # Assignment requirement:
  # SSH open to the Internet
  ingress {
    description = "SSH observation - Internet"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Assignment requirement:
  # HTTP open to the Internet
  ingress {
    description = "HTTP observation - Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "PBL-SSH-Observation-SG"
    Project     = "Cloud-Security-PBL"
    Purpose     = "24-48 Hour SSH Observation"
    Environment = "Lab"
  }
}