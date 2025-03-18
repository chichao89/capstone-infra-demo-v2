resource "aws_dynamodb_table" "users_table" {
  name         = "Users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "username"

  attribute {
    name = "username"
    type = "S"
  }

  tags = {
    Name        = "UsersTable"
    Environment = "Production"
  }
}
