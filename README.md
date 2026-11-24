# ☁️ Terraform module for Spacelift on AWS

This module creates the base infrastructure for a self-hosted Spacelift installation on AWS. It covers both products, [Spacelift Deploy](https://docs.spacelift.io/) and [Spacelift Flows](https://docs.spacelift.io/flows/introduction).

> [!IMPORTANT]
> **Breaking change in v3.0.0 - scheduler security group removed:** the standalone
> scheduler service is gone (the cron scheduler runs inside the drain, always from
> Self-Hosted v6.4.0), so the module no longer creates the scheduler security
> group.

## ✨ Usage

```hcl
module "spacelift" {
  source  = "spacelift-io/spacelift-selfhosted/aws"
  version = "~> 3.5"

  region             = "eu-west-1"
  website_endpoint   = "https://spacelift.mycorp.com"
  rds_engine_version = "18.6"
}
```

This module creates the KMS keys, the network (a VPC with subnets and security groups), an Aurora PostgreSQL cluster and the S3 buckets that Deploy runs on. It can also create ECR repositories, if you'd rather mirror the images than pull them from our registry (`oci.spacelift.io`).

Set `enable_flows` to `true` to also create what Flows needs: its S3 bucket with a KMS key of its own, and ECR repositories for its images. Flows shares the Aurora cluster with Deploy.

Most of it is optional: bring your own KMS key, VPC or database by setting the matching inputs, and the module skips that part.

For guidance on upgrading your Aurora PostgreSQL database, see the [RDS Upgrade Guide](docs/rds-upgrade-guide.md).

### Examples

There are ready-made examples for other setups, such as [bringing your own VPC](examples/custom-vpc), [skipping the ECR repositories](examples/without-ecr), [joining an Aurora Global Database](examples/global-database) and [passwordless database authentication](examples/rds-iam-auth). The full list is in [`examples/README.md`](examples/README.md).

## State storage

Check out the [Terraform](https://developer.hashicorp.com/terraform/language/backend) or the [OpenTofu](https://opentofu.org/docs/language/settings/backends/configuration/) backend documentation for more information on how to configure the state storage.

> ⚠️ Do **not** import the state into Spacelift after the installation: that would cause circular dependencies, and in case you accidentally break the Spacelift installation, you wouldn't be able to fix it.

## 🚀 Release

We have a [GitHub workflow](./.github/workflows/release.yaml) to automatically create a tag and a release based on the version number in [`.spacelift/config.yml`](./.spacelift/config.yml) file.

When you're ready to release a new version, just simply bump the version number in the config file and open a pull request. Once the pull request is merged, the workflow will create a new release.
