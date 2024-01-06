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

It is possible to configure these types of authentication on Entra ID:

- Password Hash Synchronization
- Pass-through Authentication
- Federated Authentication

There are two offerings for sync:

- Entra Connect V2
- Entra Connect Cloud Sync

Terraform will also have created an `administrator` account with `Hybrid Identity Administrator` privilege to be used during Entra sync setup. Use it to configure synchronization.

## Entra Connect V2



## Cloud Sync

Follow the [instructions][4] to install the Cloud Sync agent.

> It will be required to enable advanced features in Active Directory

When creating an Organizational Unit named `Cloud`, this is an example fo a "Distinguished Name".

```
OU=Cloud,DC=contoso,DC=local
```

It might be required to set this [KDS Root key][3]:

```
Add-KdsRootKey -EffectiveTime ((get-date).addhours(-10))
```

[1]: https://www.dell.com/support/kbdoc/en-us/000121955/installing-active-directory-domain-services-and-promoting-the-server-to-a-domain-controller
[2]: https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync
[3]: https://learn.microsoft.com/en-us/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key#to-create-the-kds-root-key-in-a-test-environment-for-immediate-effectiveness
[4]: https://learn.microsoft.com/en-us/entra/identity/hybrid/install
