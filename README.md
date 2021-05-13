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
	- [Build WebSession for InvokeWeb-Request](#build-websession-for-invokeweb-request)
		- [Name](#name-2)
		- [Synopsis](#synopsis-2)
		- [Syntax](#syntax-2)
		- [Description](#description-2)
		- [Parameters](#parameters-2)
		- [Example](#example-2)
	- [Fetch Call of Duty Black Ops 4 data](#fetch-call-of-duty-black-ops-4-data)
		- [Name](#name-3)
		- [Synopsis](#synopsis-3)
		- [Syntax](#syntax-3)
		- [Description](#description-3)
		- [Parameters](#parameters-3)
		- [Example](#example-3)

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

## Build WebSession for InvokeWeb-Request

### Name

.\build_sso_websession.ps1

### Synopsis

Build a session from the cod_login.ps1 output


### Syntax
    
``.\build_sso_websession.ps1 [[-loginData] <Object>] [[-SaveFile] <String>] [[-CookieDomain] <String>] [<CommonParameters>]``


### Description

Build a session from the cod_login.ps1 output

### Parameters

*   ``-loginData <Object>``
    Login data object, returned by cod_login.ps1 using the -ReturnLoginInformation switch

*   ``-SaveFile <String>``
    Login save file, returned by default by cod_login.ps1 without using the -ReturnLoginInformation switch

*   ``-CookieDomain <String>``
    The domain to match the cookies of the WebSession

### Example

```powershell
PS> # cod_login.ps1 was already executed and a login_data.json file exists
PS> .\build_sso_websession.ps1
Headers                : {[Authorization, bearer ****], [X_COD_DEVICE_ID, ****]}
Cookies                : System.Net.CookieContainer
UseDefaultCredentials  : False
Credentials            :
Certificates           :
UserAgent              : cod-ate-worker
Proxy                  :
MaximumRedirection     : -1
MaximumRetryCount      : 0
RetryIntervalInSeconds : 0
```

## Fetch Call of Duty Black Ops 4 data

### Name
    
.\fetch_bo4_data.ps1

### Synopsis
    
Fetch Call of Duty Black Ops 4 data of a player

### Syntax
    
``.\fetch_bo4_data.ps1 [[-UserName] <String>] [[-Platform] <String>] [[-Session] <Object>] [<CommonParameters>]``


### Description
    
Fetch Call of Duty Black Ops 4 data of a player and output json, can fail if the user doesn't allow the share of his stats with the other

### Parameters

*   ``-UserName <String>``
    The username of the player

*   ``-Platform <String> = "xbl", "battle", "steam", "psn"``
    The platform of the user

*   ``-Session <Object>``
    The session to connect, null to generate a new one

### Example

```powershell
PS>.\fetch_bo4_data.ps1 -UserName ATE48 -Platform xbl
Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/mp/ to output_account/xbl_ATE48_mp.json...
Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/blackout/ to output_account/xbl_ATE48_blackout.json...
Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/zombies/ to output_account/xbl_ATE48_zombies.json...
```
