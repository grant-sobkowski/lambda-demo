# Creates iam policy for lambda
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

# Creates iam role for lambda using assume_role policy
resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Creates zip for lambda code using ../lambda_code as src dirA
# https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.root}/../lambda_code/lambda_function.py"
  output_path = "${path.root}/../compiled_code/lambda_function_payload.zip"
}

# Creates lambda function
resource "aws_lambda_function" "test_lambda" {
  filename      = "${path.root}/../compiled_code/lambda_function_payload.zip"
  function_name = "smoothstack_lambda_demo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"

  environment {
    variables = {
      foo = "bar"
    }
  }
}