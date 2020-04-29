### System Hunting

Get list of computers in current domian

get-netcomputer

get-netcomputer -OperatingSystem "*Server 2016*"

Get-ADComputer -Filter * | select Name 

Get-ADComputer -Filter 'OperatingSystem -like "*Server*"' -Properties OperatingSystem,DNSHostName | select Name,OperatingSystem,DNSHostName

