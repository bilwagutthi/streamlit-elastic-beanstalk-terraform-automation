# Strep 1 : set up s3 bucket and upload the source code

data "archive_file" "source" {
  type        = "zip"                             # Specifies the archive format
  source_dir  = "${path.module}/StreamlitApp"     # Points to the local folder to zip
  output_path = "${path.module}/StreamlitApp.zip" # Specifies where to save the resulting zip file
}

resource "aws_s3_bucket" "ebs_bucket" {
  bucket = "${var.app_name}-on-ebs-bucket"
  tags   = var.common_tags
}

resource "aws_s3_object" "ebs_app_zip_object" {
  bucket = aws_s3_bucket.ebs_bucket.bucket
  key    = "StreamlitApp.zip"
  source = data.archive_file.source.output_path
}

# Step 2: Create the Elastic Beanstalk and upload the application

resource "aws_iam_role" "beanstalk_service" {
  name = "${var.app_name}-beanstalk-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.common_tags
}

resource "aws_iam_role" "beanstalk_ec2_role" {
  name = "${var.app_name}-beanstalk-ec2-role"

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

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "beanstalk_service_managed" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "beanstalk_enhanced_health" {
  role       = aws_iam_role.beanstalk_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "beanstalk_ec2_policy" {
  role       = aws_iam_role.beanstalk_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "${var.app_name}-beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_ec2_role.name
}

resource "aws_elastic_beanstalk_application" "ebs_app" {
  name        = "${var.app_name}-ebs-app"
  description = var.ebs_app_description

  appversion_lifecycle {
    service_role          = aws_iam_role.beanstalk_service.arn
    max_count             = 128
    delete_source_from_s3 = false
  }

  tags = var.common_tags
}

resource "aws_elastic_beanstalk_application_version" "ebs_app_version" {
  name        = "${var.app_name}-ebs-app-v1"
  application = aws_elastic_beanstalk_application.ebs_app.name

  bucket = aws_s3_bucket.ebs_bucket.bucket
  key    = aws_s3_object.ebs_app_zip_object.key
}

resource "aws_elastic_beanstalk_environment" "ebs_app_env" {
  name                = "${var.app_name}-env"
  application         = aws_elastic_beanstalk_application.ebs_app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.10.0 running Python 3.12"
  version_label       = aws_elastic_beanstalk_application_version.ebs_app_version.name

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.beanstalk_service.arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.beanstalk_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "PORT"
    value     = "8501"
  }

  tags = var.common_tags
}