param (
    $DeviceId = $null
)


if ($null -eq $DeviceId) {
    $DeviceId = New-Guid
}


$links = @{
    "ssoRegisterDevice" = "https://profile.callofduty.com/cod/mapp/registerDevice"
}

Write-Host "Register DEVICE_ID '$deviceId'..."

$CodSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
$CodSession.Cookies.Add([System.Net.Cookie]::new("XSRF-TOKEN", "68e8b62e-1d9d-4ce1-b93f-cbe5ff31a041", "/", "profile.callofduty.com"))
$CodSession.Cookies.Add([System.Net.Cookie]::new("country", "US", "/", "profile.callofduty.com"))
$CodSession.Cookies.Add([System.Net.Cookie]::new("ACT_SSO_LOCALE", "US", "/", "profile.callofduty.com"))
$CodSession.Cookies.Add([System.Net.Cookie]::new("new_SiteId", "cod", "/", "profile.callofduty.com"))

$dataDevice = [PSCustomObject]@{
    "deviceId" = $deviceId
} | ConvertTo-Json

$registerDeviceResponse = ((Invoke-WebRequest -Uri ($links.ssoRegisterDevice) -WebSession $CodSession -ContentType "application/json" -Method Post -Body $dataDevice).Content | ConvertFrom-Json)

if ("success" -ne ($registerDeviceResponse.status)) {
    Write-Error "Can't register device: $(registerDeviceResponse.status)" -Category CloseError
    return $null
}

return @{
    authHeader = $registerDeviceResponse.data.authHeader
    deviceId   = $DeviceId
}

