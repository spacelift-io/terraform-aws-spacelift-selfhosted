# Join the database to an Aurora Global Database

For cross-region HA, set `rds_global_cluster_identifier` to have the Spacelift database created as the primary cluster of an existing [Aurora Global Database](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database.html). `rds_replication_source_identifier` does the same for a plain cross-region read replica.

You can manage the secondary clusters yourself, or create them with a second instance of this module by setting `rds_is_global_secondary`. A secondary inherits the database and the master credentials from the primary, so point it at the primary's database secret. The module reads the credentials from there (in the primary's region) to build the secondary's own connection strings.

If the primary lives in a different state, pass the secret's ARN as a plain string. The secondary's writer endpoint only accepts writes after you promote it.

> [!IMPORTANT]
> `rds_global_cluster_identifier` and `rds_replication_source_identifier` are only applied when the cluster is first created. The module ignores later changes to them, because attaching or detaching a running cluster is something you do through the global cluster resource (or the AWS console), not by editing the cluster in place. To bring an existing Spacelift database into a global cluster, point `aws_rds_global_cluster.source_db_cluster_identifier` at the `rds_cluster_arn` output instead.

The configuration is in [`main.tf`](./main.tf). It uses the local module source (`../../`), so swap in the registry source (`spacelift-io/spacelift-selfhosted/aws`) in your own code.
