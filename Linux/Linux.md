# Linux Odds and Ends #

## XML Parsing -- Xmlstarlet
```bash
xmlstarlet el table.xml         
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


