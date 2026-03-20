resource "aws_instance" "webapp_1" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = ${var.instancetype}
  key_name = "vockey"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.sg_front.id]
  subnet_id = aws_subnet.private1.id

  tags = {
    Name = "webapp1_${var.environment}"
    Environment = var.environment
  }
  user_data = file("${path.module}/inst_httpd.sh")
}

resource "aws_instance" "webapp_2" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  key_name = "vockey"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.sg_front.id]
  subnet_id = aws_subnet.private2.id
  tags = {
    Name = "webapp2_${var.environment}"
    Environment = var.environment
  }
    user_data = file("${path.module}/inst_httpd.sh")
}

resource "aws_instance" "bastion" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  key_name = "vockey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  subnet_id = aws_subnet.public1.id

  tags = {
    Name = "bastion_${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb" "alb" {
  name               = "alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.public1.id,aws_subnet.public2.id]

  enable_deletion_protection = false

  tags = {
    Name = "alb_${var.environment}"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 20
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "web1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.webapp_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.webapp_2.id
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}