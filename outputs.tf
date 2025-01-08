output "api_one_url" {
  value = "https://${aws_api_gateway_rest_api.api_one.id}.execute-api.${var.region}.amazonaws.com/dev/lambda-one"
}

output "api_two_url" {
  value = "https://${aws_api_gateway_rest_api.api_two.id}.execute-api.${var.region}.amazonaws.com/dev/lambda-two"
}