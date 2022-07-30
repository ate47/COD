<#
.SYNOPSIS
	Export icons from the CDN
.DESCRIPTION
	Export the CoD Prestige/Level icons from the CDN
.EXAMPLE
	./fetch_icons.ps1 -AllGames
.EXAMPLE
	./fetch_icons.ps1 -Bo4Icons -OnlyPrestiges -LittleIcons
.PARAMETER ExportPath
	The path where to save the icons
.PARAMETER CwIcons
	Download Black ops Cold War icons, included in AllGames
.PARAMETER MwIcons
	Download Modern Warfare 2019 icons, included in AllGames
.PARAMETER Bo4Icons
	Download Black ops 4 icons, included in AllGames
.PARAMETER WwiiIcons
	Download World War II icons, included in AllGames
.PARAMETER OnlyPrestiges
	Only download the prestige icons
.PARAMETER AllGames
	Download all the icons from each games
.PARAMETER LittleIcons
	Download non large icons (if available)

#>
param(
	[string]
	$ExportPath = "output_icons",
	[switch]
	$CwIcons,
	[switch]
	$MwIcons,
	[switch]
	$Bo4Icons,
	[switch]
	$WwiiIcons,
	[switch]
	$OnlyPrestiges,
	[switch]
	$AllGames,
	[switch]
	$LittleIcons
)

$Indexes = @()

function Add-Index {
	param (
		$Uri, 
		$Id, 
		$MaxLvl, 
		$Largeable = $true
	)
	$script:Indexes += @{
		"Uri"       = $Uri
		"Id"        = $Id
		"MaxLvl"    = $MaxLvl
		"Largeable" = $Largeable
	}
}

# Call of Duty: Black Ops Cold War

if ($AllGames -or $CwIcons) {
	Add-Index "cw/prestige/mp/ui_icon_mp_prestige_" "cw/pre" 27 $false
	if (!$OnlyPrestiges) {
		Add-Index "cw/ranks/mp/icon_rank_" "cw/lvl" 55 $false
	}
}

# Call of Duty: Modern Warfare 2019

if ($AllGames -or $MwIcons) {
	Add-Index "mw/officer/mp/icon_rank_officer_" "mw/mp_pre" 20 $false
	if (!$OnlyPrestiges) {
		Add-Index "mw/ranks/mp/icon_rank_" "mw/mp_lvl" 155 $false
	}
}

# Call of Duty: Black Ops 4
if ($AllGames -or $Bo4Icons) {
	Add-Index "bo4/prestige/mp/ui_icon_mp_prestige_" "bo4/mp_pre" 11
	Add-Index "bo4/prestige/zm/ui_icon_zm_prestige_" "bo4/zm_pre" 11
	Add-Index "bo4/prestige/wz/ui_icon_wz_prestige_" "bo4/wz_pre" 11
	if (!$OnlyPrestiges) {
		Add-Index "bo4/ranks/mp/ui_icon_rank_mp_level" "bo4/mp_lvl" 55
		Add-Index "bo4/ranks/wz/ui_icon_rank_wz_level" "bo4/wz_lvl" 80
		Add-Index "bo4/ranks/zm/ui_icon_rank_zm_level" "bo4/zm_lvl" 55
	}
}

# Call of Duty: World War II

if ($AllGames -or $WwiiIcons) {
	Add-Index "wwii/prestige/mp/ui_icon_mp_prestige_" "wwii/mp_pre" 11
	if (!$OnlyPrestiges) {
		Add-Index "wwii/ranks/mp/ui_icon_rank_mp_level" "wwii/mp_lvl" 55
	}
}


New-Item -ItemType Directory $ExportPath -Force > $null

foreach ($i in $Indexes) {
	$Uri = $i.Uri
	$Id = $i.Id
	$MaxLevel = $i.MaxLvl
	
	if (!$LittleIcons -and $i.Largeable) {
		$Size = "_large"
	}
	else {
		$Size = ""
	}
	New-Item -ItemType Directory "$ExportPath/$Id" -Force > $null

	for ($Lvl = 1; $Lvl -le $MaxLevel; $Lvl++) {
		$url = "https://www.callofduty.com/cdn/app/icons/{0}{1:d2}{2}.png" -f ($Uri, $Lvl, $Size)
		$file = "$ExportPath/$Id/$Lvl$Size.png"
		Write-Host "Downloading $url into $file..."
		Invoke-WebRequest -Uri $url -OutFile $file > $null
	}

}