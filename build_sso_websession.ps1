<#
.SYNOPSIS
	Build a session from the cod_login.ps1 output
.DESCRIPTION
	Build a session from the cod_login.ps1 output
.EXAMPLE
	PS> .\build_sso_websession.ps1
	Headers                : {[Authorization, bearer ****], [X_COD_DEVICE_ID, ****]}
	Cookies                : System.Net.CookieContainer
	UseDefaultCredentials  : False
	Credentials            :
	Certificates           :
	UserAgent              : cod-ate-worker
	Proxy                  :
	MaximumRedirection     : -1
	MaximumRetryCount      : 0
	RetryIntervalInSeconds : 0


.PARAMETER loginData
	Login data object, returned by cod_login.ps1 using the -ReturnLoginInformation switch
.PARAMETER SaveFile
	Login save file, returned by default by cod_login.ps1 without using the -ReturnLoginInformation switch
.PARAMETER CookieDomain
	The domain to match the cookies of the WebSession
#>
param(
	$loginData,
	[string]
	$SaveFile = "login_data.json",
	[string]
	$CookieDomain = "profile.callofduty.com"
)

if ($null -eq $loginData) {
	if ($null -ne $SaveFile) {
		$loginRaw = Get-Content $SaveFile
		if ($loginRaw) {
			$loginData = $loginRaw | ConvertFrom-Json
			if ($null -eq $loginData) {
				Write-Error "Can't read '$SaveFile', bad json?"
				Exit -1
			}
		}
		else {
			Write-Error "'$SaveFile' doesn't exist or can't be read."
			Exit -1
		}
	}
 else {
		Write-Error "`$loginData and `$SaveFile can't both be null."
		Exit -1
	}
}


$loginResponse = $loginData.login_response
$authHeader = $loginData.auth_header
$deviceId = $loginData.device_id

$UserArgent = "cod-ate-worker"

$CodSession = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
$CodSession.Headers.Add("Authorization", "bearer $authHeader")
$CodSession.Headers.Add("X_COD_DEVICE_ID", $deviceId)
$CodSession.Cookies.Add([System.Net.Cookie]::new("ACT_SSO_COOKIE", $loginResponse.ACT_SSO_COOKIE, "/", $CookieDomain))
$CodSession.UserAgent = $UserArgent

return $CodSession