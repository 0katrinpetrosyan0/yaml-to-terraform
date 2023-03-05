terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    tfe = {
      version = "~> 0.40.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.41"
    }
  }

  required_version = ">= 1.3.0"
}

/**
 * The variables can be set by env variable:

 export TF_VAR_{variable-name}=xxxxxxxxxxxxxxx
**/
variable "git_org" {
  type        = string
  description = "The github org/owner name"
}
variable "git_repo" {
  type        = string
  description = "The github repo name without org prefix"
}
variable "github_token" {
  type        = string
  description = "This is the same as GITHUB_TOKEN env variable will be set. This will setup terraform cloud to git repo connection authentication"
}
variable "aws_access_key_id" {
  type        = string
  description = "The aws user access key"
}
variable "aws_secret_access_key" {
  type        = string
  description = "The aws user secret access key"
}
variable "terraform_cloud_org" {
  type        = string
  description = "The terraform cloud org name"
}
variable "terraform_cloud_token" {
  type        = string
  description = "The terraform cloud token"
}

# providers
provider "github" {
  owner = var.git_org
  token = var.github_token
}
provider "tfe" {
  token = var.terraform_cloud_token
}
provider "aws" {
  region     = "eu-central-1" # TODO: have configurable this field
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}


# create an empty github repository
module "github_repository" {
  source  = "dasmeta/repository/github"
  version = "0.7.4"

  name              = var.git_repo
  create_repository = false
  default_branch    = "master"
  visibility        = "private"
  files             = [for file in fileset("./infra", "**") : { remote_path = file, local_path = "infra/${file}" }]

  depends_on = [
    module.this
  ]
}

# for oauth_token_id generation
resource "tfe_oauth_client" "this" {
  name             = "test-github-oauth-client"
  organization     = var.terraform_cloud_org
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_token
  service_provider = "github"
}

# create variable set
module "aws_credentials_variable_set" {
  source  = "dasmeta/cloud/tfe//modules/variable-set"
  version = "1.0.0"

  name = "test_aws_credentials"
  org  = var.terraform_cloud_org
  variables = [
    {
      key       = "AWS_ACCESS_KEY_ID"
      value     = var.aws_access_key_id
      category  = "env"
      sensitive = true
    },
    {
      key       = "AWS_SECRET_ACCESS_KEY"
      value     = var.aws_secret_access_key
      category  = "env"
      sensitive = true
    }
  ]
}


module "this" {
  source  = "dasmeta/cloud/tfe"
  version = "1.0.0"

  for_each = { for key, item in yamldecode(
    file("./infra.yaml")
    #    file("./mocks/modules-state-cleanup.yaml") # uncomment me(comment out above line) and apply to cleanup states before destroying
  ) : key => item }

  name           = each.key
  module_source  = each.value.source
  module_version = each.value.version
  module_vars    = each.value.variables
  target_dir     = "./infra/"

  module_providers  = try(each.value.providers, [])
  linked_workspaces = try(each.value.linked_workspaces, null)

  workspace = {
    org = var.terraform_cloud_org
  }

  repo = {
    identifier     = "${var.git_org}/${var.git_repo}"
    oauth_token_id = tfe_oauth_client.this.oauth_token_id
  }

  variable_set_ids = [module.aws_credentials_variable_set.id]
}
