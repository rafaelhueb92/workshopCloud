output "s3_bucket_name" {
    value =  aws_s3_bucket.this.id
}

output "dyname_table_arn" {
    value = aws_dynamodb_table.this.arn
}