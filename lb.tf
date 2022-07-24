############### LOAD BALANCER ################### 
# Load Balancer to effectively manage traffic 
# Script to create a load balancer, associated security 
# groups, target gtroups, listener and output file 
# to print DNS name 
##################################################

resource "aws_alb" "application_load_balancer" {
  name = "test-lb-tf"
  load_balancer_type = "application"
  subnets = [
    "${aws_default_subnet.default_subnet_a.id}",
    "${aws_default_subnet.default_subnet_b.id}",
    "${aws_default_subnet.default_subnet_c.id}"
  ]
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]

}

resource "aws_security_group" "load_balancer_security_group" {
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 }

resource "aws_lb_target_group" "target_group" {
  name = "target-group"
  port = "80"
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = "${aws_default_vpc.default_vpc.id}"
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = "${aws_alb.application_load_balancer.arn}"
    port = "80"
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = "${aws_lb_target_group.target_group.arn}"
    }
  
}

output "alb_dns"{
  description = "URL of the load balancer"
  value =  aws_alb.application_load_balancer.dns_name
}