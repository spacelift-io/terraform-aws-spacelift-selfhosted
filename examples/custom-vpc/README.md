# Deploy with an existing VPC

Set `create_vpc` to `false` to deploy into a VPC you already have. If `create_vpc` is `false`, you must provide `rds_subnet_ids` and `rds_security_group_ids`.

The configuration is in [`main.tf`](./main.tf). Our tests apply it, so it uses the local module source and turns off deletion protection and bucket retention. Don't copy those flags into a real installation.
