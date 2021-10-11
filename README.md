<!-- Description -->
## Description
With this HelloID Service Automation Delegated Form you can add mapping rules to a CSV for Nedap. The CSV contains rules in which AFAS Organisational Units are mapped to Nedap Teams. Optional a AFAS jobtitle can be combined in the mapping. The following options are available:
 1. Search AFAS organisational unit
 2. Select AFAS jobtitle (optional)
 3. Select the Nedap team to map
 4. Confirm the changes
 
<!-- TABLE OF CONTENTS -->
## Table of Contents
* [Description](#description)
* [All-in-one PowerShell setup script](#all-in-one-powershell-setup-script)
  * [Getting started](#getting-started)
* [Pre-setup configuration](#pre-setup-configuration)
  * [Requirements](#requirements)
* [Post-setup configuration](#post-setup-configuration)
* [Manual resources](#manual-resources)


## All-in-one PowerShell setup script
The PowerShell script "createform.ps1" contains a complete PowerShell script using the HelloID API to create the complete Form including user defined variables, tasks and data sources.

 _Please note that this script asumes none of the required resources do exists within HelloID. The script does not contain versioning or source control_

### Getting started
Please follow the documentation steps on [HelloID Docs](https://docs.helloid.com/hc/en-us/articles/360017556559-Service-automation-GitHub-resources) in order to setup and run the All-in one Powershell Script in your own environment.

## Pre-setup configuration
These forms can only be used when Nedap ONS user provisioning is provided by HelloID provisioning and AFAS is your sourcesystem. Therefore it is also necessary that the files in which the organisational units are mapped with the locations and the teams are available on the server. These mapping files can be found in the [HelloID-Conn-Prov-Target-NedapONS-Users](https://github.com/Tools4everBV/HelloID-Conn-Prov-Target-NedapONS-Users#helloid-conn-prov-target-nedapons-users).

Be aware that using Service Automation forms can have an impact on the licenses and impact the pay-as-you-go subscriptions! 

### Requirements
<table>
	<tr><td>AFAS as a sourcesystem within HelloID provisioning</td><tr>
	<tr><td>Nedap ONS users as a targetsystem within HelloID provisioning</td><tr>
	<tr><td>HelloID Service Automation license</td><tr>
</table>
 
 
## Post-setup configuration
After the all-in-one PowerShell script has run and created all the required resources. The following items need to be configured according to your own environment
 1. Update the following [user defined variables](https://docs.helloid.com/hc/en-us/articles/360014169933-How-to-Create-and-Manage-User-Defined-Variables)
<table>
  <tr><td><strong>Variable name</strong></td><td><strong>Example value</strong></td><td><strong>Description</strong></td></tr>
  <tr><td>NedapOnsConnectionUrl</td><td>https://api-staging.ons.io</td><td>Nedap Environment URL</td></tr>
  <tr><td>NedapOnsCertificatePassword</td><td>********</td><td>Nedap Certificate Password</td></tr>
  <tr><td>NedapOnsCertificatePFX</td><td>c:/folder/certificate.pfx</td><td>Full path of the Nedap certificate on the HelloID agent server</td></tr>
  <tr><td>NedapOnsTeamsMappingPath</td><td>c:/folder/oucode_teamid.csv</td><td>Full path of the Organisational Unit - Nedap Team mapping file</td></tr>
  <tr><td>AfasBaseUri</td><td>https://<environmentcode>.rest.afas.online/profitrestservices</td><td>AFAS Environment URL</td></tr>
  <tr><td>AfasToken</td><td>********</td><td>AFAS Environment Tokencode</td></tr>
</table>

## Manual resources
This Delegated Form uses the following resources in order to run

### Powershell data source '[powershell-datasource]_Nedap-ons-csv-afas-job-titles-teams-rules-create'
This Powershell data source retrieves the available AFAS jobtitles from the configured environment. This is an optional field within the mapping rule.

### PowerShell data source '[powershell-datasource]_Nedap-ons-csv-afas-organisational-units-teams-rules-create'
This Powershell data source retrieves the available AFAS organisational units from the configured environment.

### PowerShell data source '[powershell-datasource]_Nedap-ons-csv-nedap-teams-teams-rules-create'
This Powershell data source retrieves the available Nedap ONS teams from the configured environment.

### Delegated form task '[task]_Nedap-ons-add-teams-rule'
This delegated form task will add a rule to the configured mapping file.

# HelloID Docs
The official HelloID documentation can be found at: https://docs.helloid.com/