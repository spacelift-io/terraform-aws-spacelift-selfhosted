# Deploy without ECR repositories

> [!NOTE]
> We recommend pulling the images from `oci.spacelift.io`. Starting with Self-Hosted v8.0.0, releases no longer include the image archives, so the images are only available from `oci.spacelift.io`. To keep them in your own registry, mirror them from there.

If you pull the backend and launcher images from another registry, such as `oci.spacelift.io`, you don't need the ECR repositories. Set `create_container_registry` to `false` to skip them.

With the flag off:

- the `ecr_*` outputs are null;
- the `shell` output has no `BACKEND_IMAGE`, `LAUNCHER_IMAGE` and `PRIVATE_ECR_LOGIN_URL` lines, and the `tfvars` output has no `backend_image` and `launcher_image` lines. Set the images where you deploy the services instead;
- `backend_ecr_repository_name`, `launcher_ecr_repository_name` and `number_of_images_to_retain` have no effect.

The default is `true`, so existing installations don't change.

## Switch an existing installation to another registry

On an existing installation, turning the flag off removes the ECR repositories from the module. Do it in this order:

1. Upgrade the module, leave the flag unset and apply. The plan only moves the repositories to a new address (`module.ecr` to `module.ecr[0]`), nothing is created or destroyed.
2. Point your services at the images in the new registry: the `backend_image` and `launcher_image` inputs of the ECS module, or the Helm values on EKS. Until then, the services keep pulling from ECR.
3. Decide what happens to the repositories:
   - **Keep them** (recommended). Remove them from the state, then set `create_container_registry = false` and apply. The repositories and their images stay in AWS, the module just stops managing them. Delete them yourself once you don't need them:

     ```shell
     tofu state rm 'module.spacelift.module.ecr[0]'
     ```

     Replace `spacelift` with the name of your module block, and `tofu` with `terraform` if you use Terraform. Set the flag to `false` before the next apply, otherwise the module tries to create the repositories again.
   - **Delete them with the images**. Set `ecr_force_delete = true` and apply, then set `create_container_registry = false` and apply again. It takes two applies because the AWS provider uses the `force_delete` value from the previous apply.

> [!WARNING]
> If you set the flag to `false` without one of the two options above, the apply fails with `RepositoryNotEmptyException`, and so does every apply after it. The repositories with images stay in place, but empty repositories and the lifecycle policies are deleted. If `ecr_force_delete` was already `true`, the same apply deletes both repositories and all the images in them.

The configuration is in [`main.tf`](./main.tf). It uses the local module source (`../../`), so swap in the registry source (`spacelift-io/spacelift-selfhosted/aws`) in your own code.
