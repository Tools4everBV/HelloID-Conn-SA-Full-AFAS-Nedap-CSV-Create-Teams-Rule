# AFAS API Parameters #
$token = $AfasToken;
$baseUri = $AfasBaseUri;
$includePositions = $false;

<#--------- AFAS script ----------#>
# Default function to get paged connector data
function Get-AFASConnectorData {
    param(
        [parameter(Mandatory = $true)]$Token,
        [parameter(Mandatory = $true)]$BaseUri,
        [parameter(Mandatory = $true)]$Connector,
        [parameter(Mandatory = $true)][ref]$data
    )

    try {
        $encodedToken = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($Token))
        $authValue = "AfasToken $encodedToken"
        $Headers = @{ Authorization = $authValue }

        $take = 100
        $skip = 0

        $uri = $BaseUri + "/connectors/" + $Connector + "?skip=$skip&take=$take"
        $dataset = Invoke-RestMethod -Method Get -Uri $uri -Headers $Headers -UseBasicParsing

        foreach ($record in $dataset.rows) { [void]$data.Value.add($record) }

        $skip += $take
        while (@($dataset.rows).count -eq $take) {
            $uri = $BaseUri + "/connectors/" + $Connector + "?skip=$skip&take=$take"

            $dataset = Invoke-RestMethod -Method Get -Uri $uri -Headers $Headers -UseBasicParsing

            $skip += $take

            foreach ($record in $dataset.rows) { [void]$data.Value.add($record) }
        }
    }
    catch {
        $data.Value = $null
        Write-Verbose $_.Exception -Verbose
    }
}

$employments = New-Object System.Collections.ArrayList
Get-AFASConnectorData -Token $token -BaseUri $baseUri -Connector "T4E_HelloID_Employments" ([ref]$employments)
$employments = $employments | Select-Object Functie_code, Functie_omschrijving #| Group-Object Persoonsnummer -AsHashTable

if ($true -eq $includePositions) {
    $positions = New-Object System.Collections.ArrayList
    Get-AFASConnectorData -Token $token -BaseUri $baseUri -Connector "T4E_HelloID_Positions" ([ref]$positions)
    $positions = $positions | Select-Object Functie_code, Functie_omschrijving #| Group-Object Persoonsnummer -AsHashTable

    $employments += $positions
}
    
$afasEmployments = $employments | Sort-Object Functie_Code -Unique 

ForEach ($r in $afasEmployments) {
    #Write-Output $Site 
    $returnObject = @{ FunctionId = $r.Functie_Code; JobTitle = $r.Functie_omschrijving }
    Write-Output $returnObject                
}
