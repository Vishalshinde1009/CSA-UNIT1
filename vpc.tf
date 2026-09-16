resource "aws_vpc" "pbl_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "PBL-VPC"
    Project     = "Cloud-Security-PBL"
    Environment = "Lab"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "pbl_igw" {
  vpc_id = aws_vpc.pbl_vpc.id

  tags = {
    Name    = "PBL-Internet-Gateway"
    Project = "Cloud-Security-PBL"
  }
}

# -------------------------
# Web Tier - Public Subnet
# -------------------------

resource "aws_subnet" "web_subnet" {
  vpc_id                  = aws_vpc.pbl_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "PBL-Web-Public-Subnet"
    Tier = "Web"
  }
}

# -------------------------
# App Tier - Private Subnet
# -------------------------

resource "aws_subnet" "app_subnet" {
  vpc_id            = aws_vpc.pbl_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "PBL-App-Private-Subnet"
    Tier = "App"
  }
}

# -------------------------
# DB Tier - Private Subnet
# -------------------------

resource "aws_subnet" "db_subnet" {
  vpc_id            = aws_vpc.pbl_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "PBL-DB-Private-Subnet"
    Tier = "Database"
  }
}

# -------------------------
# Public Route Table
# -------------------------

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.pbl_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pbl_igw.id
  }

  tags = {
    Name = "PBL-Public-Route-Table"
  }
}

# Associate Web subnet with Public Route Table
resource "aws_route_table_association" "web_public_association" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------------
# Private Route Table
# -------------------------

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.pbl_vpc.id

  tags = {
    Name = "PBL-Private-Route-Table"
  }
}

# App subnet association
resource "aws_route_table_association" "app_private_association" {
  subnet_id      = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# DB subnet association
resource "aws_route_table_association" "db_private_association" {
  subnet_id      = aws_subnet.db_subnet.id
  route_table_id = aws_route_table.private_rt.id
}