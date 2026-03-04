variable "aws_access_key" {
  sensitive = true
}

variable "aws_secret_key" {
  sensitive = true
}

variable "aws_region" {
  default = "us-east-1"
}

variable "app_name" {
  default = "my-streamlit-app"
}

variable "environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project     = "my-streamlit-app"
    Environment = "dev"
    CreatedBy   = "Terraform"
  }
}

variable "ebs_app_description" {
  default = "Elastic Beanstalk Application for Streamlit"
}