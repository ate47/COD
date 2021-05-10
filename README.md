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