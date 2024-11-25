output "load_balancer_dns" {
  value = aws_lb.application_lb.dns_name
}
