# ============================================================
# IAM GROUPS
# ============================================================

resource "aws_iam_group" "developers" {
  name = "PBL-Developers"
}

resource "aws_iam_group" "auditors" {
  name = "PBL-Auditors"
}


# ============================================================
# DEVELOPER POLICY - LEAST PRIVILEGE
# ============================================================

resource "aws_iam_policy" "developer_policy" {
  name        = "PBL-Developer-LeastPrivilege"
  description = "Limited permissions for PBL developers"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "EC2ReadOnly"
        Effect = "Allow"

        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets"
        ]

        Resource = "*"
      },

      {
        Sid    = "S3ApplicationAccess"
        Effect = "Allow"

        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = [
          aws_s3_bucket.pbl_bucket.arn,
          "${aws_s3_bucket.pbl_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "developer_policy_attachment" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_policy.arn
}


# ============================================================
# AUDITOR POLICY - READ ONLY
# ============================================================

resource "aws_iam_policy" "auditor_policy" {
  name        = "PBL-Auditor-ReadOnly"
  description = "Read-only permissions for cloud security auditing"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ReadOnlyAWSResources"
        Effect = "Allow"

        Action = [
          "ec2:Describe*",
          "iam:Get*",
          "iam:List*",
          "s3:GetBucketLocation",
          "s3:GetBucketPolicy",
          "s3:ListAllMyBuckets",
          "cloudtrail:DescribeTrails",
          "cloudtrail:GetTrailStatus"
        ]

        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "auditor_policy_attachment" {
  group      = aws_iam_group.auditors.name
  policy_arn = aws_iam_policy.auditor_policy.arn
}


# ============================================================
# EC2 IAM ROLE
# ============================================================

resource "aws_iam_role" "ec2_s3_role" {
  name = "PBL-EC2-S3-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "PBL-EC2-S3-Role"
    Project = "Cloud-Security-PBL"
  }
}


# ============================================================
# EC2 → S3 LEAST PRIVILEGE POLICY
# ============================================================

resource "aws_iam_policy" "ec2_s3_policy" {
  name        = "PBL-EC2-S3-LeastPrivilege"
  description = "Allows EC2 limited access to the PBL S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "ListPBLBucket"
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.pbl_bucket.arn
      },

      {
        Sid    = "ReadWritePBLObjects"
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.pbl_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_s3_policy_attachment" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ec2_s3_policy.arn
}


# ============================================================
# INSTANCE PROFILE
# ============================================================

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "PBL-EC2-S3-Instance-Profile"
  role = aws_iam_role.ec2_s3_role.name
}
# ============================================================
# EC2 SYSTEMS MANAGER ACCESS
# ============================================================

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy_attachment" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}