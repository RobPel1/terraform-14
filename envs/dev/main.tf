#VPC
module "vpc" {
  source         = "../../modules/vpc"
  vpc_cidr_block = "192.168.0.0/16"
  vpc_name       = "Dev-vpc"
}


#Front end
module "frontend" {
  source                 = "../../modules/frontendaws"
  bucket_name            = "frontend.attechrob.com"
  aws_origin_access_name = "Cross access from cloudfront"
  cert_domain            = "*.attechrob.com"
  dns_record             = "frontend.attechrob.com"
  hosted_zone_name = "attechrob.com"
}