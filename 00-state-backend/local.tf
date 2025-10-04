locals {
    account_id = data.aws_caller_identity.current.account_id
    bucket_name = "${var.remote_backend.bucket_name}-${local.account_id}"
}