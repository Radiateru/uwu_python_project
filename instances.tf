resource "aws_instance" "webapp_1" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  key_name = "vockey"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.sg_front.id]
  subnet_id = aws_subnet.private1.id

  tags = {
    Name = "webapp_1"
  }
  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd  
              systemctl enable httpd
              systemctl start httpd

              echo "<h1>Hello from Terraform EC2</h1>" > /var/www/html/index.html
              EOF
}

resource "aws_instance" "webapp_2" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  key_name = "vockey"
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.sg_front.id]
  subnet_id = aws_subnet.private2.id
  tags = {
    Name = "webapp_2"
  }
    user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd

              systemctl enable httpd
              systemctl start httpd

              echo "<h1>Hello from Terraform EC2</h1>" > /var/www/html/index.html
              EOF
}

resource "aws_instance" "bastion" {
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t3.micro"
  key_name = "vockey"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg_bastion.id]
  subnet_id = aws_subnet.public1.id

  tags = {
    Name = "bastion_recharge"
  }
}

resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_alb.id]
  subnets            = [aws_subnet.public1.id,aws_subnet.public2.id]

  enable_deletion_protection = false

  tags = {
    Environment = "alb-recharge"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
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