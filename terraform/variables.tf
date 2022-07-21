variable "instance_image" {
  type    = string
  default = "ami-006d3995d3a6b963b"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "availability_zone" {
  type    = string
  default = "ap-south-1a"
}
variable "keypair" {
  type    = string
  default = "awswebserver"
}

variable "ingress_rules" {
  type = map(map(any))
  default = {
    rule1 = { from = 22, to = 22, protocol = "tcp", cidr = "0.0.0.0/0", description = "ssh" }
    rule2 = { from = 27017, to = 27017, protocol = "tcp", cidr = "0.0.0.0/0", description = "mongodb" }
    rule3 = { from = 9100, to = 9100, protocol = "tcp", cidr = "0.0.0.0/0", description = "prometheus-node" }
    rule4 = { from = 9200, to = 9200, protocol = "tcp", cidr = "0.0.0.0/0", description = "prometheus-mongo" }
  }
}
variable "egress_rules" {
  type = map(map(any))
  default = {
    rule1 = { from = 0, to = 0, protocol = "-1", cidr = "0.0.0.0/0" }
  }
}

variable "instances" {
  type = map(map(any))
  default = {
    instance1 = { name = "mongo-rs-01", type = "t2.micro" }
    instance2 = { name = "mongo-rs-02", type = "t2.micro" }
    instance3 = { name = "mongo-rs-03", type = "t2.micro" }
  }
}
