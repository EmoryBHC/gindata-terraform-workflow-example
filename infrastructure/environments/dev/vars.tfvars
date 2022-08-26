# terraform variables  
project             = "sample-project"
project_description = "Doing samples stuff."
environment         = "dev"
source_directory    = "../src"
runtime             = "python3.9"
aws_account         = "012345678912"
secrets = {
  "SecretAPIKey = "A super secret API key"
}
environment_variables = {
  "APIKey" = "SecretAPIKey 
}