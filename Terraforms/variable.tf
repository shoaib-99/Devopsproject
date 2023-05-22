 variable "aws_region" { 
 default = "us-east-1" 
 } 

 variable "ecs_task_execution_role" {
    default = "myECSTaskExecutionRole"
    description = "ECS task execution role name"
 }

variable "app_image" {
   default   = "80"
   description  = "portexposed on the docker image"
}

variable fargate_cpu {
   default = "1024"
   description = "fargate instance CPU units to provision "
}
 
 