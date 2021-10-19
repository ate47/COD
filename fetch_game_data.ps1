<#
.SYNOPSIS
	Fetch Call of Duty stats of a player
.DESCRIPTION
	Fetch Call of Duty stats of a player and output json, can fail if the user doesn't allow the share of his stats with the other
.EXAMPLE
	PS> .\fetch_bo4_data.ps1 -UserName ATE48 -Platform xbl
	Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/mp/ to output_account/xbl_ATE48_mp.json...
	Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/blackout/ to output_account/xbl_ATE48_blackout.json...
	Saving data https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/xbl/gamer/ATE48/profile/type/zombies/ to output_account/xbl_ATE48_zombies.json...


.PARAMETER UserName
	The username of the player
.PARAMETER Platform
	The platform of the user
.PARAMETER Session
	The session to connect, null to generate a new one
#>
param(
	[string]
	$UserName,
	[ValidateSet("xbl", "battle", "steam", "psn")]
	[string]
	$Platform,
	[ValidateSet("bo4", "bo3", "cw", "mw", "iw", "ww2")]
	$title = "cw",
	$Session
)

if ("bo4" -eq $title) {
	$Modes = @(
		"mp", "blackout", "zombies"
	)
}
elseif ("cw" -eq $title -or "bo3" -eq $title) {
	$Modes = @(
		"mp", "zombies"
	)
}
elseif ("mw" -eq $title) {
	$Modes = @(
		"wz", "mp"
	)
}
else {
	$Modes = @(
		"mp"
	)
}


if ($null -eq $Session) {
	$Session = ./build_sso_websession.ps1 -CookieDomain "my.callofduty.com"

	if ($null -eq $Session) {
		Write-Error "Can't get session"
		Exit -1
	}
}

New-Item -ItemType Directory "output_account/$title" -Force > $null

foreach ($Mode in $Modes) {
	$name = "output_account/$title/$($Platform)_$($Username)_$Mode.json"
	$uri = "https://my.callofduty.com/api/papi-client/stats/cod/v1/title/$title/platform/$Platform/gamer/$UserName/profile/type/$Mode/"
	Write-Host "Saving data $uri to $name..."
	$json = (Invoke-WebRequest -Uri $uri -WebSession $Session).Content | ConvertFrom-Json -Depth 8
	$json | ConvertTo-Json -Depth 8 | Out-File -Encoding utf8 $name > $null
}
