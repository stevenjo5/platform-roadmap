
### Stateful Firewalls & Custom Route Tables (Day 49)
- **Inline Routing Blocks**: Authored declarative egress paths (`0.0.0.0/0`) directly inside the `aws_route_table` schema mapping.
- **Subnet Binding**: Managed the edge attachment using explicit network association blocks (`aws_route_table_association`).
- **Stateful Traffic Rules**: Engineered an `aws_security_group` layout mapping precise ingress arrays for management tracking.
- **Tools**: `Terraform v1.9.8`, `Routing Layers`, `Stateful Firewalls`.
