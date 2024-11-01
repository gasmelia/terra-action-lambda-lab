## IAM policy assume role for lambda function
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]

    }

    actions = ["sts:AssumeRole"]
  }
}

## IAM role for lambda function
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

## zip the function to be run at function App.
data "archive_file" "lambda" {
    type        = "zip"
    source_file = "lambda_function.py"
    output_path = "lambda_function.zip"
}

## test lambda function
resource "aws_lambda_function" "test_lambda" {
  filename      = "lambda_function.zip"
  function_name = "lambda_function"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  environment {
    variables = {
      foo = "bar"
    }
  }
}   





