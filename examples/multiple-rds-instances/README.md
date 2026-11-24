# Deploy multiple RDS instances

Set `rds_instance_configuration` to run more than one instance in the Aurora cluster. Each entry creates an instance with its own identifier and instance class.

The configuration is in [`main.tf`](./main.tf). It uses the local module source (`../../`), so swap in the registry source (`spacelift-io/spacelift-selfhosted/aws`) in your own code.
