variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "unnamed"
}

variable "environment" {
  description = "Environment of all the resources"
  type        = string
  default     = "nonprod"
}

variable "region" {
  description = "Region to be used on all the resources"
  type        = string
  default     = "us-east-1"
}

variable "region_dr" {
  description = "Region to be used on all the disaster recovery resources"
  type        = string
  default     = "us-west-2"
}
