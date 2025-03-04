# ☁️ Terraform module for Spacelift on AWS

This module creates a base infrastructure for a self-hosted Spacelift instance on AWS.

## State storage

Check out the [Terraform](https://developer.hashicorp.com/terraform/language/backend) or the [OpenTofu](https://opentofu.org/docs/language/settings/backends/configuration/) backend documentation for more information on how to configure the state storage.

> ⚠️ Do **not** import the state into Spacelift after the installation: that would cause circular dependencies, and in case you accidentally break the Spacelift installation, you wouldn't be able to fix it.

## ✨ Usage

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v1.0.0"

  region       = "eu-west-1"
  default_tags = {"app" = "spacelift-selfhosted"}
}
```

This module creates:

- Encryption resources  
  - a KMS key that is used to encrypt other AWS resources (RDS, S3 buckets, ECR repositories)
  - a KMS key that is used for in-app encryption (eg. encrypt entities in the database)
- Network resources
  - A VPC, 3 subnets and 3 security groups
- Container repositories (ECR)
  - a repository for the backend image (used by `server` and `drain`)
  - another repository for the launcher image
- Database resources
  - a [global Aurora cluster](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html)
  - a regional Aurora cluster
  - an RDS instance
- Storage resources
  - 10 S3 buckets

It is highly configurable, so if you wish to use your own KMS key, VPC, RDS cluster etc., you can do so by providing the necessary parameters.

### Examples

#### Default

This deploys a KMS key, VPC (subnets, security groups), RDS cluster, ECR repositories and S3 buckets.

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v1.0.0"

  region       = "eu-west-1"
  default_tags = {"app" = "spacelift-selfhosted", "env" = "dev"}
}
```

### Deploy with an existing VPC

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v1.0.0"

  region       = "eu-west-1"
  default_tags = {"app" = "spacelift-selfhosted", "env" = "dev"}

  create_vpc             = false
  rds_subnet_ids         = ["subnet-012345abc", "subnet-012345def", "subnet-012345ghi"]
  rds_security_group_ids = ["sg-012345abc"]
}
```

If `create_vpc` is `false`, you must provide `rds_subnet_ids` and `rds_security_group_ids`.

### Deploy multiple RDS instances

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v1.0.0"

  region       = "eu-west-1"
  default_tags = {"app" = "spacelift-selfhosted", "env" = "dev"}

  rds_instance_configuration = {
    "primary-instance" = {
      instance_identifier = "primary"
      instance_class      = "db.r6g.large"
    }
    "secondary-instance" = {
      instance_identifier = "secondary"
      instance_class      = "db.r6g.large"
    }
  }
}
```

## 🚀 Release

We have a [GitHub workflow](./.github/workflows/release.yaml) to automatically create a tag and a release based on the version number in [`.spacelift/config.yml`](./.spacelift/config.yml) file.

When you're ready to release a new version, just simply bump the version number in the config file and open a pull request. Once the pull request is merged, the workflow will create a new release.