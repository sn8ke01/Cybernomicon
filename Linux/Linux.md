# Linux Odds and Ends #

## Bash Promtps
```bash
#Short hostname & working dir <may be some color issues>
PS1="\[\e[0;31m\]\u@\[\e[m\]\[\e[1;34m\]\h-\[\e[m\]\e[0;32m\](\w) \[\e[0;31m\]\$ \[\e[m\]" 

#Same as above + Num files in Dir, Total size of Dir, Date, Num of jobs in background
PS1="\n\[\e[30;1m\]\[\016\]-\[\017\](\[\e[34;1m\]\u@\h\[\e[30;1m\])\[\017\]-(\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])\[\e[30;1m\]\[\016\](\[\e[34;1m\]\@ \d\[\e[30;1m\])-\n-(Jobs: \[\e[34;1m\]\j\[\e[30;1m\])--> \[\e[0m\]"

```
## XML Parsing -- Xmlstarlet
```bash
xmlstarlet el table.xml             #Path information      
xmlstarlet el -a table.xml          #Attributes
xmlstarlet el -a table.xml          #Attributes and Values
```
### _Nmap host script Xpath_
```bash
nmaprun/host/hostscript/script/@id
```

### _Print IPs vulnerable to specific CVE w/host script output_
```bash
xmlstarlet sel -t -m "//host/hostscript/script[@id='smb-vuln-cve2009-3103']/../../address[@addrtype='ipv4']" -n -v "@addr" table.xml
```

### OpenSSL
```bash
#Remove a passphrase from a private key
openssl rsa -in privateKey.pem -out newPrivateKey.pem

# All Cert Info
echo | openssl s_client -connect google.com:443 2>/dev/null | openssl x509 -noout -text
```