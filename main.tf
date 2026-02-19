# ---------------------------
# Get latest Amazon Linux 2023 AMI
# ---------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "web_sg" {
  name        = "tech-challenge-web-sg"
  description = "Allow SSH and HTTP"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# ---------------------------
# S3 Bucket
# ---------------------------
resource "aws_s3_bucket" "app_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
}

# ---------------------------
# IAM Role for EC2
# ---------------------------
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "tc3-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
  tags               = var.tags
}

# ---------------------------
# IAM Policy (S3 access only to this bucket)
# ---------------------------
data "aws_iam_policy_document" "s3_bucket_rw" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.app_bucket.arn]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["${aws_s3_bucket.app_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "s3_bucket_rw" {
  name   = "tc3-s3-bucket-rw"
  policy = data.aws_iam_policy_document.s3_bucket_rw.json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_bucket_rw.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "tc3-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# ---------------------------
# EC2 Instance
# ---------------------------
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  tags = merge(var.tags, {
    Name = "tech-challenge-3-web"
  })
}