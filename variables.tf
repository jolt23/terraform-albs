variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "The region to use for AWS Account."
}

variable "aws_profile" {
  type        = string
  description = "The profile to use for AWS Account configuration."
}

variable "aws_vpc_id" {
  type        = string
  description = "The VPC ID, to use for deployment of AWS resources."
}

variable "aws_subnet_ids" {
  type        = list
  description = "A list of subnets to deploy the application loadbalancers to."
}

variable "aws_sg_ids" {
  type        = list
  description = "A list of security groups to attache to the application loadbalancers."
}