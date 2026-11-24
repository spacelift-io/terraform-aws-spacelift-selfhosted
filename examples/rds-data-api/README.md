# Enable the RDS Data API

Set `rds_enable_http_endpoint` to `true` to turn on the [Data API](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/data-api.html) for the cluster. This unlocks the query editor in the RDS console, so you can run SQL against the database straight from the browser. No bastion host, VPN, or local client needed, which is handy for quick inspections and debugging.

> [!NOTE]
> The Data API is only available for Aurora Serverless v2 and provisioned clusters in [supported regions](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/data-api.html#data-api.regions).

The configuration is in [`main.tf`](./main.tf). It uses the local module source (`../../`), so swap in the registry source (`spacelift-io/spacelift-selfhosted/aws`) in your own code.
