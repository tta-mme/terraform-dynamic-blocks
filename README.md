# Terraform Dynamic Blocks

```hcl
resource "terraform_resource" "example" {
  dynamic "block" {
    for_each = var.list

    content {
      resource_value = block.value["object_key"]
    }
  }
}
```

## Warum benutzt man Dynamic Blocks in Terraform?
Dynamic Blocks in Terraform sind nützlich, wenn sich innerhalb einer Ressource wiederholende Konfigurationen befinden, deren Anzahl oder Werte variabel sein können. Sie helfen dabei, Redundanz zu vermeiden und Code flexibler zu gestalten.

## Welche Vorteile haben Dynamic Blocks?
- **Reduzierung von Code-Duplikation** – Keine mehrfachen, identischen Blöcke nötig.
- **Erhöhte Skalierbarkeit** – Anpassung der Konfiguration basierend auf Variablen oder Eingaben.
- **Dynamische Generierung** – Automatische Erstellung von Blöcken auf Basis einer Liste oder Map.
- **Verbesserte Wartbarkeit** – Weniger manuelle Änderungen erforderlich, wenn sich Anforderungen ändern.

## Beispiel: Dynamische Security Group
Ein Dynamic Block in Terraform wird innerhalb einer Ressource definiert, wenn mehrere ähnliche Unterblöcke benötigt werden, deren Anzahl und Inhalte variabel sind.

### Code-Beispiel:
```hcl
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

resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"
  
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
```

### Erklärung:
- `dynamic "ingress" {}` definiert den dynamischen Block innerhalb der Ressource.
- `for_each` iteriert über eine Liste oder Map von Objekten, hier `var.ingress_rules`.
- `content {}` definiert die eigentlichen Attribute für jede Regel basierend auf `ingress.value`.

### Ergebnis:
```hcl
resource "aws_security_group" "example" {
  name = "example-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

## Weitere Ressourcen
- **Offizielle Terraform Dokumentation:** [Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)