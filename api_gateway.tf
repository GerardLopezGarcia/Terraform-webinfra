# API Gateway para Lambda One
resource "aws_api_gateway_rest_api" "api_one" {
  name = "APIForLambdaOne"
}

resource "aws_api_gateway_resource" "api_one_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_one.id
  parent_id   = aws_api_gateway_rest_api.api_one.root_resource_id
  path_part   = "lambda-one"
}

resource "aws_api_gateway_method" "api_one_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_one.id
  resource_id   = aws_api_gateway_resource.api_one_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_one_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api_one.id
  resource_id            = aws_api_gateway_resource.api_one_resource.id
  http_method            = aws_api_gateway_method.api_one_method.http_method
  type                   = "AWS_PROXY"
  integration_http_method = "POST"
  uri                    = aws_lambda_function.lambda_one.arn
}

resource "aws_api_gateway_deployment" "api_one_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_one.id
  depends_on  = [aws_api_gateway_integration.api_one_integration]
}

resource "aws_api_gateway_stage" "api_one_stage" {
  deployment_id = aws_api_gateway_deployment.api_one_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_one.id
  stage_name    = "dev"
}

resource "aws_lambda_permission" "api_one_permission" {
  statement_id  = "AllowAPIGatewayInvokeOne"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_one.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_one.execution_arn}/*/*"
}

# Repite para Lambda Two
resource "aws_api_gateway_rest_api" "api_two" {
  name = "APIForLambdaTwo"
}

resource "aws_api_gateway_resource" "api_two_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_two.id
  parent_id   = aws_api_gateway_rest_api.api_two.root_resource_id
  path_part   = "lambda-two"
}

resource "aws_api_gateway_method" "api_two_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_two.id
  resource_id   = aws_api_gateway_resource.api_two_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_java_integration" {
  rest_api_id            = aws_api_gateway_rest_api.api_one.id
  resource_id            = aws_api_gateway_resource.api_one_resource.id
  http_method            = aws_api_gateway_method.api_one_method.http_method
  type                   = "AWS_PROXY"
  integration_http_method = "POST"
  uri                    = aws_lambda_function.lambda_java.arn
}

resource "aws_api_gateway_deployment" "api_two_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_two.id
  depends_on  = [aws_api_gateway_integration.api_java_integration]
}

resource "aws_api_gateway_stage" "api_two_stage" {
  deployment_id = aws_api_gateway_deployment.api_two_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_two.id
  stage_name    = "dev"
}

resource "aws_lambda_permission" "api_two_permission" {
  statement_id  = "AllowAPIGatewayInvokeTwo"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_two.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api_two.execution_arn}/*/*"
}