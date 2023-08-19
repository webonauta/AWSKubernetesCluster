provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
    shreed_config_file = "~/.aws/config"
    profile = "personal"
}