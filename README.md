# Azure Directory Security

Implementation for Active Directory integrations with Entra ID.

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Terraform will install `AD-Domain-Services` via custom scripts extension.

Install the AD Domain Services package:

> Set the domain to be the same as the Entra tenant, such as "<domain>.onmicrosoft.com"

```sh
# You'll need to type in the password and select "A" for all
Install-ADDSForest -DomainName <Entra Domain> -InstallDNS
```

The server will be restarted.

- Password Hash Synchronization
- Pass-through Authentication
- Federated Authentication
-

There are two offerings for sync:

- Entra Connect V2
- Entra Connect Cloud Sync

We'll proceed with [Connect V2][3] here.

Terraform will also have created an administrator account with `Hybrid Identity Administrator` privileged to be used during AD sync setup. Use it to configure synchronization.


[1]: https://www.dell.com/support/kbdoc/en-us/000121955/installing-active-directory-domain-services-and-promoting-the-server-to-a-domain-controller
[2]: https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync
[3]: https://www.microsoft.com/en-us/download/details.aspx?id=47594
