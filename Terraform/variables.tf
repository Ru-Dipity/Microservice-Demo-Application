# Copyright (c) HashiCorp, Inc.

variable "region" {
  description = "AWS region - us-east-1 is cheaper"
  type        = string
  default     = "us-east-1"
}
