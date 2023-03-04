# Call of Duty tools <!-- omit in toc -->

Tool to use the Call of Duty API

You can find an API description in the [docs directory](docs/README.md).

**Table of contents**

- [Basic usage](#basic-usage)
	- [Get account data into Json](#get-account-data-into-json)
		- [Connect with the Activision account](#connect-with-the-activision-account)
		- [Fetch the data](#fetch-the-data)
		- [Find the data](#find-the-data)
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
	- [Fetch Call of Duty stats](#fetch-call-of-duty-stats)
		- [Name](#name-3)
		- [Synopsis](#synopsis-3)
		- [Syntax](#syntax-3)
		- [Description](#description-3)
		- [Parameters](#parameters-3)
		- [Example](#example-3)
	- [Fetch items icons from json data](#fetch-items-icons-from-json-data)
		- [Name](#name-4)
		- [Synopsis](#synopsis-4)
		- [Syntax](#syntax-4)
		- [Description](#description-4)
		- [Parameters](#parameters-4)
		- [Example](#example-4)
	- [Fetch items maps from json data](#fetch-items-maps-from-json-data)
		- [Name](#name-5)
		- [Synopsis](#synopsis-5)
		- [Syntax](#syntax-5)
		- [Description](#description-5)
		- [Parameters](#parameters-5)
		- [Example](#example-5)
	- [Fetch map icons (Fast)](#fetch-map-icons-fast)
		- [Name](#name-6)
		- [Synopsis](#synopsis-6)
		- [Syntax](#syntax-6)
		- [Description](#description-6)

# Basic usage

## Get account data into Json

To access all the data about an account you need the username, the plateform, an Activision account (can be another account) and that the account allowes viewing stats by the other account.

### Connect with the Activision account

Login to the Activision servers using this command:

```Powershell
PS> .\cod_login.ps1
```

It will prompt you the credentials of the Activision account, if everything is ok, a `login_data.json` file will be created.

### Fetch the data

Choose the script to use the data, here for the game Call Of Duty: Black Ops 4, .\fetch_game_data.ps1.

Use this command to get the account data:

```Powershell
PS> .\fetch_game_data.ps1 -UserName MyUsername -Platform MyPlatform
```

The parameters are:

- `MyUsername` The username of the account, for example mine is ATE48
- `MyPlatform` The username of the account, for example mine is xbl, you can choose between:
  - `xbl` - Xbox Live
  - `battle` - BattleNet
  - `steam` - Steam (Not working with BO4)
  - `psn` - PlayStation Network

My command for my account is for example

```Powershell
PS> .\fetch_game_data.ps1 -UserName ATE48 -Platform xbl
```

### Find the data

The json files are in the directory `output_account/<game>/<plateform>_<username>_<mode>.json`

For BO4 you can get some information like:

- All the modes
  - data.mp.level - the current level (between 1 and 55)
  - data.mp.paragonRank - the current master prestige level (between 56 and 1000)
  - data.mp.prestige - the current prestige
- (mp.json)
  - data.mp.lifetime.all.wlRatio - Win/Lose ratio
  - data.mp.lifetime.all.ekiadRatio - EKIA/Death ratio
  - data.mp.lifetime.all.kdRatio - Kill/Death ratio
  - data.mp.lifetime.all.statsMultikillMoreThan7 - Number of kill chains (1 = dark ops)
  - data.mp.lifetime.all.killstreak30NoScorestreaks - Number of nukes in FFA (1 = dark ops)
- (blackout.json)
  - data.mp.lifetime.all.winsWithoutKills - Wins without kill (1 = challenge)
  - data.mp.lifetime.all.topXPlacementPlayer - Number of top X alone (X can be 5, 10 or 25)
  - data.mp.lifetime.all.topXPlacementTeam - Number of top X in team (X can be 5, 10 or 25)
  - data.mp.lifetime.all.basketsMade - Baskets made using the Basketball (1 = dark ops)
  - data.mp.lifetime.itemData.misc.basketball.kills - Kills made using the Basketball (lmao)
- (zombies.json)
  - data.mp.lifetime.all.highestRoundReached - Max round
  - data.mp.lifetime.all.bgbsChewed - Elixirs drunk (100 = challenge)
  - data.mp.lifetime.all.talismanUsed - Talisman used (50 = challenge)
  - data.mp.lifetime.all.deaths - Number of death
  - data.mp.lifetime.all.kills - Number of kills (1M = Dark ops)

# Commands

## Fetch Prestige/Level icons

### Name

.\fetch_icons.ps1

### Synopsis

Export icons from the CDN

### Syntax

`.\fetch_icons.ps1 [[-ExportPath] <String>] [-CwIcons] [-MwIcons] [-Bo4Icons] [-WwiiIcons] [-OnlyPrestiges] [-AllGames] [-LittleIcons] [<CommonParameters>]`

### Description

Export the CoD Prestige/Level icons from the CDN

### Parameters

- `-ExportPath <String>`
  The path where to save the icons

- `-CwIcons`
  Download Black ops Cold War icons, included in AllGames

- `-MwIcons`
  Download Modern Warfare 2019 icons, included in AllGames

- `-Bo4Icons`
  Download Black ops 4 icons, included in AllGames

- `-WwiiIcons`
  Download World War II icons, included in AllGames

- `-OnlyPrestiges`
  Only download the prestige icons

- `-AllGames`
  Download all the icons from each games

- `-LittleIcons`
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

`.\cod_login.ps1 [[-Username] <String>] [[-Password] <SecureString>] [[-SaveFile] <String>] [-ReturnLoginInformation] [<CommonParameters>]`

### Description

Login to the Activision API and return login data into a file or in the pipeline

### Parameters

- `-Username <String>`
  The email/username to connect to your Activision account

- `-Password <SecureString>`
  A `SecureString` of your password to connect

- `-SaveFile <String>`
  By default "login_data.json", where the login data are saved, useless if the -ReturnLoginInformation is set

- `-ReturnLoginInformation`
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

`.\build_sso_websession.ps1 [[-loginData] <Object>] [[-SaveFile] <String>] [[-CookieDomain] <String>] [<CommonParameters>]`

### Description

Build a session from the cod_login.ps1 output

### Parameters

- `-loginData <Object>`
  Login data object, returned by cod_login.ps1 using the -ReturnLoginInformation switch

- `-SaveFile <String>`
  Login save file, returned by default by cod_login.ps1 without using the -ReturnLoginInformation switch

- `-CookieDomain <String>`
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

## Fetch Call of Duty stats

### Name

.\fetch_game_data.ps1

### Synopsis

Fetch Call of Duty stats of a player

### Syntax

`.\fetch_game_data.ps1 [[-UserName] <String>] [[-Platform] <String>] [[-Session] <Object>] [<CommonParameters>]`

### Description

Fetch Call of Duty stats of a player and output json, can fail if the user doesn't allow the share of his stats with the other

### Parameters

- `-UserName <String>`
  The username of the player

- `-Platform <String> = "xbl", "battle", "steam", "psn"`
  The platform of the user

- `-Title <String> = "bo4", "bo3", "cw", "mw", "iw", "ww2"`
  The title to fetch, by default Cold War (cw)

- `-Session <Object>`
  The session to connect, null to generate a new one

### Example

```powershell
PS>.\fetch_game_data.ps1 -UserName ATE48 -Platform xbl -Title bo4
Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/mp/ to output_account/xbl_ATE48_mp.json...
Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/blackout/ to output_account/xbl_ATE48_blackout.json...
Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/zombies/ to output_account/xbl_ATE48_zombies.json...
```

## Fetch items icons from json data

### Name

.\fetch_items_icons.ps1

### Synopsis

Fetch game items icon from JSON data

### Syntax

`.\fetch_items_icons.ps1 [-OutputAccountPath] <String[]> [-ExportPath <String>] [<CommonParameters>]`

### Description

Fetch game items icon from JSON data

### Parameters

- `-OutputAccountPath <String[]>`
  The json files

- `-ExportPath <String>`
  The path where to save the icons

### Example

```powershell
PS >.\fetch_items_icons.ps1  -OutputAccountPath ".\output_account\bo4\*_ATE48_*"
Downloading https://www.callofduty.com/cdn/app/icons/bo4/combatrecord/eq_acid_bomb.png into output_icons/bo4/items/equipment/eq_acid_bomb.png...
```

## Fetch items maps from json data

### Name

.\fetch_maps_icons.ps1

### Synopsis

Fetch game maps icon from JSON data

### Syntax

`.\fetch_maps_icons.ps1 [-OutputAccountPath] <String[]> [-ExportPath <String>] [<CommonParameters>]`

### Description

Fetch game items icon from JSON data

### Parameters

- `-OutputAccountPath <String[]>`
  The json files

- `-ExportPath <String>`
  The path where to save the icons

### Example

```powershell
PS >.\fetch_maps_icons.ps1  -OutputAccountPath ".\output_account\bo4\*_ATE48_*"
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_casino.jpg into output_icons/bo4/mp_casino.jpg...
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_elevation.jpg into output_icons/bo4/mp_elevation.jpg...
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_firingrange2.jpg into output_icons/bo4/mp_firingrange2.jpg...
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_frenetic.jpg into output_icons/bo4/mp_frenetic.jpg...
```

## Fetch map icons (Fast)

### Name

`.\download_maps_icons.ps1`

### Synopsis

Download all the maps icon from the CDN

### Syntax

`.\download_maps_icons.ps1 [[-Title] <Object>] [[-ExportPath] <String>] [-PrintNames] [<CommonParameters>]`

### Description

Download all the maps icon from the CDN
