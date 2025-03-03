# ☁️ Terraform module for Spacelift on AWS

This module creates a base infrastructure for a self-hosted Spacelift instance on AWS.

## State storage

Check out the [Terraform](https://developer.hashicorp.com/terraform/language/backend) or the [OpenTofu](https://opentofu.org/docs/language/settings/backends/configuration/) backend documentation for more information on how to configure the state storage.

> ⚠️ Do **not** import the state into Spacelift after the installation: that would cause circular dependencies, and in case you accidentally break the Spacelift installation, you wouldn't be able to fix it.

## ✨ Usage

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v0.0.5"

  region         = "europe-west1"
  # TBA
  labels         = {"app" = "spacelift"}
}
```

The module creates:

- IAM resources
  - TBA
- Network resources
  - TBA
- Container repository (ECR)
  - a Google Artifact Registry repository for storing Docker images
  - a PUBLIC Google Artifact Registry repository for storing Docker images for workers (if external workers are enabled)
  - TBA
- Database resources
  - an RDS instance
- Storage resources
  - various buckets for storing run metadata, run logs, workspaces, stack states etc.
- Container orchestrator platform  
  - As of today, only ECS is supported

### Inputs

| Name   | Description                                        | Type   | Default | Required |
| ------ | -------------------------------------------------- | ------ | ------- | -------- |
| region | The region in which the resources will be created. | string | -       | yes      |


### Outputs

| Name   | Description                                     |
| ------ | ----------------------------------------------- |
| region | The region in which the resources were created. |

### Examples

#### Default

This deploys a new VPC, a new Cloud SQL instance and a GKE cluster

```hcl
module "spacelift" {
  source  = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v0.0.5"

  region         = var.region
  # TBA
}
```

### Deploy a cluster in an existing network

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v0.0.5"

  # TBA
}
```

#### Do not create a VPC and GKE cluster

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v0.0.5"

  # TBA
}
```

#### Do not create DB, VPC and GKE cluster

```hcl
module "spacelift" {
  source = "github.com/spacelift-io/terraform-aws-spacelift-selfhosted?ref=v0.0.5"

  # TBA
}
```

## 🚀 Release

We have a [GitHub workflow](./.github/workflows/release.yaml) to automatically create a tag and a release based on the version number in [`.spacelift/config.yml`](./.spacelift/config.yml) file.

When you're ready to release a new version, just simply bump the version number in the config file and open a pull request. Once the pull request is merged, the workflow will create a new release.