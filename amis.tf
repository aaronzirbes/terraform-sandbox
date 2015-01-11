# Ubuntu Trusty 14.04 LTS (amd64)
variable "ubuntu_amis" {
    default = {
        eu-west-1 = "ami-903686e7"
        us-east-1 = "ami-64e27e0c"
        us-west-1 = "ami-c5180880"
        us-west-2 = "ami-978dd9a7"
    }
}

# Amazon NAT AMIs (amzn-ami-vpc-nat)
variable "nat_amis" {
    default = {
        eu-west-1 = "???"
        us-east-1 = "ami-809f4ae8"
        us-west-1 = "???"
        us-west-2 = "???"
    }
}
