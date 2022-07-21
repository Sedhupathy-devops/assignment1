resource "aws_security_group" "mongodb" {
  name = "mongodb"
}

resource "aws_security_group_rule" "ingress_rules" {
  for_each          = var.ingress_rules
  type              = "ingress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr]
  description       = each.value.description
  security_group_id = aws_security_group.mongodb.id
}
resource "aws_security_group_rule" "egress_rules" {
  for_each          = var.egress_rules
  type              = "egress"
  from_port         = each.value.from
  to_port           = each.value.to
  protocol          = each.value.protocol
  cidr_blocks       = [each.value.cidr]
  security_group_id = aws_security_group.mongodb.id
}

resource "aws_instance" "mongodb_replicaset" {
  for_each               = var.instances
  ami                    = var.instance_image
  instance_type          = each.value.type
  availability_zone      = var.availability_zone
  key_name               = var.keypair
  vpc_security_group_ids = [aws_security_group.mongodb.id]
  tags = {
    Name = each.value.name
  }
}
