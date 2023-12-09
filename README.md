# Azure Directory Security

Implementation for Active Directory integrations with Entra ID.

Copy the template for the `.auto.tfvars`:

```sh
cp config/template.tfvars .auto.tfvars
```

Set you public IP to be allowed in the firewalls:

```sh
dig +short myip.opendns.com @resolver1.opendns.com
```

Create the infrastructure:

```sh
terraform init
terraform apply -auto-approve
```

Terraform will install `AD-Domain-Services` via custom scripts extension.

Install the AD Domain Services package:

> If possible , set the domain to be the same as the Entra tenant. Needs to be <= 15 characters due to Active Directory dependency on NetBIOS.

```sh
# You'll need to type in the password and select "A" for all
Install-ADDSForest -DomainName contoso.local -InstallDNS
```

🔴🟢 The server will be restarted.

- Password Hash Synchronization
- Pass-through Authentication
- Federated Authentication
-

There are two offerings for sync:

- Entra Connect V2
- Entra Connect Cloud Sync

We'll proceed with [Connect V2][3] here.

Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))

https://learn.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key#to-create-the-kds-root-key-in-a-test-environment-for-immediate-effectiveness

Terraform will also have created an `administrator` account with `Hybrid Identity Administrator` privileged to be used during AD sync setup. Use it to configure synchronization.

> Enable advanced features in Active Directory

```
OU=Cloud,DC=contoso,DC=local
```


[1]: https://www.dell.com/support/kbdoc/en-us/000121955/installing-active-directory-domain-services-and-promoting-the-server-to-a-domain-controller
[2]: https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync
[3]: https://www.microsoft.com/en-us/download/details.aspx?id=47594
