provider "aws" {
  region = "us-west-2"
}

resource "aws_dynamodb_table" "event_log" {
  name         = "event-log"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-dynamodb-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "logs_policy_attach" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_lambda_function" "event_handler" {
  filename         = "lambda.zip"
  function_name    = "event-handler"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      DDB_TABLE_NAME = aws_dynamodb_table.event_log.name
    }
  }
}
