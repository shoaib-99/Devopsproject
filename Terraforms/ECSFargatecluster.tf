resource "aws_ecs_cluster" "Devops_cluster" {
  name      = "myapp-cluster"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "4096"
  memory                   = "30720"
  

  container_definitions = <<EOF
[
  {
    "name": "nginx",
    "image": "014960577773.dkr.ecr.us-east-1.amazonaws.com/aws-ecs-devops-project:latest",
    "portMappings": [
      {
        "hostPort": 80,
        "containerPort": 80,
        "protocol": "tcp"
      }
    ],
    "cpu": 1024,
    "memory": 2048
  },
   {
    "name": "client",
    "image": "014960577773.dkr.ecr.us-east-1.amazonaws.com/aws-ecs-devops-project:latest",
    "portMappings": [
      {
        "hostPort": 3000,
        "containerPort": 3000,
        "protocol": "tcp"
      }
    ],
    "cpu": 1024,
    "memory": 2048
  },
  {
    "name": "server",
    "image": "014960577773.dkr.ecr.us-east-1.amazonaws.com/aws-ecs-devops-project:latest",
    "portMappings": [
      {
        "hostPort": 8080,
        "containerPort": 8080,
        "protocol": "tcp"
      }
    ],
    "cpu": 1024,
    "memory": 2048
  }
]
EOF

}

resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.Devops_cluster.arn
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 4
  launch_type     = "FARGATE"

   network_configuration {
    subnets         = [aws_subnet.Public_Subnet_1.id, aws_subnet.Public_Subnet_2.id] 
    security_groups = [aws_security_group.load_balancer_sg.id]
    assign_public_ip = true
  }
 
  load_balancer {
    target_group_arn = aws_alb_target_group.target-group.arn
    container_name   = "nginx"
    container_port   = 80
  }
  }




 

/*
# Configure scaling policies
resource "aws_appautoscaling_target" "my_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.Devops_cluster.id}/${aws_ecs_service.my_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "my_policy" {
  name               = "my-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.my_target.resource_id
  scalable_dimension = aws_appautoscaling_target.my_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.my_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 50
  }
}*/


