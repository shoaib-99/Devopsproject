resource "aws_security_group" "DevopsProject_SG"{
    name        = "DevopsProject_SG"
    description = "Allow incoming HTTP Connections"
    vpc_id      = aws_vpc.myvpc.id 


    ingress {
        from_port    = 80
        to_port      = 80
        protocol     = "tcp"
        cidr_blocks   = ["0.0.0.0/0"]
    }

    egress {
        from_port    = 0
        to_port      = 0
        protocol     = "-1"
        cidr_blocks   = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "ecs_service_sg" {
  name        = "ecs-service-sg"
  description = "Security group for ECS service"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.load_balancer_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "load_balancer_sg" {
  name        = "load-balancer-sg"
  description = "Security group for Load Balancer"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_security_group" "application_sg" {
  name        = "application-security-group"
  description = "Security group for the application"

  
  ingress {
    from_port   = 80 
    to_port     = 80
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
}

output "security_group_id" {
  value = aws_security_group.application_sg.id
}