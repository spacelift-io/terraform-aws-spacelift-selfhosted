# Deploy with custom S3 bucket retention

You can customize S3 bucket names and retention policies using the `s3_bucket_configuration` variable. This allows you to specify only the buckets you want to customize while others will use default settings.

`s3_noncurrent_version_expiration_days` applies to the `policy`, `run_logs`, `run_observability`, `uploads`, `user_uploads` and `workspace` buckets, which are the buckets that have both versioning and object expiration enabled. The remaining buckets either keep their versions deliberately (`binaries`, `modules`, `states`) or are not versioned (`deliveries`, `large_queue`, `metadata`).

The configuration is in [`main.tf`](./main.tf). Our tests apply it, so it uses the local module source and turns off deletion protection and bucket retention. Don't copy those flags into a real installation.
