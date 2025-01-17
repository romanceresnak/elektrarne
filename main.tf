resource "aws_s3_bucket" "resources-bucket" {
  bucket = "s3-kendra-resources"
}

resource "aws_s3_object" "object" {
  for_each = { for f in var.files : f => f }
  bucket = aws_s3_bucket.resources-bucket.id
  key      = basename(each.value)
  source = each.value

  etag = filemd5(each.value)
}