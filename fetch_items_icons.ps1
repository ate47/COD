<#
.SYNOPSIS
	Fetch game items icon from JSON data
.DESCRIPTION
	Fetch game items icon from JSON data
.EXAMPLE
PS > .\fetch_items_icons.ps1  -OutputAccountPath ".\output_account\bo4\*_ATE48_*"
Downloading https://www.callofduty.com/cdn/app/icons/bo4/combatrecord/eq_acid_bomb.png into output_icons/bo4/items/equipment/eq_acid_bomb.png...
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
	$sets = ($data.data.mp.lifetime.itemData | Get-Member -MemberType NoteProperty).Name
	
	New-Item -ItemType Directory "$ExportPath/$title/items" -Force > $null

	foreach ($set in $sets) {
		$items = ($data.data.mp.lifetime.itemData.($set) | Get-Member -MemberType NoteProperty).Name
		New-Item -ItemType Directory "$ExportPath/$title/items/$set" -Force > $null
		foreach ($item in $items) {
			$url = "https://www.callofduty.com/cdn/app/icons/$title/combatrecord/$item.png"
			$file = "$ExportPath/$title/items/$set/$item.png"
			Write-Host "Downloading $url into $file..."
			Invoke-WebRequest -Uri $url -OutFile $file > $null
		}
	}
}
