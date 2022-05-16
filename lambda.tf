locals {
    lambdazip_filepath = "output/hello.zip"
}

data "archive_file" "hello" {
  type        = "zip"
  source_file = "hello.py"
  output_path = "${local.lambdazip_filepath}"
}



resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a 
  # path.module in the filename.
  filename      = "${local.lambdazip_filepath}"
  function_name = "hello"
  role          = aws_iam_role.lambda_role.arn
  handler       = "hello.hellolambda"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  
  #source_code_hash = filebase64sha256("local.lambdazip_filepath")

  runtime = "python3.9"

}