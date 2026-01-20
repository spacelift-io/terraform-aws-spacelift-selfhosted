# RDS Upgrade Guide

This guide covers upgrading Aurora PostgreSQL for your Spacelift self-hosted deployment.

## Minor Version Upgrades

Minor version upgrades (e.g., 16.1 → 16.4) are backward-compatible patches that include bug fixes and security updates.

### Zero-Downtime Patching (ZDP)

Aurora PostgreSQL supports [Zero-Downtime Patching](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/USER_UpgradeDBInstance.PostgreSQL.MinorUpgrade.html#USER_UpgradeDBInstance.PostgreSQL.Minor.zdp) for provisioned instances on versions 12.11+, 13.7+, 14.3+, 15.3+, and 16.1+. Serverless v2 supports ZDP starting from 13.8+, 14.5+, 15.3+, and 16.1+.

When ZDP is available, Aurora applies the patch while preserving client connections, resulting in only seconds to approximately one minute of downtime during the engine restart.

ZDP may drop connections if any of the following are in progress:
- Long-running queries or transactions
- DDL statements
- Temporary tables or table locks
- Cursors with `WITH HOLD` status

### Performing a Minor Upgrade

Update the `rds_engine_version` variable to your target version:

```diff
- rds_engine_version = "16.1"
+ rds_engine_version = "16.4"
```

Then apply the Terraform changes. Minor upgrades can be applied frequently with minimal service impact.

## Major Version Upgrades

Major version upgrades (e.g., 15 → 16) require more planning as they involve schema and compatibility changes.

### Pre-upgrade Checklist

1. **Verify `rds_apply_immediately` is set to `true`** (this is the default). This ensures changes apply immediately rather than during the next maintenance window, avoiding unexpected upgrades at inconvenient times.

2. **Validate your target version**. Aurora only supports upgrades to specific versions. You can check valid upgrade targets using Terraform or the AWS CLI.

   Using Terraform:
   ```hcl
   data "aws_rds_engine_version" "current" {
     engine  = "aurora-postgresql"
     version = "15.4"  # your current version; also available as an output from this module 'rds_engine_version_actual'
   }

   output "valid_major_targets" {
     value = data.aws_rds_engine_version.current.valid_major_targets
   }

   output "valid_minor_targets" {
     value = data.aws_rds_engine_version.current.valid_minor_targets
   }
   ```

   Or using the AWS CLI:
   ```bash
   aws rds describe-db-engine-versions \
     --engine aurora-postgresql \
     --engine-version 15.4 \
     --query 'DBEngineVersions[0].ValidUpgradeTarget[*].EngineVersion'
   ```

3. **Upgrade one major version at a time**. Don't skip versions (e.g., upgrade 15 → 16, not 15 → 17).

### Performing the Upgrade

Update the `rds_engine_version` variable to your target version:

```diff
- rds_engine_version = "15.4"
+ rds_engine_version = "16.4"
```

Apply the Terraform changes.

### What to Expect

- **Automatic snapshot**: AWS automatically creates a snapshot before the upgrade begins.
- **Downtime**: Expect 12-30 minutes of downtime depending on your RDS instance size and data volume.
- **Application recovery**: Spacelift services will automatically recover once the database is available. No manual intervention is required.
- **VCS webhook impact**: The webhook endpoint will be unavailable during the upgrade. Schedule upgrades during periods of low VCS activity to minimize missed webhook events. Any missed events can be recovered by re-pushing commits or manually triggering runs.

## Further Reading

For detailed information on PostgreSQL upgrade behavior, compatibility considerations, and troubleshooting, see the [AWS documentation on upgrading PostgreSQL](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_UpgradeDBInstance.PostgreSQL.html).
