# Linux Odds and Ends #
![Linux](../images/linux.jpg)
## Bash Promts
```bash
PS1="\[\e[0;31m\]\u@\[\e[m\]\[\e[1;34m\]\h-\[\e[m\]\e[0;32m\](\w) \[\e[0;31m\]\$ \[\e[m\]" 

PS1="\n\[\e[30;1m\]\[\016\]-\[\017\](\[\e[34;1m\]\u@\h\[\e[30;1m\])\[\017\]-(\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])\[\e[30;1m\]\[\016\](\[\e[34;1m\]\@ \d\[\e[30;1m\])-\n-(Jobs: \[\e[34;1m\]\j\[\e[30;1m\])--> \[\e[0m\]"

```
## XML Parsing -- Xmlstarlet
```bash
xmlstarlet el table.xml            #This is a comment    
xmlstarlet el -a table.xml      
xmlstarlet el -a table.xml      
```
### _Nmap host script Xpath_
```bash
nmaprun/host/hostscript/script/@id
```

### _Print IPs vulnerable to specific CVE w/host script output_
```bash
xmlstarlet sel -t -m "//host/hostscript/script[@id='smb-vuln-cve2009-3103']/../../address[@addrtype='ipv4']" -n -v "@addr" table.xml
```


