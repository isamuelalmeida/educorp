#resource "aws_cloudfront_distribution" "s3_distribution" {
#  origin {
#    domain_name = aws_s3_bucket.educorp_s3_bucket.bucket_regional_domain_name
#    origin_id   = aws_s3_bucket.educorp_s3_bucket.bucket_regional_domain_name
#  }
#
#  enabled         = true
#  is_ipv6_enabled = true
#  comment         = "educorp-${terraform.workspace}"
#
#  default_cache_behavior {
#    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
#    allowed_methods          = ["GET", "HEAD"]
#    cached_methods           = ["GET", "HEAD"]
#    target_origin_id         = aws_s3_bucket.educorp_s3_bucket.bucket_regional_domain_name
#    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
#    compress                 = true
#
#    forwarded_values {
#      query_string = false
#
#      cookies {
#        forward = "none"
#      }
#    }
#
#    viewer_protocol_policy = "redirect-to-https"
#    min_ttl                = 0
#    default_ttl            = 3600
#    max_ttl                = 86400
#  }
#
#  price_class = "PriceClass_All"
#
#  restrictions {
#    geo_restriction {
#      restriction_type = "none"
#    }
#  }
#
#  viewer_certificate {
#    cloudfront_default_certificate = true
#  }
#}