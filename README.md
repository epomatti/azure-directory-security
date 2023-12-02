# Azure Directory Security

Implementation for Active Directory integrations with Entra ID.

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Terraform will install `AD-Domain-Services` via custom scripts extension.

Install the AD Domain Services package:

```sh
# You'll need to type in the password and select "A" for all
Install-ADDSForest -DomainName contoso.local -InstallDNS
```

The server will be restarted.





[1]: https://www.dell.com/support/kbdoc/en-us/000121955/installing-active-directory-domain-services-and-promoting-the-server-to-a-domain-controller
