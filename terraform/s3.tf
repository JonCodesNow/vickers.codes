resource "aws_s3_bucket" "s3_bucket" {
  bucket = "vickers.codes"

  tags = {
    Name = "My bucket"
  }
}


resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy  = file("/Users/jonvickers/github/JonCodesNow/vickers.codes/terraform/bucket.json")
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}


resource "aws_s3_bucket_website_configuration" "vickers_codes" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }
}
