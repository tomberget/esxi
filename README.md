# esxi

## terraform init

```bash
terraform init -reconfigure -backend-config="dynamodb_table=${TERRAFORM_STATE_DYNAMODB_TABLE}" -backend-config="bucket=${TERRAFORM_STATE_AWS_BUCKET}"
```
