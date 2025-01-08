/*--------------------------------------------
# Security group del ALB
resource "aws_security_group" "pci_alb_sg" {
  name_prefix = "pci-alb-sg"
  vpc_id      = aws_vpc.pci_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pci-alb-security-group"
  }
}

# Crear el ALB
resource "aws_lb" "pci_alb" {
  name               = "pci-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pci_alb_sg.id]
  subnets            = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  tags = {
    Environment = "PCI"
    Name        = "pci-alb"
  }
}

# Crear el Target Group para Lambda
resource "aws_lb_target_group" "pci_lambda_tg" {
  name        = "pci-lambda-tg"
  target_type = "lambda"
  vpc_id      = aws_vpc.pci_vpc.id

  tags = {
    Environment = "PCI"
  }
}

# Asociar la Lambda al Target Group
resource "aws_lb_target_group_attachment" "lambda_attachment" {
  target_group_arn = aws_lb_target_group.pci_lambda_tg.arn
  target_id        = aws_lambda_function.test_lambda.arn
}

# Crear el Listener con HTTPS
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.pci_alb.arn
  port              = "80"
  protocol          = "HTTP"//para evitar problemas con el certificado se ha añadido HTTP en lugar de https
  //para añadir certificado
  //ssl_policy        = "ELBSecurityPolicy-2016-08"
  //  certificate_arn   = "arn:aws:acm:region:account-id:certificate/certificate-id"  # Aquí se usa el certificado de ACM

  default_action {
    type             = "fixed-response"
    fixed_response {
      status_code = 200
      content_type = "text/plain"
      message_body = "This is a test message"
    }
  }
}