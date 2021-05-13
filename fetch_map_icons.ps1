<#
.SYNOPSIS
	Fetch game maps icon from JSON data
.DESCRIPTION
	Fetch game maps icon from JSON data
.EXAMPLE
PS> .\fetch_map_icons.ps1  -OutputAccountPath ".\output_account\*_ATE48_*"
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_casino.jpg into output_icons/bo4/mp_casino.jpg...
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_elevation.jpg into output_icons/bo4/mp_elevation.jpg...
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_firingrange2.jpg into output_icons/bo4/mp_firingrange2.jpg...
Downloading https://www.callofduty.com/cdn/app/base-maps/bo4/mp_frenetic.jpg into output_icons/bo4/mp_frenetic.jpg...
...
.PARAMETER ExportPath
	The path where to save the icons
#>
param(
	[Parameter(Mandatory=$true,
			   Position=0,
			   ParameterSetName="OutputAccountPath",
			   ValueFromPipeline=$true,
			   ValueFromPipelineByPropertyName=$true,
			   HelpMessage="Path to one or more output_account.")]
	[ValidateNotNullOrEmpty()]
	[SupportsWildcards()]
	[string[]]
	$OutputAccountPath,
	[string]
	$ExportPath = "output_icons"
)

New-Item -ItemType Directory $ExportPath -Force > $null

foreach ($file in (Get-ChildItem -Path $OutputAccountPath)) {
	$data = Get-Content $file | ConvertFrom-Json -Depth 8
	$title = $data.data.title
	$maps = ($data.data.mp.lifetime.map | Get-Member -MemberType NoteProperty).Name
	
	New-Item -ItemType Directory "$ExportPath/$title/maps" -Force > $null

	foreach ($map in $maps) {
		$url = "https://www.callofduty.com/cdn/app/base-maps/$title/$map.jpg"
		$file = "$ExportPath/$title/maps/$map.jpg"
		Write-Host "Downloading $url into $file..."
		Invoke-WebRequest -Uri $url -OutFile $file > $null
	}
}
