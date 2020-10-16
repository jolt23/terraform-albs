output "lb_arn" {
  description = "The ID and ARN of the load balancer we created."
  value       = module.alb.this_lb_arn
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.this_lb_dns_name
}

output "s3_bucket_dns" {
  value = {
    for bucket in module.s3_bucket:
    bucket.this_s3_bucket_id => bucket.this_s3_bucket_bucket_domain_name
  }
  description = "S3 Bucket DNS"
}