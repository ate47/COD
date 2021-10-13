param(
    [Parameter(Mandatory)]
    [ValidateSet("xbl", "battle", "steam", "psn")]
    [string]
    $Platform,
    [switch]
    $NotCompileUmbrellaState
)

$links = @{
    thirdPartyAuth = "https://profile.callofduty.com/cod/thirdPartyAuth/init"
}


$stateResponse = Invoke-WebRequest "$($links.thirdPartyAuth)/$Platform" -MaximumRedirection 0 -SkipHttpErrorCheck 2> $null

$umbrellaLocation = $stateResponse.Headers.Location

if ($null -eq $umbrellaLocation) {
    Write-Host "Can't fetch Umbrella location: $($stateResponse.StatusCode)"
    return $null
}
$umbrellaData = [System.Web.HttpUtility]::ParseQueryString([uri]::new($umbrellaLocation).Query)


$UmbrellaState = @{
    client       = $umbrellaData.Get("client")
    client_state = $umbrellaData.Get("state")
    return_url   = $umbrellaData.Get("returnURL")
}

if ($NotCompileUmbrellaState) {
    return $UmbrellaState
}

$jsonState = ConvertTo-Json $UmbrellaState

return [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($jsonState))
