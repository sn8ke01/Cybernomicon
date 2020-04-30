# Hijacking Kerberose Tickets
> Jacking kerberos tickets to remotely access the intranet

1. Attacker creates a web page seving a malicous HTA file
2. Target browses the attacker-sent web page & executes the served HTA file
3. Meterpreter session is established
4. Malicous Code Injection
	- A: PowerShell script for recon against browser is injected into the target workstation's memory.
	- B: gssapu-proxy is dropped and executed.  The attacker can connect to port 8080 & browse the intranet, hijacking the target's active Kerberose tickets.


## 1. Malicous HTA File


## 2. HTA File is Executed


## 3. Meterpreter Session


## 4. Malicous Code Injection