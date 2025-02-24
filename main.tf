# Documentation: https://www.terraform.io/docs/language/expressions/dynamic-blocks.html

# Abstract example:
# resource "terraform_resource" "example" {
#   dynamic "block" {
#     for_each = var.list

#     content {
#       resource_value = block.value["object_key"]
#     }
#   }
# }

locals {
  ingress_additional = [{
    description = "Allow SSH"
    from        = 22
    to          = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }, {
    description = "Allow OpenVPN"
    from        = 1194
    to          = 1194
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }]

  ingress_merged = concat(var.ingress_rules, local.ingress_additional)
}

resource "aws_security_group" "example" {
  name = "${var.name}-sg"

  dynamic "ingress" {
    for_each = local.ingress_merged

    content {
      description = ingress.value["description"]
      from_port   = ingress.value["from"]
      to_port     = ingress.value["to"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }
}

# Result:
# resource "aws_security_group" "example" {
#   name = "example-sg"

#   ingress {
#     description = "Allow SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "Allow HTTPS"
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
