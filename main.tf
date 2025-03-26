
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
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"

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

#resource "aws_instance" "instance1" {
#  ami           = "ami-084568db4383264d4" # Replace with your desired AMI ID
# instance_type = "t2.micro"              # Change the instance type if needed

#key_name = "your-key-pair" # Replace with the name of your key pair in AWS

# security_groups = ["your-security-group"] # Replace with your security group name

# tags = {
#  Name = "MyEC2Instance"
# }

# Optionally, add other configurations like EBS volume, user data, etc.
#}

