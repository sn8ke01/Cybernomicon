# Linux Odds and Ends #
## Some Basic User Admin
```bash
#Add user with custom home dir, shell, and groups
$> user='user_name'
$> groups='group_names' #comma seperated :: sudo,whales,justice_leauge
$> useradd -m -d /home/$user -s /bin/bash -U $user -G $groups

#Change users name and home directory - Must be in /home.  This will create new home dir in current working directory.
$> usermod -l newname -d /home/newname -m oldname

#Add user to existing group
$> usermod -aG <group> <user>

#Change group name
$> groupmod --new-name <new grp name> <old grp name>

#Remove user from Group
$> gpasswd -d user group

#Delete user and home directory
$> userdel -r user

#Create /home for a user that already exists
 $> mkhomedir_helper <user>

#force user logoff
$> who  #Shows user pts/# sessions
$> ps -dN |grep pts/<num> #get PID of session to terminate
$> kill -9 PID #kill session and force logoff
``` 
## Bash Prompts
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

### SCP & RSYNC
```bash
#SCP: PULL -- Secure Copy from a file/dir from a remote host to your local host
$> scp user@remote_host.com:/some/remote/directory ~/my_local_file.txt

#SCP: PUSH -- Secure Copy from a file/dir from your local host to remote host
$> scp -r /etc/skel/. user@remote_host:/etc/skel

#SCP: Secure copy with a private key
$> scp -i /path/to/key [rest of appropriate PULL or PUSH]

#RSYNC: Copy from a remote location to localhost - only new files.
$> rsync -avute 'ssh' user@$remote_host:/path/to/dir/* .

```
