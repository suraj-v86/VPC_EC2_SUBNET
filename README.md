# AWS VPC, Public Subnet & EC2 Deployment with Terraform

![AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazonaws)
![Terraform](https://img.shields.io/badge/Terraform-Infrastructure_as_Code-7B42BC?logo=terraform)
![Region](https://img.shields.io/badge/Region-us--east--1-blue)

## Project Overview

This project demonstrates how to provision AWS networking and compute infrastructure using Terraform.

It creates a Virtual Private Cloud (VPC), a subnet configured for internet connectivity, an Internet Gateway, a route table, a security group, and an EC2 instance. Terraform manages the infrastructure as code, while an S3 backend stores the Terraform state remotely.

The project helped me practise AWS networking, EC2 provisioning, Terraform variables, remote state configuration, and automated instance initialization using a user-data script.

## Architecture

The infrastructure is deployed in the AWS `us-east-1` region.

```text
AWS Region: us-east-1
|
└── VPC: 10.0.0.0/16
    |
    ├── Internet Gateway
    |
    ├── Route Table
    |   └── 0.0.0.0/0 → Internet Gateway
    |
    └── Subnet: 10.0.101.0/24
        |
        ├── Route Table Association
        |
        ├── Security Group
        |   ├── SSH: TCP 22
        |   ├── HTTP: TCP 80
        |   └── Outbound: All traffic
        |
        └── EC2 Instance
            ├── Public IP enabled
            └── User data: userdata.sh
```

The subnet is associated with a route table containing a default route to the Internet Gateway. The EC2 instance is configured to receive a public IP address.

## AWS Resources Created

| Resource | Configuration | Purpose |
|---|---|---|
| VPC | `10.0.0.0/16` | Provides isolated virtual networking |
| Subnet | `10.0.101.0/24` | Hosts the EC2 instance |
| Internet Gateway | Attached to the VPC | Provides a route to the internet |
| Route Table | Default route `0.0.0.0/0` | Routes internet-bound traffic through the Internet Gateway |
| Route Table Association | Connects subnet to route table | Applies the configured routes to the subnet |
| Security Group | Allows inbound TCP 22 and 80 | Controls network access to the instance |
| EC2 Instance | AMI, key pair, and instance type supplied through variables | Provides compute capacity |
| S3 Backend | Remote Terraform state | Stores the Terraform state file remotely |

## Technologies Used

- **Amazon Web Services (AWS):** Cloud infrastructure
- **Amazon VPC:** Virtual networking
- **Amazon EC2:** Compute instance
- **AWS Internet Gateway and Route Tables:** Network routing
- **AWS Security Groups:** Network access control
- **Terraform:** Infrastructure as Code
- **Amazon S3:** Remote Terraform state storage
- **Shell scripting:** EC2 initialization through `userdata.sh`

## Repository Structure

```text
VPC_EC2_SUBNET/
├── main.tf
├── variables.tf
├── provider.tf
├── backend.tf
├── userdata.sh
├── terraform.tfvars
└── README.md
```

This is the suggested structure based on the configuration shared. Adjust the filenames to match the actual files in your repository. Keep `terraform.tfvars` out of version control if it contains sensitive information.

## Prerequisites

Before deploying the infrastructure, ensure you have:

- An AWS account with the required permissions.
- Terraform installed.
- AWS CLI configured with an appropriate authentication method.
- An existing EC2 key pair in the selected AWS region.
- A valid AMI ID compatible with the selected region and instance configuration.
- An existing S3 bucket for the Terraform backend.
- The `userdata.sh` script in the Terraform working directory.

## Deployment Guide

### 1. Clone the repository

```bash
git clone https://github.com/suraj-v86/VPC_EC2_SUBNET.git
cd VPC_EC2_SUBNET
```

### 2. Configure AWS authentication

Configure AWS CLI credentials or another supported authentication method.

Verify the active identity:

```bash
aws sts get-caller-identity
```

Never hardcode AWS access keys or secret keys in Terraform files.

### 3. Configure the input variables

Provide the required values for the AMI ID, EC2 key pair name, and instance type using a `terraform.tfvars` file or another supported variable input method.

Example format:

```hcl
ami      = "ami-REPLACE_WITH_VALID_AMI_ID"
key      = "REPLACE_WITH_YOUR_KEY_PAIR_NAME"
instance = "REPLACE_WITH_INSTANCE_TYPE"
```

Replace these placeholders with valid values for your environment. The AMI must be available in `us-east-1`.

### 4. Initialize Terraform

```bash
terraform init
```

Terraform initializes the AWS provider and configures the S3 backend.

The configured S3 bucket must already exist and be accessible with the required permissions. The backend currently uses the key `ec2/terraform.tfstate` in `us-east-1`.

### 5. Validate the configuration

```bash
terraform validate
```

This checks the Terraform configuration for syntax and internal consistency.

### 6. Review the execution plan

```bash
terraform plan
```

Review the proposed resource changes before provisioning.

### 7. Deploy the infrastructure

```bash
terraform apply
```

Review the plan and enter `yes` when prompted to approve the deployment.

### 8. Retrieve the EC2 public IP

After a successful deployment, retrieve the configured output:

```bash
terraform output public_ip
```

The output returns the public IP address assigned to the EC2 instance.

## Security Considerations

The current security group allows inbound SSH and HTTP traffic from `0.0.0.0/0`.

- **SSH (TCP 22):** Restrict the source CIDR to your trusted public IP address before deploying in a real environment.
- **HTTP (TCP 80):** Allow public access only when a publicly accessible web service is intended.
- **SSH authentication:** Protect the private key associated with the configured EC2 key pair.
- **AWS credentials:** Never commit credentials, private keys, or secrets to GitHub.
- **Terraform state:** Remote state can contain sensitive infrastructure information. Protect the S3 bucket with appropriate permissions, encryption, and access controls.

For production use, also review S3 state locking and recovery options. The current backend configuration does not explicitly configure a lock mechanism.

## Cleanup

When the infrastructure is no longer needed, review the destruction plan:

```bash
terraform plan -destroy
```

If the plan is correct, remove the resources managed by this Terraform configuration:

```bash
terraform destroy
```

Confirm the operation when prompted.

Check the AWS console afterward to ensure that no unwanted billable resources remain. The S3 backend bucket is pre-existing and is not created by this configuration, so it should not be assumed to be removed by `terraform destroy`.

## Key Learnings

Through this project, I practised:

- Provisioning AWS infrastructure using Terraform.
- Configuring VPC CIDR blocks and subnet CIDR ranges.
- Connecting a VPC to an Internet Gateway.
- Configuring route tables and subnet associations.
- Applying security group rules to an EC2 instance.
- Using Terraform variables to supply instance configuration.
- Configuring remote Terraform state storage in Amazon S3.
- Initializing an EC2 instance through a user-data script.
- Reviewing infrastructure plans and managing resource cleanup.

## Author

**Suraj Vasudevan C K**

IT Technical Support | DevOps & Cloud | AI Engineering

- GitHub: [suraj-v86](https://github.com/suraj-v86)
- Repository: [VPC_EC2_SUBNET](https://github.com/suraj-v86/VPC_EC2_SUBNET)

This project is part of my hands-on learning journey in AWS, DevOps, and Infrastructure as Code.
