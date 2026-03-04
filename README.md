# 🚀 Streamlit on AWS Elastic Beanstalk — Fully Automated with Terraform

This project deploys a Streamlit application to AWS Elastic Beanstalk using only Terraform.

The goal is simple:

Run one script → Infrastructure is provisioned → Public URL is printed → App is live.

No manual Elastic Beanstalk configuration.  
No console uploads.  
Pure Infrastructure as Code.

---

# 🎯 What This Project Does

- Packages the Streamlit app automatically
- Uploads the source bundle to S3
- Creates Elastic Beanstalk Application
- Creates Application Version from S3
- Provisions the Environment
- Configures IAM Roles & Instance Profile
- Outputs the public domain URL

---

# 📁 Project Structure

```
.
├── StreamlitApp/
│   ├── app.py
│   ├── requirements.txt
│   ├── Procfile
│   └── .ebextensions/
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars   # NOT committed
├── init.sh
└── README.md
```

---

# 🛠 Tech Stack

- Streamlit  
- AWS Elastic Beanstalk  
- Terraform  
- Amazon S3  
- IAM  

---

# ⚙️ Setup

## 1️⃣ Configure AWS Credentials

Set your credentials inside `terraform.tfvars`:

```
aws_region     = "us-east-1"
aws_access_key = "YOUR_ACCESS_KEY"
aws_secret_key = "YOUR_SECRET_KEY"
```

⚠️ Do NOT commit this file to version control.  
Make sure `terraform.tfvars` is added to `.gitignore`.

---

## 2️⃣ Deploy (Git Bash)

```
chmod +x init.sh
./init.sh
```

Terraform will:

- Initialize
- Validate
- Plan
- Apply
- Output the public URL

Example output:

```
DEPLOYMENT SUCCESSFUL
----------------------------------------
Your Streamlit app is available at:
http://your-env-name.eba-xxxxx.us-east-1.elasticbeanstalk.com/
```

Open the URL in your browser — your app is live.

---

# 🧹 Destroy Infrastructure

To remove everything:

```
terraform destroy
```

---

# 📜 License

MIT License.