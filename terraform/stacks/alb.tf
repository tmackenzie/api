resource "aws_alb" "alb" {
  name            = "alb"
  load_balancer_type = "application"

  subnets         = [for subnet_id in data.terraform_remote_state.platform.outputs.public_subnets : subnet_id]

  # Referencing the security group
  security_groups = ["${aws_security_group.alb_sg.id}"]
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "API load balancer security group"

  # different than tutorial
  # tutorial does not have vpc_id
  vpc_id      = "${data.terraform_remote_state.platform.outputs.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${data.terraform_remote_state.platform.outputs.vpc_id}" # Referencing the default VPC
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.alb.arn}" # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our tagrte group
  }
}
