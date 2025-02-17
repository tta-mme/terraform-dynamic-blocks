variable "name" {
  type    = string
  default = "tta-mme-tf-dynamic-blocks"
}

variable "ingress_rules" {
  type = list(object({
    description = string
    from        = number
    to          = number
    protocol    = string
    cidr_blocks = list(string)
  }))

  default = [
    { description = "Allow HTTP", from = 80, to = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { description = "Allow HTTPS", from = 443, to = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]

}


