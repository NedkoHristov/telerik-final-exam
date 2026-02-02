# Security Guidelines

## Secret Management

This project uses Terraform variables to manage sensitive data. **Never commit secrets directly to version control.**

### Setup Instructions

1. **Create your secrets file:**
   ```bash
   cd terraform
   cp secrets.tfvars.example secrets.tfvars
   ```

2. **Fill in your actual values in `secrets.tfvars`:**
   - `ssh_public_key`: Your SSH public key content for the terraform user
   - `newrelic_license_key`: Your New Relic license key

3. **Use the secrets file when running Terraform:**
   ```bash
   terraform plan -var-file="secrets.tfvars"
   terraform apply -var-file="secrets.tfvars"
   ```

### Environment Variables Alternative

You can also set secrets via environment variables:
```bash
export TF_VAR_ssh_public_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQ..."
export TF_VAR_newrelic_license_key="eu01xxaXXXXXXXXXXXXXXXXXXXXXXXXXXNRAL"

terraform plan
terraform apply
```

### GitHub Actions

For CI/CD pipelines, store secrets in GitHub Secrets:
- Go to Repository Settings → Secrets and variables → Actions
- Add secrets: `TF_VAR_SSH_PUBLIC_KEY`, `TF_VAR_NEWRELIC_LICENSE_KEY`

### Files Protected by .gitignore

The following files are automatically ignored to prevent secret leaks:
- `secrets.tfvars`
- `*.auto.tfvars`
- `terraform.tfvars`

### Security Checklist

- [ ] Never commit `.tfvars` files with actual secrets
- [ ] Use `secrets.tfvars.example` as a template only
- [ ] Rotate secrets regularly
- [ ] Use different secrets for dev/staging/production environments
- [ ] Enable GitHub secret scanning alerts
- [ ] Review pull requests for accidentally committed secrets

## Reporting Security Issues

If you discover a security vulnerability, please email: nedelcho.hristov2001@gmail.com

Do not create public GitHub issues for security vulnerabilities.
