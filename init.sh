#!/bin/bash

# Exit immediately if a command fails
set -e

echo "===================================================="
echo " STEP 1: Initializing Terraform"
echo "----------------------------------------------------"
echo "Downloading providers and preparing Terraform..."
echo "===================================================="
terraform init


echo "===================================================="
echo " STEP 2: Formatting Terraform Files"
echo "----------------------------------------------------"
echo "Ensuring consistent Terraform formatting..."
echo "===================================================="
terraform fmt


echo "===================================================="
echo " STEP 3: Validating Terraform Configuration"
echo "----------------------------------------------------"
echo "Checking configuration for errors..."
echo "===================================================="
terraform validate


echo "===================================================="
echo " STEP 4: Creating Execution Plan"
echo "----------------------------------------------------"
echo "Generating infrastructure execution plan..."
echo "===================================================="
terraform plan -out=streamlit_app.tfplan


echo "===================================================="
echo " STEP 5: Applying Infrastructure"
echo "----------------------------------------------------"
echo "Provisioning AWS resources..."
echo "===================================================="
terraform apply -auto-approve streamlit_app.tfplan


echo "===================================================="
echo " DEPLOYMENT SUCCESSFUL 🎉"
echo "----------------------------------------------------"
echo "Your Streamlit app is available at:"
echo "===================================================="
APP_URL=$(terraform output -raw application_url)
echo "http://$APP_URL"
echo ""
echo "===================================================="