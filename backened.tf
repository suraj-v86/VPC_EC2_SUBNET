terraform {
  backend "s3" {
    bucket         = "suraj-v-86"        # Your S3 bucket (must exist already)
    key            = "ec2/terraform.tfstate"  # Save state file at this path
    region         = "us-east-1"  
    
  }
}
