resource "aws_s3_bucket" "s3_bucket" {
  bucket = "vickers.codes"

  tags = {
    Name        = "My bucket"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.s3_bucket.id
  for_each = fileset("/Users/jonvickers/github/JonCodesNow/vickers.codes","*")
  key    = each.value
  source = "/Users/jonvickers/github/JonCodesNow/vickers.codes/${each.value}"
}


