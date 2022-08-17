variable "aws_region" {
  description = "Region for the Development Environment"
  default = "us-east-2"
}

# Define SSH key pair for our instances
variable "key_path" {
  description = "SSH Key path"
  default = "~/.ssh/cfoffload.pem"
}