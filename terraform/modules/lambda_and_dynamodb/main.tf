# DynamoDB table resource for visitor counter
resource "aws_dynamodb_table" "table_urbanconfig_cloud_resume" {
  name         = var.table_name
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}


# Lambda function resource
resource "aws_lambda_function" "my_lambda_function" {
  filename         = data.archive_file.zip_function.output_path
  source_code_hash = data.archive_file.zip_function.output_base64sha256
  function_name    = "my_lambda_function"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_iam_policy" "iam_policy_for_resume_project" {

  name        = "aws_iam_policy_for_terraform_resume_project_policy"
  path        = "/"
  description = "AWS IAM Policy for managing the resume project role"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "arn:aws:logs:*:*:*",
          "Effect" : "Allow"
        },
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:UpdateItem",
            "dynamodb:GetItem"
          ],
          "Resource" : "arn:aws:dynamodb:*:*:table/${aws_dynamodb_table.table_urbanconfig_cloud_resume.name}"
        },
      ]
  })
}

# Policy attachment to lambda IAM role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.iam_policy_for_resume_project.arn

}

# Package the lambda function code
data "archive_file" "zip_function" {
  type        = "zip"
  source_file = "${path.module}/lambda_function/lambda_function.py"
  output_path = "${path.module}/lambda_zip/lambda_function.zip"
}

# Lambda function URL resource with CORS configuration
resource "aws_lambda_function_url" "lambda_function_url" {
  function_name      = aws_lambda_function.my_lambda_function.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["https://${var.root_domain}"]
    allow_methods     = ["GET"]
    allow_headers     = ["*"]
    expose_headers    = ["*"]
    max_age           = 86400
  }
}