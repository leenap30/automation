#provider
provider "aws" {
   region = "us-east-2"
}

#lambda function
data "archive_file" "hello" {
  type        = "zip"
  source_file = "hello.js"
  output_path = "outputs/hello.zip"
}

resource "aws_lambda_function" "myLambda" {
  filename      = "outputs/hello.zip"
  function_name = "hello"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello.handler"

 
  # source_code_hash = filebase64sha256("outputs/welcome.zip")

   runtime = "nodejs12.x"


}

 # IAM role which dictates what other AWS services the Lambda function
 # may access.
 
resource "aws_iam_role" "lambda_role" {
   name = "role_lambda"

   assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

#API gateway trigger
resource "aws_apigatewayv2_api" "apiLambda" {
  name        = "myAPI"
  protocol_type = "HTTP"
}

 resource "aws_apigatewayv2_integration" "example" {
  api_id           = aws_apigatewayv2_api.apiLambda.id
  integration_type = "AWS"

  connection_type           = "INTERNET"
  content_handling_strategy = "CONVERT_TO_TEXT"
  description               = "Lambda example"
  integration_method        = "POST"
  passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_deployment" "example" {
  api_id      = aws_apigatewayv2_route.example.api_id
  description = "Example deployment"
}

  output "base_url" {
  value = "echo ${aws_api_gateway_deployment.example.invoke_url} >> op.txt"
}

#s3 bucket
resource "aws_s3_bucket" "b1" {

  bucket = "awsbucketlambda"

  acl    = "public-read"

  policy = file("policy.json")

  website {

    index_document = "test-web.html"

    error_document = "error.html"
  }



  tags = {

    Name        = "My bucket"

    Environment = "Dev"

  }

}

resource "aws_s3_bucket_object" "object1" {

  bucket       = aws_s3_bucket.b1.id

  key          = "test-web.html"

  acl          = "public-read-write"

  source       = "test-web.html"

  content_type = "text/html"


}

resource "aws_s3_bucket_object" "object2" {

  bucket       = aws_s3_bucket.b1.id

  key          = "error.html"

  acl          = "public-read-write"

  source       = "error.html"

  content_type = "text/html"
}
