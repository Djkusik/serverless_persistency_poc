output "function_name" {
    description = "Name of the Lambda function."

    value = aws_lambda_function.VulnLambda.function_name
}

output "base_url" {
    description = "Base URL for API Gateway stage."

    value = aws_apigatewayv2_stage.lambda.invoke_url
}

output "connection_url" {
    description = "URL under which VulnLambda is hosted."

    value = "${aws_apigatewayv2_stage.lambda.invoke_url}/${aws_lambda_function.VulnLambda.function_name}"
}