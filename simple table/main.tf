provider "aws" {
  region = "us-west-2"  # Replace with your preferred AWS region
}

resource "aws_dynamodb_table" "my_table" {
  name           = "my-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"  # Use "PROVISIONED" if you want to specify capacity
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"  # S = String, N = Number, B = Binary
  }

  tags = {
    Environment = "dev"
    Project     = "MyProject"
  }
}
