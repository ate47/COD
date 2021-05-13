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
		} else {
			Write-Error "'$SaveFile' doesn't exist or can't be read."
			Exit -1
		}
	} else {
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
$CodSession.Cookies.Add([System.Net.Cookie]::new("rtkn", $loginResponse.rtkn, "/", $CookieDomain))
$CodSession.Cookies.Add([System.Net.Cookie]::new("ACT_SSO_COOKIE", $loginResponse.s_ACT_SSO_COOKIE, "/", $CookieDomain))
$CodSession.Cookies.Add([System.Net.Cookie]::new("atkn", $loginResponse.atkn, "/", $CookieDomain))
$CodSession.UserAgent = $UserArgent

return $CodSession