# Required variables for terraform project

variable "project" {
  description = "Project name."
  type        = string
}

variable "project_description" {
  description = "Project description."
  type        = string
}

variable "environment" {
  description = "Project environment."
  default     = "dev"
  type        = string
}

variable "source_directory" {
  description = "Source directory for lamda."
  default     = "../src"
  type        = string
}

variable "runtime" {
  description = "Runtime for the lambda."
  default     = "python3.9"
  type        = string
}

variable "aws_account" {
  description = "Target AWS account."
  type        = string
}

variable "environment_variables" {
  description = "Environment variables to set in the Lambda."
  default     = {}
  type        = map(any)
}

variable "secrets" {
  description = "Set of secrets to create.  This does NOT set them."
  default     = {}
  type        = map(any)
}

