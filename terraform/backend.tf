terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "litecoin-luis"
    key    = "state.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}