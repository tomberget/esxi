# Kubernetes @ home

This terraform repository is for setting up Kubernetes @ home. In my case, the VMs are hosted using VMWare ESXI, using NFS as storage backend. I have not yet bothered setting up a proper vSphere CSI (or alternative) for it yet :)

## Backend

The terraform state file is no longer stored in AWS S3 with DynamoDB as state locking. Now, the state file is stored in Kubernetes, using the namespace `terraform`. This simplifies matters, like the number of *environmental variables* needed in order to execute a terraform statement.
## Initialize state file

To initialize the terraform state file, use the command below:

```bash
terraform init -reconfigure
```

## Format and validate

An easy validation of the code you are writing is performed by using the `fmt` and `validate` commands, like so:

```bash
terraform fmt -recursive
```

This formats your terraform files, recursively from the folder you initiate it.

```bash
terraform validate
```

This runs through your code quickly, to root out any obvious issues.

## Plan and Apply

Use `terraform plan` to validate any changes you have made, and study the plan if necessary. In case you are overtly sure of yourself, go ahead and run the `apply` command instead. What can possibly go wrong? :o)

```bash
terraform apply
```

## Environmental variables that must be set

In this case, these are the *environmental variables* that must be set in order to be able to run the `terraform apply`.

| Environmental variable | Used for |
----------------------------------------
| AWS_ACCESS_KEY_ID | Connecting to AWS and updating the Route53 records |
| KUBE_CONFIG_PATH | Connecting to Kubernetes |
| TF_VAR_metallb_network_range | Defining a network range for MetalLB |
| TF_VAR_ha_metrics_token | Long lived token for connecting Prometheus to Home-Assistant. Will be removed |
| TF_VAR_email_address | For certificates via cert-manager |
| TF_VAR_hosted_zone_id | The Hosted Zone Id for Route53 |
| TF_VAR_domain | Local domain (example.lan) |
| TF_VAR_external_domain | Domain name used in Route53 (example.com) |
