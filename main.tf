provider "aws" {
  region = "us-east-1"
}

############################
# 1. ECR Repository        #
############################
resource "aws_ecr_repository" "tp1" {
  name = "tp1"
}

############################
# 2. Réseau (VPC/Subnet)   #
############################
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5555
    to_port     = 5555
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
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

#################################
# 3. ECS Cluster (Fargate)      #
#################################
resource "aws_ecs_cluster" "main" {
  name = "fargate-cluster"
}

##########################################
# 4. ECS Task Definitions (4 images)     #
##########################################
locals {
  execution_role_arn = "arn:aws:iam::100438985235:role/LabRole"
}

resource "aws_cloudwatch_log_group" "frontend_logs" {
  name              = "/ecs/tp1-frontend"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "backend_logs" {
  name              = "/ecs/tp1-backend"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "websocket_logs" {
  name              = "/ecs/tp1-websocket"
  retention_in_days = 7
}
resource "aws_cloudwatch_log_group" "db_logs" {
  name              = "/ecs/tp1-db"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "frontend_task" {
  family                   = "tp1-frontend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = local.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${aws_ecr_repository.tp1.repository_url}:frontend"
      essential = true
      portMappings = [{ containerPort = 3000, hostPort = 3000 }]
      environment = [
        { name = "REACT_APP_API_URL", value = "http://${aws_lb.main.dns_name}:3001" },
        { name = "REACT_APP_WS_URL", value = "ws://${aws_lb.main.dns_name}:5555" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.frontend_logs.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "frontend"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "backend_task" {
  family                   = "tp1-backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = local.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${aws_ecr_repository.tp1.repository_url}:backend"
      essential = true
      portMappings = [{ containerPort = 3001, hostPort = 3001 }]
      environment = [
        { name = "DB_HOST", value = aws_lb.db_nlb.dns_name },
        { name = "DB_PORT", value = "5432" },
        { name = "DB_USER", value = "postgres" },
        { name = "DB_PASSWORD", value = "postgres" },
        { name = "DB_NAME", value = "mydb" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.backend_logs.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "backend"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "websocket_task" {
  family                   = "tp1-websocket"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = local.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "websocket"
      image     = "${aws_ecr_repository.tp1.repository_url}:websocket"
      essential = true
      portMappings = [{ containerPort = 5555, hostPort = 5555 }]
      environment = [
        { name = "DB_HOST", value = aws_lb.db_nlb.dns_name },
        { name = "DB_PORT", value = "5432" },
        { name = "DB_USER", value = "postgres" },
        { name = "DB_PASSWORD", value = "postgres" },
        { name = "DB_NAME", value = "mydb" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.websocket_logs.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "websocket"
        }
      }
    }
  ])
}

resource "aws_ecs_task_definition" "db_task" {
  family                   = "tp1-db"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = local.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "db"
      image     = "${aws_ecr_repository.tp1.repository_url}:db"
      essential = true
      portMappings = [{ containerPort = 5432, hostPort = 5432 }]
      environment = [
        { name = "POSTGRES_USER", value = "postgres" },
        { name = "POSTGRES_PASSWORD", value = "postgres" },
        { name = "POSTGRES_DB", value = "mydb" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.db_logs.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "db"
        }
      }
    }
  ])
}

#################################
# 5. Application Load Balancer  #
#################################
resource "aws_lb" "main" {
  name               = "tp1-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.main.id, aws_subnet.secondary.id]
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.main.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.main.arn
  port              = 3001
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_lb_listener" "websocket" {
  load_balancer_arn = aws_lb.main.arn
  port              = 5555
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.websocket.arn
  }
}

resource "aws_lb_target_group" "frontend" {
  name        = "tp1-frontend-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

resource "aws_lb_target_group" "backend" {
  name        = "tp1-backend-tg"
  port        = 3001
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/api/posts"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group" "websocket" {
  name        = "tp1-websocket-tg"
  port        = 5555
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

#################################
# 6. ECS Services (4 images)    #
#################################
resource "aws_ecs_service" "frontend_service" {
  name            = "tp1-frontend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.main.id, aws_subnet.secondary.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 3000
  }
}

resource "aws_ecs_service" "backend_service" {
  name            = "tp1-backend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.main.id, aws_subnet.secondary.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 3001
  }
}

resource "aws_ecs_service" "websocket_service" {
  name            = "tp1-websocket-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.websocket_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.main.id, aws_subnet.secondary.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.websocket.arn
    container_name   = "websocket"
    container_port   = 5555
  }
}

resource "aws_ecs_service" "db_service" {
  name            = "tp1-db-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.db_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_subnet.main.id, aws_subnet.secondary.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.db_tcp.arn
    container_name   = "db"
    container_port   = 5432
  }
}

# Création d'un Network Load Balancer interne pour la BDD
resource "aws_lb" "db_nlb" {
  name               = "tp1-db-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.main.id, aws_subnet.secondary.id]
}

resource "aws_lb_target_group" "db_tcp" {
  name        = "tp1-db-tg"
  port        = 5432
  protocol    = "TCP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

resource "aws_lb_listener" "db_listener" {
  load_balancer_arn = aws_lb.db_nlb.arn
  port              = 5432
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.db_tcp.arn
  }
}
