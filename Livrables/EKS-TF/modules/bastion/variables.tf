variable "namespace" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "vpc" {
  type = any
}

variable key_name {
  type = string
}

variable "sg_pub_id" {
  type = any
}

variable "tags" {
  type        = list(number)
  description = "instances number"
  default     = [1, 2]
}