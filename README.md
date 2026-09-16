1. Objective

This unit focuses on designing and deploying a secure three-tier cloud architecture on AWS and documenting the security responsibilities and exposed attack surface.

The architecture is divided into:

Web Tier — Public-facing web server

Application Tier — Private application subnet

Database Tier — Private database subnet

2. AWS Architecture

VPC

Region: AWS Asia Pacific (Mumbai) — ap-south-1

VPC CIDR: 10.0.0.0/16

VPC ID: vpc-0276b3f44e6e51e0a

Subnets

Tier

Subnet CIDR

Type

Web

10.0.1.0/24

Public

App

10.0.2.0/24

Private

DB

10.0.3.0/24

Private

The Web tier is internet-facing, while the App and DB tiers are placed in private subnets.

3. Security Groups

Web Security Group

Allows:

HTTP — TCP 80 from the Internet

HTTPS — TCP 443 from the Internet

Application Security Group

Allows:

TCP 8080 only from the Web Security Group

Database Security Group

Allows:

PostgreSQL TCP 5432 only from the Application Security Group

This implements tier-to-tier access control rather than exposing internal services directly to the Internet.

4. SSH Observation Security Group

A separate observation security group was configured for the PBL SSH threat-observation exercise.

Rules:

SSH — TCP 22 → 0.0.0.0/0

HTTP — TCP 80 → 0.0.0.0/0

This intentional exposure is used only for observing unsolicited internet activity against an SSH-enabled Linux server.

Observation Security Group ID: sg-00a07508f4618063d

5. EC2 Web Server

The EC2 web server is deployed in the public Web subnet.

Instance ID: i-0ac93d8d4f9f2f21b

Instance Type: t3.micro

Operating System: Amazon Linux 2023

Web Server: Nginx

Root Volume: 8 GB gp3, encrypted

Monitoring: Detailed monitoring enabled

Management: AWS Systems Manager Session Manager

The web server was verified using Nginx and a browser-based HTTP request.

6. S3 Security

The project includes an S3 bucket:

pbl-cloud-security-371253588a3a74db423aadd4d

Security configuration:

Block Public Access enabled

Server-side encryption using AES256

Bucket is not intentionally exposed publicly

7. Infrastructure as Code

The AWS infrastructure was provisioned using Terraform.

Terraform was used to define:

VPC

Public and private subnets

Internet Gateway

Route tables

Security groups

S3 bucket

IAM resources

EC2 instance

IAM role and instance profile

The final Terraform deployment completed successfully.

8. Shared Responsibility

AWS follows a shared responsibility model.

AWS is responsible for:

Physical data centers

Physical servers and networking

Underlying cloud infrastructure

Managed infrastructure security

Customer is responsible for:

IAM configuration

Security groups

Network architecture

EC2 operating-system security

Application security

Data protection

Encryption configuration

Least-privilege access

This project demonstrates customer-side security controls through network segmentation, security groups, encryption, IAM and secure infrastructure configuration.

9. SSH Observation Evidence

The SSH service logs were checked using:

sudo journalctl -u sshd --since "24 hours ago"

Failed authentication attempts can be filtered using:

sudo journalctl -u sshd --since "24 hours ago" | grep -Ei "failed|invalid user|authentication failure"

The supplied evidence shows external SSH connection activity and authentication timeouts.

Important: The supplied screenshot was captured before a complete 24-hour observation window had elapsed. Therefore, the 24–48 hour observation requirement should only be marked complete after the required observation period and final log capture have been completed.

10. Evidence

The corresponding Unit 1 evidence PDF contains screenshots and supporting explanations for the AWS/Terraform infrastructure.

Recommended GitHub structure:

Unit-1/
├── README.md
└── evidence/
    └── Unit_1_Cloud_Security_PBL.pdf

11. Security Notice

Do not upload or publish:

AWS secret access keys

Passwords

Private keys

Session credentials

Sensitive tokens

Public IP addresses and account identifiers should also be avoided in public repositories where possible.

Conclusion

Unit 1 demonstrates a segmented three-tier AWS architecture provisioned with Terraform, with controlled network access, private application/database tiers, encrypted storage, and documented SSH exposure for security observation.
