################ Auto Scaling Group ##################
# Target tracking scaling is used in this deployment
# cloud watch alarms to will be generated, during scale
# up and scale down. Scaling will be performed on CPU and
# memory
#######################################################


resource "aws_appautoscaling_target" "my_first_asg" {
  max_capacity = 5
  min_capacity = 1
  resource_id = "service/my-cluster/my-first-service"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace = "ecs"
  
}

resource "aws_appautoscaling_policy" "memory" {
  name               = "memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.my_first_asg.resource_id
  scalable_dimension = aws_appautoscaling_target.my_first_asg.scalable_dimension
  service_namespace  = aws_appautoscaling_target.my_first_asg.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = 80
  }
}

resource "aws_appautoscaling_policy" "cpu" {
  name = "cpu"
  policy_type = "TargetTrackingScaling"
  resource_id = aws_appautoscaling_target.my_first_asg.resource_id
  scalable_dimension = aws_appautoscaling_target.my_first_asg.scalable_dimension
  service_namespace = aws_appautoscaling_target.my_first_asg.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}