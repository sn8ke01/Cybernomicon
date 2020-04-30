# Groups Enumeration

Get-NetGroup 

Get-NetGroup -Domain $domain

Get-NetGroup -FullData

Get-ADGroup -Filter * | select Name

Get-ADGroup -Filter * -Properties *

Get-NetGroup *admin*

Get-ADGroup -Filter 'Name -like "*admin*"' | select Name

## Get group members
Get-ADGroupMember -Identity "Domain Admins" -Recursive

## Get user group associations 
get-adprinciblegroupmembership -Identity $user 