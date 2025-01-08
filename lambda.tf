# Crear el rol de ejecución para la Lambda
resource "aws_iam_role" "lambda_execution_role" {
  name = "pci-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Asociar políticas necesarias al rol
resource "aws_iam_role_policy_attachment" "lambda_basic_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
# Primera Lambda
resource "aws_lambda_function" "lambda_one" {
  function_name = "LambdaOne"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = "lambda_one.zip" # Archivo ZIP de la Lambda
  source_code_hash = filebase64sha256("lambda_one.zip")
}

# Lambda en Java con JAR
resource "aws_lambda_function" "lambda_java" {
  function_name = "LambdaJavaExample"
  runtime       = "java11" # Cambia a "java8" o "java17" si usas otra versión de Java
  handler       = "com.example.Handler::handleRequest" # Clase y método de entrada
  role          = aws_iam_role.lambda_execution_role.arn
  filename      = "lambda-java-example.jar" # Ruta al JAR
  source_code_hash = filebase64sha256("lambda-java-example.jar") # Hash del archivo para detectar cambios
  memory_size   = 512
  timeout       = 15
}

/* En caso de querer añadir VPC -------------
resource "aws_iam_role_policy_attachment" "lambda_vpc_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Crear la Lambda
resource "aws_lambda_function" "test_lambda" {
  function_name = "TestLambda"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  filename         = "${path.module}/function.zip"
  source_code_hash = filebase64sha256("${path.module}/function.zip")

  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_group_ids = [aws_security_group.pci_alb_sg.id]
  }
}

# Permitir que el ALB invoque la Lambda
resource "aws_lambda_permission" "alb_invoke_permission" {
  statement_id  = "AllowALBInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "elasticloadbalancing.amazonaws.com"
}