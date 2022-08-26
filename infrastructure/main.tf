terraform {
  required_version = ">=1.2.3"

  backend "s3" {}

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

/**
 * Configure the default AWS Provider
 */
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account}:role/terraformAdministrator"
  }
}

/**
 * Data sources for VPC information
 */

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["rhedcloud-aws-vpc*"]

  }
}

data "aws_subnet" "private_1" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "tag:Name"
    values = ["Private Subnet 1"]
  }
}

data "aws_subnet" "private_2" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "tag:Name"
    values = ["Private Subnet 2"]
  }
}


/**
 * Configure Locals
 */
locals {
  default_tags = {
    "Project"     = var.project
    "Environment" = var.environment
  }
}

resource "aws_security_group" "lambda" {
  name   = "${var.project}-${var.environment}-lambda"
  vpc_id = data.aws_vpc.default.id


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.default_tags
}

resource "aws_secretsmanager_secret" "example" {
  for_each    = var.secrets
  name        = each.key
  description = each.value
}


module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name          = "${var.project}-${var.environment}"
  description            = var.project_description
  handler                = "index.lambda_handler"
  runtime                = var.runtime
  source_path            = "../src/"
  create_package         = true
  vpc_security_group_ids = [aws_security_group.lambda.id]
  vpc_subnet_ids         = [data.aws_subnet.private_1.id, data.aws_subnet.private_2.id]
  attach_network_policy  = true
  environment_variables  = var.environment_variables
}