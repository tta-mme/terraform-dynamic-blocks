# Terraform Dynamic Blocks

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

## Weitere Ressourcen
- **Github-Repo mit Hands-on Code:** [terraform-dynamic-blocks](https://github.com/tta-mme/terraform-dynamic-blocks)
- **Offizielle Terraform Dokumentation:** [Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)