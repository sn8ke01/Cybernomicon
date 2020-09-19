# Red Teaming Active Directory
> This describes the workflow/process for attacking an Active Directory env

Main tools [for this module] 

1. PowerView

2. AD PowerShell Module

   1. Installing from Windows 10: https://docs.microsoft.com/en-us/archive/blogs/ashleymcglone/install-the-active-directory-powershell-module-on-windows-10

   2. Installing on Windows Server: 

      ```powershell
      Import-Module ServerManager
      Add-WindowsFeature RSAT-AD-PowerShell
      ```

## **Enumeration Activates**

### Hunt for users

​	DNS using LDAP

​	Perform DNS lookups using LDAP

```powe
get-adcomputer –filter * -Properties ipv4address | where {$_.IPV4address} | select name,ipv4address
```

OR

```powershell
get-adcomputer -filter {ipv4address -eq 'IP'} -PropertiesLastlogondate,passwordlastset,ipv4address

```

Service Principle Names (SPN) scanning leverages standard LDAP queries using looking for SPN.

Serach for types of various SPN types like MSSQLSvc, TERMSERV, WSMan, exchangeMDB by asking the AD DC.

<u>A service that supports Kerberos authentication must register an SPN.</u>

**SPN Scan**

```po
Get-ADComputer -filter {ServicePrincipalName -Like "*SPN*" } -PropertiesOperatingSystem,OperatingSystemVersion,OperatingSystemServicePack,PasswordLastSet,LastLogonDate,ServicePrincipalName,TrustedForDelegation,TrustedtoAuthForDelegation
```



### (Local) administrator enum

### GPO enum and abuse

Using *PowerView* to discover **group policies** within a domain (2.3.1 pg79)

```powershell
Get-NetGPO | select displayname,name,whenchanged
```

Straight PoweShell method of discovering **group policies**

```powerh
Get-GPO -All -Domain "$DomainName"
```



### AD ACLs 

### Domain Trusts 





