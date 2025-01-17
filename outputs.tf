output "kendra_index_id" {
  value = awscc_kendra_index.kendra_index.id
}

output "kendra_datasource_s3_id" {
  value = awscc_kendra_data_source.kendra_datasource_s3.id
}