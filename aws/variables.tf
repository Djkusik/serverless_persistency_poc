variable "profile" {
    description = "AWS Profile"
    type        = string
    default     = "default"
}

variable "aws_region" {
    description = "AWS region for all resources."
    type        = string
    default     = "eu-west-1"
}