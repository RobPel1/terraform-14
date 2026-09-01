resource "aws_instance" "web" {
  ami                                  = "ami-0332d564d76dbd8d6"
  associate_public_ip_address          = true
  availability_zone                    = "us-east-1a"
  instance_type                        = "t3.micro"
  key_name                             = "ec2key"
  security_groups                      = ["launch-wizard-1"]
  subnet_id                            = "subnet-02db58574d1b80caf"
  tags = {
    Name = "dev-app-server"
  }
  tags_all = {
    Name = "dev-app-server"
  }
}
