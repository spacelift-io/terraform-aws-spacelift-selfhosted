# Examples

Ways to configure the [Spacelift self-hosted AWS module](../README.md) beyond the default setup. Each folder has a README that explains the setup, and a `main.tf` you can run.

| Example                                            | What it shows                                                                                                                |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| [custom-vpc](./custom-vpc)                         | Bring your own VPC, subnets and security groups.                                                                             |
| [without-ecr](./without-ecr)                       | Skip the ECR repositories when you pull the images from `oci.spacelift.io`, and how to switch an existing installation over. |
| [multiple-rds-instances](./multiple-rds-instances) | Run more than one instance in the Aurora cluster.                                                                            |
| [custom-s3-retention](./custom-s3-retention)       | Change bucket names and how long objects are kept.                                                                           |
| [global-database](./global-database)               | Cross-region HA with a primary and a secondary Aurora cluster.                                                               |
| [rds-data-api](./rds-data-api)                     | Query the database from the RDS console.                                                                                     |
| [rds-iam-auth](./rds-iam-auth)                     | Connect to the database with IAM authentication instead of a password.                                                       |
| [sqs-enabled](./sqs-enabled)                       | Create the SQS queues for Spacelift.                                                                                         |

The `main.tf` files use the local module source (`../../`). In your own code, use the registry source (`spacelift-io/spacelift-selfhosted/aws`).

Our tests apply `custom-vpc`, `custom-s3-retention` and `sqs-enabled`, so those three also turn off deletion protection and bucket retention to be able to clean up after themselves. Leave those flags out of a real installation.
