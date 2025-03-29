
# AWS Infrastructure Automation with Terraform, Docker, Jenkins, and GitHub Pipelines

This repository showcases a comprehensive automation pipeline for deploying AWS infrastructure, leveraging Terraform, Docker, Jenkins, and GitHub. The project originated from a hands-on, learn-by-doing approach, where manual experimentation transitioned into a fully automated, secure, and version-controlled deployment process.

## Project Overview

This project automates the creation and management of AWS resources, including IAM roles, VPC networking, EC2 instances, and containerized applications (Java and Jenkins), using Terraform and Bash scripting. It emphasizes security best practices and implements a robust CI/CD pipeline through Jenkins, triggered by GitHub commits.

### Key Components

* **Terraform:** Infrastructure as Code (IaC) for AWS resource provisioning.
* **AWS Services:** IAM, VPC, Subnets, Internet Gateway, Route Tables, Security Groups, EC2.
* **Bash Scripting:** User data scripts for EC2 instance configuration and application deployment.
* **Docker:** Containerization of Java and Jenkins applications.
* **Jenkins:** CI/CD automation server.
* **GitHub:** Version control and pipeline triggering.
* **GitHub Codespaces:** Integrated development environment.

## Architecture

```mermaid
graph TD
    A[GitHub Commit] --> B(Jenkins Pipeline Trigger);
    B --> C{Terraform Stages};
    C --> D[Terraform Init];
    D --> E[Terraform Fmt];
    E --> F[Terraform Validate];
    F --> G[Terraform Plan];
    G --> H{Manual Plan Approval (MPA)};
    H -- Approved --> I[Terraform Apply];
    I --> J[AWS IAM];
    I --> K[AWS VPC];
    I --> L[AWS Subnets];
    I --> M[AWS Internet Gateway];
    I --> N[AWS Route Tables];
    I --> O[AWS Security Groups];
    I --> P[AWS EC2 Instance];
    P --> Q{User Data Script};
    Q --> R[Update Repository];
    Q --> S[Install Docker];
    S --> T[Java Docker Container];
    T --> U[Wait for Java Application];
    U --> V[Jenkins Docker Container];
    H -- Rejected --> W[Pipeline Abort];
```

## Prerequisites
1. AWS Account: An active AWS account with necessary permissions.
2. AWS CLI: Configured AWS CLI.
3. Terraform: Installed and configured.
4. Jenkins: Installed and configured with AWS credentials and Terraform plugin.
5. GitHub Repository: A GitHub repository to store the Terraform code and Jenkins pipeline.
6. GitHub Codespaces (Recommended): For a consistent and pre-configured development environment.

Getting Started
1. Clone the Repository:

**Bash**
```
1. git clone <repository_url>
cd <repository_name>

2. Configure AWS Credentials:```
- Set up AWS credentials in Jenkins and/or GitHub Codespaces.

3. Initialize Terraform (Jenkins Pipeline):
- The Jenkins pipeline will automatically execute terraform init.

4. Review and Modify Terraform Variables (Optional):
- Modify variables.tf or create terraform.tfvars to customize the deployment.

5. GitHub Commit and Jenkins Pipeline Trigger:
- Commit changes to the GitHub repository to trigger the Jenkins pipeline.
- The pipeline will execute terraform fmt, terraform validate, and terraform plan.

6. Manual Plan Approval (MPA):
- Jenkins will pause for manual approval after the terraform plan stage.
- Review the plan and approve or reject the deployment.

7. Apply Terraform Configuration (Jenkins Pipeline):
- Upon approval, Jenkins will execute terraform apply to provision the AWS resources.

8. Access Deployed Resources:
- Retrieve the EC2 instance's public IP and access the deployed Java and Jenkins applications.
```

**Terraform Resources:**
IAM: Secure IAM roles and policies.
VPC: Isolated virtual network.
Subnets: Public subnets for EC2 instances.
Internet Gateway: Internet connectivity for the VPC.
Route Tables: Network routing configuration.
Security Groups: Ingress and egress traffic control.
EC2 Instance: Compute instance with user data script.
IAM Policy Attachments: Attaching necessary policies to IAM roles.

**User Data Script (Bash):**
The user data script automates the following tasks:
1. Updates system packages.
2. Installs Docker.
3. Runs a Java application in a Docker container.
4. Waits for the Java application to start.
5. Runs a Jenkins server in a Docker container.

**Project Structure:**
├── main.tf           # Main Terraform configuration file
├── variables.tf      # Terraform variables
├── outputs.tf        # Terraform output values
├── user_data.sh      # Bash script for EC2 instance configuration
├── Jenkinsfile       # Jenkins pipeline definition
├── README.md         # This file

**Automation and Security:**
1. Jenkins Pipeline: Automates Terraform stages (init, fmt, validate, plan, apply).
2. Manual Plan Approval (MPA): Enhances security by requiring human review before deployment.
3. Version Control: GitHub ensures version control and rollback capabilities.
4. Least Privilege Principle: IAM roles and policies adhere to the principle of least privilege.
5. Security Groups: Enforce strict inbound and outbound traffic rules.

**Learnings and Insights:**
- Seamless integration of Terraform, Docker, Jenkins, and GitHub.
- Implementation of secure and automated infrastructure deployments.
- Importance of manual plan approval in CI/CD pipelines.
- Effective use of Bash scripting for EC2 instance configuration.
- Version control for infrastructure as code.

**Future Enhancements:**
- Implement automated testing and validation within the Jenkins pipeline.
- Integrate AWS Secrets Manager for secure credential management.
- Add monitoring and logging capabilities.
- Implement Blue/Green deployments.
- Add automated rollback capabilities.

