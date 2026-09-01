output "vpc-id" {
    value = aws_vpc.vpc1.id
}
output "sub1-public-id" {
    value = aws_subnet.sub1.id 
}
output "NAT-id" {
    value = aws_nat_gateway.nat1.id
}
output "vps-ARN" {
    value = aws_vpc.vpc1.arn
}