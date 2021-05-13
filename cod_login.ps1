param(
	[string]
	$Username,
	[SecureString]
	$Password,
	[string]
	$SaveFile = "login_data.json"
)

$links = @{
	"sso" = "https://profile.callofduty.com/cod/mapp/"
	"ssoLogin" = "https://profile.callofduty.com/cod/mapp/login"
	"ssoRegisterDevice" = "https://profile.callofduty.com/cod/mapp/registerDevice"
}

$deviceId = New-Guid
$userArgent = New-Guid

if ($null -eq $Username -or "" -eq $Username) {
	$Username = Read-Host "Username"
}
if ($null -eq $Password) {
	$Password = Read-Host "Password" -AsSecureString
}

$PlainPW = $Password | ConvertFrom-SecureString -AsPlainText

Write-Host "Register DEVICE_ID '$deviceId'..."

$CodSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()

$dataDevice = [PSCustomObject]@{
	"deviceId" = $deviceId
} | ConvertTo-Json

$registerDeviceResponse = ((Invoke-WebRequest -Uri ($links.ssoRegisterDevice) -WebSession $CodSession -ContentType "application/json" -Method Post -Body $dataDevice).Content | ConvertFrom-Json)

$authHeader = $registerDeviceResponse.data.authHeader

$CodSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
$CodSession.Headers.Add("Authorization", "bearer $authHeader")
$CodSession.Headers.Add("X_COD_DEVICE_ID", $deviceId)
$CodSession.Cookies.Add([System.Net.Cookie]::new("XSRF-TOKEN", "68e8b62e-1d9d-4ce1-b93f-cbe5ff31a041", "/", "profile.callofduty.com"))
$CodSession.Cookies.Add([System.Net.Cookie]::new("API_CSRF_TOKEN"," 68e8b62e-1d9d-4ce1-b93f-cbe5ff31a041", "/", "profile.callofduty.com"))
$CodSession.UserAgent = $userArgent
# $CodSession.Headers.Add("x-requested-with", $userAgent)

Write-Host "Login..."

$dataLogin = [PSCustomObject]@{
	"email" = $Username
	"password" = $PlainPW
} | ConvertTo-Json

$loginResponse = ((Invoke-WebRequest -Uri ($links.ssoLogin) -WebSession $CodSession -ContentType "application/json" -Method Post -Body $dataLogin).Content | ConvertFrom-Json)


if (!$loginResponse.success) {
	Write-Host "Bad username or password"
	Exit -1
}

Write-Host "Writing login tokens into '$SaveFile'"
$loginResponse | ConvertTo-Json | Out-File $SaveFile -Encoding utf8