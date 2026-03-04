output "application_domain" {
  description = "Public URL of the deployed Streamlit application"
  value       = aws_elastic_beanstalk_environment.ebs_app_env.endpoint_url
}

output "application_url" {
  description = "Elastic Beanstalk CNAME URL"
  value       = aws_elastic_beanstalk_environment.ebs_app_env.cname
}