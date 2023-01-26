terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.46.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.1"
    }
  }

  required_version = "~> 1.3"
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

##4bucket
provider "aws" {
  region = var.region
}

terraform {
 backend "s3" {
   region         = "eu-central-1"
   bucket         = "my-tform-state"
   key            = "global/tfstate/terraform.tfstate"
   dynamodb_table = "my-tform-lock"
   encrypt        = true
 }
}


resource "aws_s3_bucket" "my-tform-state" {
  bucket = "my-tform-state"
}

resource "aws_s3_bucket_acl" "my-tform-state" {
  bucket = aws_s3_bucket.my-tform-state.id
  acl    = "private"
}

resource "aws_dynamodb_table" "my-tform-lock" {
  name           = "my-tform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
##4bucket

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}
