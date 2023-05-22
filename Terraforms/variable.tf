 variable "aws_region" { 
 default = "us-east-1" 
 } 

 variable "ecs_task_execution_role" {
    default = "myECSTaskExecutionRole"
    description = "ECS task execution role name"
 }


 
 