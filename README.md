# Call of Duty tools <!-- omit in toc -->
Tool to use the Call of Duty API

**Table of contents**

- [Commands](#commands)
	- [Fetch Prestige/Level icons](#fetch-prestigelevel-icons)
		- [Name](#name)
		- [Synopsis](#synopsis)
		- [Syntax](#syntax)
		- [Description](#description)
		- [Parameters](#parameters)
		- [Example](#example)
	- [Login to an Activision account](#login-to-an-activision-account)
		- [Name](#name-1)
		- [Synopsis](#synopsis-1)
		- [Syntax](#syntax-1)
		- [Description](#description-1)
		- [Parameters](#parameters-1)
		- [Example](#example-1)

# Commands

## Fetch Prestige/Level icons

### Name

.\fetch_icons.ps1

### Synopsis

Export icons from the CDN

### Syntax

``.\fetch_icons.ps1 [[-ExportPath] <String>] [-CwIcons] [-MwIcons] [-Bo4Icons] [-WwiiIcons] [-OnlyPrestiges] [-AllGames] [-LittleIcons] [<CommonParameters>]``

### Description

Export the CoD Prestige/Level icons from the CDN

### Parameters

*	``-ExportPath <String>``
	The path where to save the icons

*	``-CwIcons``
	Download Black ops Cold War icons, included in AllGames

*	``-MwIcons`` 
	Download Modern Warfare 2019 icons, included in AllGames

*	``-Bo4Icons``
	Download Black ops 4 icons, included in AllGames

*	``-WwiiIcons``
	Download World War II icons, included in AllGames

*	``-OnlyPrestiges``
	Only download the prestige icons

*	``-AllGames``
	Download all the icons from each games

*	``-LittleIcons``
	Download non large icons (if available)

### Example

```powershell
PS > .\fetch_icons.ps1 -AllGames
```

## Login to an Activision account

### Name

.\cod_login.ps1

### Synopsis

Login to the Activision API

### Syntax

``.\cod_login.ps1 [[-Username] <String>] [[-Password] <SecureString>] [[-SaveFile] <String>] [-ReturnLoginInformation] [<CommonParameters>]``


### Description

Login to the Activision API and return login data into a file or in the pipeline


### Parameters

*   ``-Username <String>``
    The email/username to connect to your Activision account

*   ``-Password <SecureString>``
    A ``SecureString`` of your password to connect

*   ``-SaveFile <String>``
    By default "login_data.json", where the login data are saved, useless if the -ReturnLoginInformation is set

*   ``-ReturnLoginInformation``
    Return the login information into the pipeline

### Example

```powershell
PS> $pass = Read-Host -AsSecureString
******************
PS> .\cod_login.ps1 -Username "mymail@example.org" -Password $pass
Register DEVICE_ID '****'...
Login...
Writing login tokens into 'login_data.json'
```


