########### ECS Cluster ################
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

########## ecs task my_defination ##########
# Task defination to deploy three containers
# connect those container, and define the parameters
# for those containers 
#############################################

resource "aws_ecs_task_definition" "my_first_task" {
  family = "my-first-task"
  container_definitions = <<DEFINITION
  [{
        "name": "db",
        "image": "postgres:9.6-alpine",
        "cpu": 5,
        "memory": 50,
        "essential": true,
        "portMappings": [{
            "containerPort": 5432,
            "protocol": "TCP"
        }],
        
        "environment": [{
                "name": "POSTGRES_USER",
                "value": "${var.postgres_user}"
            },
            {
                "name": "POSTGRES_PASSWORD",
                "value": "${var.postgres_password}"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/db-container",
                "awslogs-region": "ap-southeast-2",
                "awslogs-stream-prefix": "firelens"
            }
        }
    },

    {
        "name": "myapp",
        "image": "servian/techchallengeapp:latest",
        "cpu": 10,
        "memory": 256,
        "essential": true,
        "portMappings": [{
            "containerPort": 80,
            "Protocol": "TCP"
        }],
        "command": [
            "serve"
        ],
        "environment": [{
                "name": "VTT_DBUSER",
                "value": "${var.postgres_user}"
            },
            {
                "name": "VTT_DBPASSWORD",
                "value": "${var.postgres_password}"
            },
            {
                "name": "VTT_DBNAME",
                "value": "app"
            },
            {
                "name": "VTT_DBPORT",
                "value": "5432"
            },
            {
                "name": "VTT_DBHOST",
                "value": "0.0.0.0"
            },
            {
                "name": "VTT_LISTENHOST",
                "value": "0.0.0.0"
            },
            {
                "name": "VTT_LISTENPORT",
                "value": "80"
            }
        ],
        
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/frontend-container",
                "awslogs-region": "ap-southeast-2",
                "awslogs-stream-prefix": "firelens"

            }
        }
    },
    {
        "name": "webdb",
        "image": "servian/techchallengeapp:latest",
        "cpu": 5,
        "memory": 50,
        "essential": false,
        "command": [
            "updatedb"
        ],
        "environment": [{
                "name": "VTT_DBUSER",
                "value": "${var.postgres_user}"
            },
            {
                "name": "VTT_DBPASSWORD",
                "value": "${var.postgres_password}"
            },
            {
                "name": "VTT_DBNAME",
                "value": "app"
            },
            {
                "name": "VTT_DBPORT",
                "value": "5432"
            },
            {
                "name": "VTT_DBHOST",
                "value": "0.0.0.0"
            },
            {
                "name": "VTT_LISTENHOST",
                "value": "0.0.0.0"
            },
            {
                "name": "VTT_LISTENPORT",
                "value": "80"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/webdb-container",
                "awslogs-region": "ap-southeast-2",
                "awslogs-stream-prefix": "firelens"
            }
        }
    }
    
  ]
  DEFINITION 

  requires_compatibilities = ["FARGATE"] # defining where to peovision the above containers [FARGATE] in this case
  network_mode = "awsvpc"
  memory = 512
  cpu = 256
  execution_role_arn = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

# for revision of the task
data "aws_ecs_task_definition" "my_first_task"  {
  task_definition = aws_ecs_task_definition.my_first_task.family
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
    name = "ecsTaskExecutionRole"
    assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]

    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
    role = "${aws_iam_role.ecsTaskExecutionRole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

############## ECS Service ###################
# ECS service defination declaraion
##############################################
resource "aws_ecs_service" "my_first_service" {
  name = "my-first-service"
  cluster = "${aws_ecs_cluster.my_cluster.id}"
  task_definition = "${aws_ecs_task_definition.my_first_task.family}:${data.aws_ecs_task_definition.my_first_task.revision}"
  launch_type = "FARGATE" # replace FARGATE with EC2
  desired_count = 3

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}"
    container_name   = "myapp" #"${aws_ecs_task_definition.my_first_task.family}"
    container_port   = "80" 
  }

  network_configuration {
    subnets = ["${aws_default_subnet.default_subnet_a.id}", "${aws_default_subnet.default_subnet_b.id}", "${aws_default_subnet.default_subnet_c.id}"]
    assign_public_ip = true
    security_groups  = ["${aws_security_group.service_security_group.id}"]
  }
}

resource "aws_security_group" "service_security_group" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol 
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

########## Cloud Watch Logs #########################
# Cloud Watch logs for each container defined above
##################################################### 

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
}

resource "aws_cloudwatch_log_group" "webdb_log_group" {
  name = "/ecs/webdb-container"
}

resource "aws_cloudwatch_log_group" "db_log_group" {
  name = "/ecs/db-container"
}