terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.43.0"
    }
  }
}

# Configuration options
provider "aws" {
  region = "us-west-1"

}