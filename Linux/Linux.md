#Linux Odds and Ends

# XML Parsing -- Xmlstarlet #

xmlstarlet el table.xml         # Show path information
xmlstarlet el -a table.xml      # Show attributes
xmlstarlet el -a table.xml      # show attributes & their values

<b>Nmap host script Xpath<b/>
nmaprun/host/hostscript/script/@id

<b>Print IPs vulnerable to specific CVE w/host script output</b>
(cmd)> xmlstarlet sel -t -m "//host/hostscript/script[@id='smb-vuln-cve2009-3103']/../../address[@addrtype='ipv4']" -n -v "@addr" table.xml


