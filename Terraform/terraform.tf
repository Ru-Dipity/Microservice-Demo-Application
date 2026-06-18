# Copyright (c) HashiCorp, Inc.

terraform {

  # cloud {
  #   workspaces {
  #     name = "learn-terraform-eks"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"  # Updated to more recent version
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"  # Updated random string provider
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.6"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.7"
    }
  }

  required_version = "~> 1.0"  # Compatible with Terraform 1.x versions
}

