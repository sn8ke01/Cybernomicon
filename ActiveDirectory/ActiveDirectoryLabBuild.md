# Active Directory Lab Build
> Building an Active Directory Lab for Attacking & Defending

**Windows Components**

> Downloads from  Windows Evaluation Center or Visual Studio Subscription

- Windows Server 2019 x 1 --> [Windows Evaluation Center: Server 2019](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)
- Windows 10 Enterprise x 2 --> [Windows Evaluation Center: Win 10 Enterprise](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-10-enterprise)

**Hardware**

- 60gb Disk space
- 16gb RAM

## Build AD DC

1. Install **Server 2019 Standard (Desktop Experience)** in VMWare or VirtualBox (or other virtualizer of choice) 
2. Install VMWare/VB Tools
3. Rename Server (Optional) 
4. Add *Domain Controller* Role to server

### Install Server

> There are tons of virtualization walkthroughs.

- **Disk Space** = 60gb (single drive)
- **RAM** = 2-3gb
- Do  Not power on automaticly after install
- Delete **Floppy** *autoinst.flp*
- Be quick to **Hit any key** to boot system for intiall install

### Install Vmware/VB Tools

> VMWare: VM --> Install VMware Tools

### Rename Server (Optional)

> Windows --> Type [Rename PC] --> Rename PC --> Restart

### Add *Domain Controller* Role

- Server Manager --> Manager (upper right) --> Add Roles and Features

- Add Roles and Features 
  - Role-Based or feature-based installation - [Select Your server]
  - Server Roles [Active Directory Domain Services]
  - Click Next to Confirmation
  - Install

- Server Manager (upper right) Yellow Flag - Promote this server ... 
  - Add a new Forest **forestname.local**
  - Create password 
  -  Ignore delegation warning and move on 
  - NetBIOS name will populate (give it time)
  - Use default AD DS db file locations 
  - PreRecq Check (give it time)
  - **INSTALL** (give it time, then it will reboot, then give it more time)

## Build Windows 10 Clients

1. Install Windows 10 Enterprise (twice) in VMWare or VB or whatever... geeze
2. Install Tools
3. Join Domain

### Install Win10 Clients

> There are tons of virtualization walkthroughs.

- **Disk Space** = 60gb (single drive)
- **RAM** = 2gb
- Do  Not power on automaticly after install
- Delete **Floppy** *autoinst.flp*
- Be quick to **Hit any key** to boot system for initial install.  If you are slow do it again  and be quicker.

### Install Vmware/VB Tools

> VMWare: VM --> Install VMware T