resource "aws_dynamodb_table" "crud_db" {
  name           = "http-crud-db"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "cruddapiID"
  attribute {
    name = "cruddapiID"
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
    Name = "CRUDApp_DB"
  }
}


#DynamoDB AutoScaling
resource "aws_appautoscaling_target" "dynamodb_table_read_target" {
  max_capacity       = 100
  min_capacity       = 5
  resource_id        = "table/http-crud-db"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name               = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.dynamodb_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.dynamodb_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.dynamodb_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.dynamodb_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }

    target_value = 70 #set utilization to 70%
  }
}