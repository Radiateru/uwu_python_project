resource "aws_security_group" "sg_front" {
  name        = "front_sg_recharge"
  description = "EZ FOR ENCE"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "front_sg_recharge"
  }
}
resource "aws_security_group" "sg_alb" {
  name        = "alb_sg_recharge"
  description = "EZ FOR ENCE"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "alb_sg_recharge"
  }
}

resource "aws_security_group" "sg_bastion" {
  name        = "bastion_sg_recharge"
  description = "EZ FOR ENCE"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "bastion_sg_recharge"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_self_front" {
  security_group_id = aws_security_group.sg_front.id
  cidr_ipv4         = "128.78.144.27/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_front" {
  security_group_id = aws_security_group.sg_front.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_alb" {
  security_group_id = aws_security_group.sg_bastion.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_bastion" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"  
}

resource "aws_security_group_rule" "allow_http_from_sg_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_front.id
  source_security_group_id = aws_security_group.sg_alb.id
}

resource "aws_security_group_rule" "allow_ssh_from_sg_bastion" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_front.id
  source_security_group_id = aws_security_group.sg_bastion.id
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_public" {
  security_group_id = aws_security_group.sg_alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_self_bastion" {
  security_group_id = aws_security_group.sg_bastion.id
  cidr_ipv4         = "128.78.144.27/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}