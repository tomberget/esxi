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
