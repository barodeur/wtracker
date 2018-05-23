variable "apex_function_receive" {}

provider "aws" {
  profile = "wtracker"
}

resource "aws_s3_bucket" "emails" {
  bucket = "fr.chobert.wtrakcer.emails"
  acl    = "private"
}

resource "aws_s3_bucket_policy" "emails_bucket_policy" {
  bucket = "${aws_s3_bucket.emails.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSESPuts",
      "Effect": "Allow",
      "Principal": {
        "Service": "ses.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.emails.id}/*",
      "Condition": {
        "StringEquals": {
          "aws:Referer": "767605993600"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_ses_receipt_rule" "store" {
  name          = "store"
  rule_set_name = "default-rule-set"
  recipients    = ["track@wtracker.chobert.fr"]
  enabled       = true
  scan_enabled  = true

  s3_action {
    position    = 0
    bucket_name = "${aws_s3_bucket.emails.id}"
  }

  lambda_action {
    position     = 1
    function_arn = "${var.apex_function_receive}"
  }
}

resource "aws_lambda_permission" "allow_ses" {
  statement_id   = "AllowExecutionFromSES"
  action         = "lambda:InvokeFunction"
  function_name  = "${var.apex_function_receive}"
  source_account = "767605993600"
  principal      = "ses.amazonaws.com"
}
