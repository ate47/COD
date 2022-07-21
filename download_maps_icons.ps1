<#
.SYNOPSIS
	Download all the maps icon from the CDN
.DESCRIPTION
	Download all the maps icon from the CDN
.EXAMPLE
	./fetch_icons.ps1 -Title bo4
.EXAMPLE
	./fetch_icons.ps1 -Title bo4 -PrintNames
.PARAMETER Title
	Game title (bo4, cw, etc.)
.PARAMETER PrintNames
	Only print the names and uri

#>
param(
    $Title = "cw",
    [string]
    $ExportPath = "output_icons",
    [switch]
    $PrintNames
)

$uri = "https://my.callofduty.com/api/papi-client/ce/v1/title/$Title/platform/xbl/gameType/mp/communityMapData/availability"

$maps = ((Invoke-WebRequest -Uri $uri).Content | ConvertFrom-Json).data | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name }

Write-Host "Found $($maps.Count) maps"

New-Item -ItemType Directory $ExportPath -Force > $null

$mapDir = "$ExportPath/maps/"
New-Item -Type Directory $mapDir -ErrorAction Ignore
$maps | ForEach-Object {
    $map = $_
    $mapUri = "https://my.callofduty.com/cdn/app/base-maps/$Title/$map.jpg"
    if (!$PrintNames) {
        Write-Host "Download $map from $mapUri"
        $file = "$mapDir/$map.jpg"
        Invoke-WebRequest -Uri $mapUri -OutFile $file > $null
    }
    else {
        [PSCustomObject]@{
            "id"  = $map
            "uri" = $mapUri
        }
    }
}
