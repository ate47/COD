param(
    [string]
    $WeaponFile,
    [string]
    $title,
    [string]
    $ExportPath = "output_icons",
    [bool]
    $force
)

$output = "$ExportPath/$title/items"

New-Item -ItemType Directory $output -Force > $null

Get-Content $WeaponFile | ConvertFrom-Json | ForEach-Object {
    $item = $_
    
    $url = "https://www.callofduty.com/cdn/app/icons/$title/combatrecord/$item.png"
    $file = "$output/$item.png"
    if (($force) -or !(Test-Path $file)) {
        Write-Host "Downloading $url into $file..."
        Invoke-WebRequest -Uri $url -OutFile $file > $null
    }
}