
resource "aws_iam_user" "name" {
  name = "testuser"

}


resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.name.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_vpc" "myvpc" {

  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "mysubnet" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "mysubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myIGW"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_key_pair" "testkey" {
  key_name   = "test-key"
  public_key = var.pub_key
}

resource "aws_security_group" "sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from any IP address
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from any IP address
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows SSH from any IP address
  }


  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "sg_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = aws_vpc.myvpc.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Name = "myingresstraffic"
  }
}



resource "aws_vpc_security_group_egress_rule" "sg_egress" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Name = "myegresstraffic"
  }
}



resource "aws_instance" "instance1" {
  ami                         = "ami-084568db4383264d4"
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  key_name                    = "test-key"
  security_groups             = [aws_security_group.sg.id]
  subnet_id                   = aws_subnet.mysubnet.id
  count                       = "1"
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update 
              curl -fsSL https://get.docker.com -o install-docker.sh
              cat install-docker.sh
              sh install-docker.sh --dry-run
              sudo sh install-docker.sh
              sleep 25
              sudo docker --version
              sudo systemctl start docker
              sudo systemctl enable docker
              sleep 50
              sudo docker run --name java -it -d openjdk
              sleep 35
              sudo docker run --name jenkins -p 8080:8080 jenkins/jenkins
              sleep 35
              EOF

  tags = {
    Name = "MyEC2Instance"
  }

}



