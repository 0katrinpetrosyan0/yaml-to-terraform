### This guide is about `k3s (on-premise k8s)` installation

* ##### Connect to server

`ssh username@hostname`

* ##### K3S Installation

`curl -sfL https://get.k3s.io | sh -`

`sudo chmod 755 /etc/rancher/k3s/k3s.yaml`

* ##### Install Kubectl

`curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"`

`sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl`

`chmod +x kubectl`

`mkdir -p ~/.local/bin`

`mv ./kubectl ~/.local/bin/kubectl`

* ##### Add K3S kubeconfig path to environment variable
`export KUBECONFIG=/etc/rancher/k3s/k3s.yaml`

* ###### (Optional), treafik ingress controller is enabled by default, but you can turn it off
  ###### Just Add this line under `/etc/systemd/system/k3s.service`

  `--no-deploy traefik \`
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.41 |
| <a name="requirement_github"></a> [github](#requirement\_github) | ~> 4.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | ~> 0.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_credentials_variable_set"></a> [aws\_credentials\_variable\_set](#module\_aws\_credentials\_variable\_set) | dasmeta/cloud/tfe//modules/variable-set | 1.0.0 |
| <a name="module_github_repository"></a> [github\_repository](#module\_github\_repository) | dasmeta/repository/github | 0.7.3 |
| <a name="module_this"></a> [this](#module\_this) | dasmeta/cloud/tfe | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [tfe_oauth_client.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/oauth_client) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key_id"></a> [aws\_access\_key\_id](#input\_aws\_access\_key\_id) | The aws user access key | `string` | n/a | yes |
| <a name="input_aws_secret_access_key"></a> [aws\_secret\_access\_key](#input\_aws\_secret\_access\_key) | The aws user secret access key | `string` | n/a | yes |
| <a name="input_git_org"></a> [git\_org](#input\_git\_org) | The github org/owner name | `string` | n/a | yes |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | The github repo name without org prefix | `string` | n/a | yes |
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | This is the same as GITHUB\_TOKEN env variable will be set. This will setup terraform cloud to git repo connection authentication | `string` | n/a | yes |
| <a name="input_terraform_cloud_org"></a> [terraform\_cloud\_org](#input\_terraform\_cloud\_org) | The terraform cloud org name | `string` | n/a | yes |
| <a name="input_terraform_cloud_token"></a> [terraform\_cloud\_token](#input\_terraform\_cloud\_token) | The terraform cloud token | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
