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
    $PrintNames,
    [switch]
    $FetchAll
)

$uri = "https://my.callofduty.com/api/papi-client/ce/v1/title/$Title/platform/xbl/gameType/mp/communityMapData/availability"

$mapData = ((Invoke-WebRequest -Uri $uri).Content | ConvertFrom-Json).data
$maps = $mapData | Get-Member -MemberType NoteProperty | ForEach-Object { $_.Name }

Write-Host "Found $($maps.Count) maps"

New-Item -ItemType Directory $ExportPath -Force > $null

$mapDir = "$ExportPath/$Title/maps/"
$maps | ForEach-Object {
    $map = $_
    $data = $mapData.$map
    $mapUri = "https://my.callofduty.com/cdn/app/base-maps/$Title/$map.jpg"
    if (!$PrintNames) {
        $mapStatsDir = "$mapDir/$map"
        New-Item -Type Directory $mapStatsDir -ErrorAction Ignore
        Write-Host "Download $map from $mapUri"
        $file = "$mapStatsDir/$map.jpg"
        Invoke-WebRequest -Uri $mapUri -OutFile $file > $null
        if ($FetchAll) {
            $compassDownloaded = $false
            $data | ForEach-Object {
                $mode = $_
                $mapStatsUri = "https://www.callofduty.com/api/papi-client/ce/v1/title/$Title/platform/xbl/gameType/mp/map/$map/mode/$mode/communityMapData"
                Write-Host "Download $map stats from $mapStatsUri"
                $mapStatsFile = "$mapStatsDir/stats_$mode.json"
                $mapStatsData = ((Invoke-WebRequest -Uri $mapStatsUri).Content | ConvertFrom-Json -Depth 100).data
                $mapStatsData | ConvertTo-Json -Depth 100 > $mapStatsFile
                if (!$compassDownloaded) {
                    $compassUrl = "https://www.callofduty.com/cdn/app/maps/$Title/$($mapStatsData.map.imageUrl)"
                    Write-Host "Download $map compass from $compassUrl"
                    $compassFile = "$mapStatsDir/$($mapStatsData.map.imageUrl)"
                    Invoke-WebRequest -Uri $compassUrl -OutFile $compassFile > $null
                    $compassDownloaded = $true
                }
            }
        }
    }
    else {
        [PSCustomObject]@{
            "id"  = $map
            "uri" = $mapUri
        }
    }
}
