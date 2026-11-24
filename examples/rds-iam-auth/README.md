# Passwordless database authentication

The cluster has IAM database authentication enabled by default. Set `rds_iam_username` to the database user the services will connect as, and the module builds passwordless connection strings for it.

> [!IMPORTANT]
> This user is **not** created for you, and it is **not** the master user. It's a separate Postgres user that you have to create explicitly, connected as the master user:
>
> ```sql
> CREATE USER spacelift_iam;
> GRANT rds_iam TO spacelift_iam;
> GRANT spacelift TO spacelift_iam;
> ALTER ROLE spacelift_iam SET role = 'spacelift';
> ```
>
> The `spacelift` grant makes it a member of the `spacelift` role that owns the database, so it can alter the schema and not just read and write rows. The `ALTER ROLE` line makes it act as `spacelift` on every connection, so tables created by later upgrades are owned by `spacelift`, same as with password authentication. If you changed `rds_username`, use that name instead of `spacelift`. Don't grant `rds_iam` to the master user itself - it loses password authentication, and with it your break-glass access.

The strings land in the database secret as `DATABASE_IAM_URL` and `DATABASE_IAM_READ_ONLY_URL`, next to the password-carrying pair, and in the `database_iam_url` and `database_iam_read_only_url` outputs. Handing them to the services, along with the IAM permission to mint tokens, is the job of whichever module deploys them - see [ECS](https://github.com/spacelift-io/terraform-aws-ecs-spacelift-selfhosted#rds-passwordless-authentication-iam-auth) or [EKS](https://github.com/spacelift-io/terraform-aws-eks-spacelift-selfhosted#rds-passwordless-authentication-iam-auth).

The configuration is in [`main.tf`](./main.tf). It uses the local module source (`../../`), so swap in the registry source (`spacelift-io/spacelift-selfhosted/aws`) in your own code.
