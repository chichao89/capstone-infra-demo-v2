resource "aws_dynamodb_table" "users_table" {
  name         = "${var.environment}-${var.dynamodb_table_name}" # Dynamic table name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "username"

  attribute {
    name = "username"
    type = "S"
  }

  tags = {
    Name        = "${var.environment}-${var.dynamodb_table_name}"
    Environment = var.environment
  }
}
