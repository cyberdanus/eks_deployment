output "s3_bucket_id" {
  value       = aws_s3_bucket.my-tform-state.id
  description = "The name of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.my-tform-lock.name
  description = "The name of the DynamoDB table"
}
