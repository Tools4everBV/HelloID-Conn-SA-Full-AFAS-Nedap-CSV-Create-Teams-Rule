# AFAS API Parameters #
$token = $AfasToken;
$baseUri = $AfasBaseUri;

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

        $skip += 100
        while ($dataset.rows.count -ne 0) {
            $uri = $BaseUri + "/connectors/" + $Connector + "?skip=$skip&take=$take"

            $dataset = Invoke-RestMethod -Method Get -Uri $uri -Headers $Headers -UseBasicParsing

            $skip += 100

            foreach ($record in $dataset.rows) { [void]$data.Value.add($record) }
        }
    }
    catch {
        $data.Value = $null
        Write-Verbose $_.Exception -Verbose
    }
}


$organizationalUnits = New-Object System.Collections.ArrayList
Get-AFASConnectorData -Token $token -BaseUri $baseUri -Connector "T4E_HelloID_OrganizationalUnits" ([ref]$organizationalUnits) 
$afasLocations = $organizationalUnits | Select-Object ExternalId, DisplayName 

$employments = New-Object System.Collections.ArrayList
Get-AFASConnectorData -Token $token -BaseUri $baseUri -Connector "T4E_HelloID_Employments" ([ref]$employments)
$employments = $employments | Select-Object Functie_code, Functie_omschrijving #| Group-Object Persoonsnummer -AsHashTable

if($true -eq $includePositions)
{
    $positions = New-Object System.Collections.ArrayList
    Get-AFASConnectorData -Token $token -BaseUri $baseUri -Connector "T4E_HelloID_Positions" ([ref]$positions)
    $positions = $positions | Select-Object Functie_code, Functie_omschrijving #| Group-Object Persoonsnummer -AsHashTable
}

    if($true -eq $includePositions)
    {
        $employments += $positions
    }
    


$afasEmployments = $employments | Sort-Object Functie_Code -Unique 

ForEach($r in $employments)
        {
            #Write-Output $Site 
            $returnObject = @{ FunctionId=$r.Functie_Code; JobTitle=$r.Functie_omschrijving }
            Write-Output $returnObject                
        }
