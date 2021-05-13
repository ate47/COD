<#
.SYNOPSIS
	Login to the Activision API
.DESCRIPTION
	Login to the Activision API and return login data into a file or in the pipeline
.EXAMPLE
	PS> $pass = Read-Host -AsSecureString
	******************
	PS> .\cod_login.ps1 -Username "mymail@example.org" -Password $pass
	Register DEVICE_ID '****'...
	Login...
	Writing login tokens into 'login_data.json'
.PARAMETER Username
	The email/username to connect to your Activision account
.PARAMETER Password
	A [SecureString] of your password to connect
.PARAMETER SaveFile
	By default "login_data.json", where the login data are saved, useless if the -ReturnLoginInformation is set
.PARAMETER ReturnLoginInformation
	Return the login information into the pipeline

#>
param(
	[string]
	$Username,
	[SecureString]
	$Password,
	[string]
	$SaveFile = "login_data.json",
	[switch]
	$ReturnLoginInformation
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
	return $null
}

$loginResponseData = [PSCustomObject]@{
	"login_response" = $loginResponse
	"device_id" = $deviceId
}

if ($ReturnLoginInformation) {
	return $loginResponseData
} else {
	Write-Host "Writing login tokens into '$SaveFile'"
	$loginResponseData | ConvertTo-Json | Out-File $SaveFile -Encoding utf8
}
