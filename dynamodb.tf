#DynamoDB Table
resource "aws_dynamodb_table" "crud-api-db" {
  name           = "crud-api-db"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1  
  write_capacity = 1
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "Expiry"
    enabled        = false
  }

  point_in_time_recovery { enabled = true }
  server_side_encryption { enabled = true }

  lifecycle { ignore_changes = [write_capacity, read_capacity] }

  tags = {
    Name = "crud-api-db"
  }
}
