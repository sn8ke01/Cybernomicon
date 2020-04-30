### System Hunting
> How to find computers and othe systems registered in an AD domian.

Get list of computers in current domian

get-netcomputer

get-netcomputer -OperatingSystem "*Server 2016*"

Get-ADComputer -Filter * | select Name 

Get-ADComputer -Filter 'OperatingSystem -like "*Server*"' -Properties OperatingSystem,DNSHostName | select Name,OperatingSystem,DNSHostName

