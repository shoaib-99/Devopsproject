
# target group
resource "aws_alb_target_group" "target-group"{
    health_check {
      interval            = 10
      path                = "/"
      protocol            = "HTTP"
      timeout             = 5
      healthy_threshold   = 5
      unhealthy_threshold = 2

    }

    name             = "ins-tg"
    port             = 8080
    protocol         = "HTTP"
    target_type      = "ip"
    vpc_id           = aws_vpc.myvpc.id 
}

resource "aws_instance" "DevopsProject"{
    ami                    = "ami-0aa2b7722dc1b5612"
    instance_type          = "t2.micro"
    count                  = 2
    key_name               = "devops-kp"
    subnet_id = aws_subnet.Public_Subnet_1.id
    associate_public_ip_address = true
    vpc_security_group_ids = ["${aws_security_group.DevopsProject_SG.id}"]

       tags = {
            Name = "instance"
        }

 }

#creating ALB
resource "aws_alb" "load_balancer"{
    name               = "ins-alb"
    internal           = "false"
    ip_address_type    = "ipv4"
    load_balancer_type = "application"
    security_groups    = [aws_security_group.load_balancer_sg.id]  
    subnets            = [aws_subnet.Public_Subnet_1.id, aws_subnet.Public_Subnet_2.id] 

}


#Creating listener 
resource "aws_lb_listener" "alb_listener"{
    load_balancer_arn        = aws_alb.load_balancer.arn 
    port                     = 80
    protocol                 = "HTTP"
    default_action {
        target_group_arn     = aws_alb_target_group.target-group.arn
        type                 = "forward"
        
    }
}

