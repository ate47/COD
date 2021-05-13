param(
	[string]
	$UserName,
	[ValidateSet("xbl", "battle", "steam", "psn")]
	[string]
	$Platform,
	$Session
)

$Modes = @(
	"mp", "blackout", "zombies"
)

if ($null -eq $Session) {
	$Session = ./build_sso_websession.ps1 -CookieDomain "my.callofduty.com"

	if ($null -eq $Session) {
		Write-Error "Can't get session"
		Exit -1
	}
}

New-Item -ItemType Directory output_account -Force > $null

foreach ($Mode in $Modes) {
	$name = "output_account/$($Platform)_$($Username)_$Mode.json"
	$uri = "https://my.callofduty.com/api/papi-client/crm/cod/v2/title/bo4/platform/$Platform/gamer/$UserName/profile/type/$Mode/"
	Write-Host "Saving data $uri to $name..."
	$json = (Invoke-WebRequest -Uri $uri -WebSession $Session).Content | ConvertFrom-Json -Depth 8
	$json | ConvertTo-Json -Depth 8 | Out-File -Encoding utf8 $name > $null
}
