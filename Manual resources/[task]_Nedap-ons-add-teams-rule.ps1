$Path = $NedapOnsTeamsMappingPath

$afasLocation = $afasLocationId
$nedapTeams = $nedapTeamsIds | ConvertFrom-Json
$afasFunctionCode = $afasFunctionCode

foreach ($n in $nedapTeams) {
    $nedapTeamString = $nedapTeamString + $n.Id.ToString() + ","
}

$nedapTeamString = $nedapTeamString.Substring(0, $nedapTeamString.Length - 1)

$rule = [PSCustomObject]@{
    "Department.ExternalId" = $afasLocation;
    "Title.ExternalId"      = $afasFunctionCode;
    "NedapTeamId"           = $nedapTeamString;
}

$rule | ConvertTo-Csv -NoTypeInformation -Delimiter ";" | ForEach-Object { $_ -replace '"', "" }  | Select-Object -Skip 1  | Add-Content $Path -Encoding UTF8