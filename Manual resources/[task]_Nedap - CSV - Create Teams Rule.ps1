$afasFunctionCode = $form.afasJobTitles.FunctionId
$afasLocationId = $form.afasOrgUnits.Id
$nedapTeamsIds = $form.nedapTeams.toJsonString

$path = $NedapOnsTeamsMappingPath

$afasLocation = $afasLocationId
$nedapTeams = $nedapTeamsIds | ConvertFrom-Json
$afasFunctionCode = $afasFunctionCode

foreach ($n in $nedapTeams) {
    $nedapTeamString = $nedapTeamString + $n.Id.ToString() + ","
}

$nedapTeamString = $nedapTeamString.Substring(0, $nedapTeamString.Length - 1)

$rule = [PSCustomObject]@{
    "Department.ExternalId" = $afasLocation
    "Title.ExternalId"      = $afasFunctionCode
    "NedapTeamId"           = $nedapTeamString
}

$rule | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | ForEach-Object { $_ -replace '"', "" }  | Select-Object -Skip 1  | Add-Content $path -Encoding UTF8

$Log = @{
    Action            = "Undefined" # optional. ENUM (undefined = default) 
    System            = "NedapOns" # optional (free format text) 
    Message           = "Added teams rule for department [$afasLocation] and optional title [$afasFunctionCode] to Nedap team id(s) [$nedapTeamString] to mapping file [$path]" # required (free format text) 
    IsError           = $false # optional. Elastic reporting purposes only. (default = $false. $true = Executed action returned an error) 
    TargetDisplayName = "$path" # optional (free format text) 
    TargetIdentifier  = "" # optional (free format text) 
}
#send result back  
Write-Information -Tags "Audit" -MessageData $log
