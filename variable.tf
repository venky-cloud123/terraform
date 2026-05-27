variable "vpc-cidr" {

  type    = string
  default = "10.0.0.0/16"
}

variable "Name" {
  type    = string
  default = "Sample"

}

variable "psubnet-cidr" {
  type    = string
  default = "10.0.0.0/24"

}

variable "prisubnet-cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "cidr" {
  type    = string
  default = "0.0.0.0/0"
}