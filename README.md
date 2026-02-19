🚀 Tech Challenge 3
Infrastructure as Code with Terraform & Configuration Management with Ansible
📌 Overview

This project provisions AWS infrastructure using Terraform and configures an EC2 instance using Ansible to host a simple web application displaying:

Hello, World!

The infrastructure and configuration are fully automated and version controlled.

🏗 Architecture

This solution provisions:

✅ EC2 Instance (Amazon Linux 2023)

✅ S3 Bucket

✅ IAM Role & Policy (attached to EC2)

✅ Security Group (SSH + HTTP)

✅ Nginx Web Server configured via Ansible

✅ Hosted web page accessible publicly

🌐 Live Application

Web URL:

http://3.145.189.199/

Displays:

Hello, World!
📂 Project Structure
tech-challenge-3/
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── .terraform.lock.hcl
├── .gitignore
│
└── ansible/
    ├── inventory.ini
    ├── playbook.yml
    └── files/
        └── index.html
⚙️ Prerequisites

Ensure the following are installed:

Terraform

AWS CLI (configured with credentials)

Ansible

Existing EC2 key pair in AWS region (tech-challenge-key)

macOS or Linux environment

Verify AWS access:

aws sts get-caller-identity
🚀 Deployment Instructions
Step 1️⃣ – Provision Infrastructure (Terraform)
1. Initialize Terraform
terraform init
2. Format & Validate
terraform fmt -recursive
terraform validate
3. Configure terraform.tfvars

Create a file:

bucket_name = "tc3-yourname-uniquevalue"

⚠️ S3 bucket names must be globally unique.

4. Plan Deployment
terraform plan
5. Apply
terraform apply
6. Get Outputs
terraform output

Outputs include:

instance_id

instance_public_ip

🔧 Step 2 – Configure EC2 with Ansible

Update ansible/inventory.ini with the Terraform output IP:

[web]
<instance_public_ip> ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/tech-challenge-key.pem
🔍 Test Connectivity
ansible -i ansible/inventory.ini web -m ping

Expected output:

"ping": "pong"
🚀 Run Configuration Playbook
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

This playbook:

Installs Nginx

Enables and starts Nginx

Deploys a custom index.html

Hosts "Hello, World!"

🌍 Verify Deployment

Open in browser:

http://<instance_public_ip>/

Or verify via CLI:

curl http://<instance_public_ip>

Expected response:

<h1>Hello, World!</h1>
🔐 IAM Configuration

The EC2 instance is attached to:

IAM Role: tc3-ec2-role

Custom Policy: Limited S3 read/write access to the created bucket

IAM Instance Profile attached during provisioning

This demonstrates secure, scoped permission management.

🪣 S3 Configuration

A dedicated S3 bucket is provisioned via Terraform.

Features:

Globally unique name

force_destroy = true

Managed via IAM policy attached to EC2

🧹 Cleanup

To destroy all infrastructure and avoid charges:

terraform destroy
🛠 Technologies Used

Terraform – Infrastructure as Code

Ansible – Configuration Management

AWS EC2

AWS IAM

AWS S3

Nginx

Git & GitHub

📊 Evaluation Criteria Coverage

✅ Functional hosted webpage
✅ Terraform provisioning (EC2, S3, IAM, SG)
✅ Ansible configuration automation
✅ Clean, structured repository
✅ Proper state management (.gitignore configured)
✅ Private GitHub repository shared with mentor

👩‍💻 Author

Aundrea Gordon
Cloud Engineer Coding Challenge 3 Submission