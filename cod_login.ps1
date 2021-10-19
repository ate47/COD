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
	$SSOToken,
	[string]
	$SaveFile = "login_data.json",
	[switch]
	$ReturnLoginInformation
)

$links = @{
	"sso"               = "https://profile.callofduty.com/cod/mapp/"
	"ssoLogin"          = "https://profile.callofduty.com/cod/mapp/login"
	"ssoRegisterDevice" = "https://profile.callofduty.com/cod/mapp/registerDevice"
}

$userArgent = "cod-ate-worker"
$deviceData = (.\fetch_auth_header.ps1)

if ($null -eq $deviceData) {
	return $null
}

$deviceId = $deviceData.deviceId
$authHeader = $deviceData.authHeader

if ($null -eq $SSOToken) {
	if ($null -eq $Username -or "" -eq $Username) {
		$Username = Read-Host "Username"
	}
	if ($null -eq $Password) {
		$Password = Read-Host "Password" -AsSecureString
	}

	Write-Host "Connect using credentials..."

	$PlainPW = $Password | ConvertFrom-SecureString -AsPlainText

	$CodSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
	$CodSession.Headers.Add("Authorization", "Bearer $authHeader")
	$CodSession.Headers.Add("X_COD_DEVICE_ID", $deviceId)
	$CodSession.Cookies.Add([System.Net.Cookie]::new("XSRF-TOKEN", "68e8b62e-1d9d-4ce1-b93f-cbe5ff31a041", "/", "profile.callofduty.com"))
	$CodSession.Cookies.Add([System.Net.Cookie]::new("API_CSRF_TOKEN", " 68e8b62e-1d9d-4ce1-b93f-cbe5ff31a041", "/", "profile.callofduty.com"))
	$CodSession.Cookies.Add([System.Net.Cookie]::new("country", "US", "/", "profile.callofduty.com"))
	$CodSession.Cookies.Add([System.Net.Cookie]::new("ACT_SSO_LOCALE", "US", "/", "profile.callofduty.com"))
	$CodSession.Cookies.Add([System.Net.Cookie]::new("new_SiteId", "cod", "/", "profile.callofduty.com"))
	$CodSession.UserAgent = $userArgent

	Write-Host "Login..."

	$dataLogin = [PSCustomObject]@{
		"email"    = $Username
		"password" = $PlainPW
	} | ConvertTo-Json

	$loginResponse = ((Invoke-WebRequest -Uri ($links.ssoLogin) -WebSession $CodSession -ContentType "application/json" -Method Post -Body $dataLogin).Content | ConvertFrom-Json)

	if (!$loginResponse.success) {
		Write-Host "Can't connect: $($loginResponse.token)"
		return $null
	}

	$SSOToken = $loginResponse.ACT_SSO_COOKIE
}

$loginResponseData = [PSCustomObject]@{
	"login_response" = [PSCustomObject]@{
		"ACT_SSO_COOKIE" = $SSOToken
	}
	"auth_header"    = $authHeader
	"device_id"      = $deviceId
}

if ($ReturnLoginInformation) {
	return $loginResponseData
}
else {
	Write-Host "Writing login tokens into '$SaveFile'"
	$loginResponseData | ConvertTo-Json | Out-File $SaveFile -Encoding utf8
}
