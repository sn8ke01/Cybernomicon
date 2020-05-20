# Attacking Network Protocols

> These are my notes of the book of the same name by **James Forshaw** (https://nostarch.com/networkprotocols)

## Simple Setup Notes ##

**Install .NET Core SDK version 1.1.x**

Source | OS | Link
---|---|---
Windows | Various | [Dotnet Core v1.1](https://www.microsoft.com/net/download/dotnet-core/1.1)
GitHub |  Various | [Dotnet Core Archive {various}](https://github.com/dotnet/core/blob/master/release-notes/download-archive.md)
 

**Download and unzip**

Name | Source | File Name | Link
---|---|---|---
CANAPE Core | Github | **CANAPE.Core_netcoreapp1.1_v1.0.7z** | [Tyranid: CANAPE.Core](https://github.com/tyranid/CANAPE.Core/releases/download/v1.0/CANAPE.Core_netcoreapp1.1_v1.0.7z)
SuperFunkyChat | Github |**SuperFunkyChatCore_netcoreapp1.1_v1.0.2.7z** | [Tyranid: SuperFunkyChat](https://github.com/tyranid/ExampleChatApplication/releases/download/v1.0.2/SuperFunkyChatCore_netcoreapp1.1_v1.0.2.7z)
Chapter Listings | No Starch Press | **anp_listings.zip** | [NSP: Attack Net Proto](https://nostarch.com/download/anp_listings.zip)
Above 3 files | This repo | **attacking_netowrk_protocols_dirs.tgz** (md5: e5d9f75d14cdb35d4ea1e5a87e564dbe) | [tgz file](attacking_netowrk_protocols_dirs.tgz) 
	
**Uninstall .NET** [*if needed*]

	https://raw.githubusercontent.com/dotnet/cli/rel/1.0.0/scripts/obtain/uninstall/dotnet-uninstall-pkgs.sh

**attacking_newtworking_protocols_dir.tgz** dir layout
```bash
anp
  +--->canape
  |      |
  |      +--------> CANAPE.Core_netcoreapp1.1_v1.0.7z [fully extracted]
  |
  +--->listings
  |      |
  |      +--------> anp_listings.zip [fully extracted]
  |
  +--->superfunkychat
         |
         +--------> SuperFunkyChatCore_netcoreapp1.1_v1.0.2.7z [fully extracted]
  
```
