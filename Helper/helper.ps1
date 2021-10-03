$global:ResultsArray= @()
function GetStats {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    $Valid=Test-Path -Path "$FilePath"
    if($Valid -eq $true){
        (Import-Csv $FilePath).count
        <#$NumRows=LogParser.exe -i:csv -stats:OFF "Select Count (*) from '$FilePath'" | Out-String
        $NumRows.Substring([int](29))#>
    } 
    else {
        Return 0
    }
}
function SuccessfulLogons {
    param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4624
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "SuccessfulLogons.csv"
    $Query="SELECT TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain, EXTRACT_TOKEN(Strings, 8, '|') as LogonType,EXTRACT_TOKEN(strings, 9, '|') AS AuthPackage, EXTRACT_TOKEN(Strings, 11, '|') AS Workstation, EXTRACT_TOKEN(Strings, 17, '|') AS ProcessName, EXTRACT_TOKEN(Strings, 18, '|') AS SourceIP INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID  And LogonType<>'5'"  
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $SuccessfulLogons= $LogOut.count
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="RemoteDesktop"; Event="Successful Logons"; NumberOfOccurences=$SuccessfulLogons}
    $global:ResultsArray += $hash
    Write-Host "Successful Logons:" $SuccessfulLogons -ForegroundColor Green
}


function AdminLogonCreated  {
    param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4672
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "AdminLogonCreated.csv"
    $Query="Select TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 1, '|') AS Username, EXTRACT_TOKEN(Strings, 2, '|') AS Domain , EXTRACT_TOKEN(Strings, 3, '|') as LogonID INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $AdminLogonsCreated= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Admin Logons Created"; NumberOfOccurences=$AdminLogonsCreated}
    $global:ResultsArray+=$hash
    Write-Host "Admin Logons Created: " $AdminLogonsCreated -ForegroundColor Green  
}


function InstalledServices {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4697
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "InstalledServices.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 5, '|') AS ServiceFileName, EXTRACT_TOKEN(Strings, 6, '|') AS ServiceType,  EXTRACT_TOKEN(Strings, 7, '|') AS ServiceStartType  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $InstalledServices= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="Services"; Event="Installed Services [Security Log]"; NumberOfOccurences=$InstalledServices}
    $global:ResultsArray+=$hash
    Write-Host "Installed Services [Security Log]: " $InstalledServices -ForegroundColor Green  
}



function ScheduledTaskCreatedSec {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4698
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTaskCreatedSec.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskCreatedSec= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Created [Security Log]"; NumberOfOccurences=$ScheduledTaskCreatedSec}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Created [Security Log]: " $ScheduledTaskCreatedSec -ForegroundColor Green  
}

function ScheduledTaskDeletedSec {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4699
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTaskDeletedSec.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskDeletedSec= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Deleted [Security Log]"; NumberOfOccurences=$ScheduledTaskDeletedSec}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Deleted [Security Log]: " $ScheduledTaskDeletedSec -ForegroundColor Green  
}

function ScheduledTaskEnabledSec {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4700
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTaskEnabledSec.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskEnabledSec= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Enbaled [Security Log]"; NumberOfOccurences=$ScheduledTaskEnabledSec}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Enbaled [Security Log]: " $ScheduledTaskEnabledSec -ForegroundColor Green
}

function ScheduledTaskDisabledSec{
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4701
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTaskDisabledSec.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskDisabledSec= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Disabled [Security Log]"; NumberOfOccurences=$ScheduledTaskDisabledSec}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Disabled [Security Log]: " $ScheduledTaskDisabledSec -ForegroundColor Green
}


function ScheduledTaskUpdatedSec{
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4702
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTaskUpdatedSec.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskUpdatedSec= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Updated [Security Log]"; NumberOfOccurences=$ScheduledTaskUpdatedSec}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Updated [Security Log]: " $ScheduledTaskUpdatedSec -ForegroundColor Green
}


function KerberosAuthenticationRequested {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4768
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "KerberosAuthenticationRequested.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 9, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 10, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $KerberosAuthenticationRequested= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Kerberos Authentication Tickets Requested"; NumberOfOccurences=$KerberosAuthenticationRequested}
    $global:ResultsArray+=$hash
    Write-Host "Kerberos Authentication Tickets Requested: " $KerberosAuthenticationRequested -ForegroundColor Green  
}

function KerberosServiceRequested {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4769
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "KerberosServiceRequested.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceName ,EXTRACT_TOKEN(Strings, 6, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 7, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $KerberosServiceRequested= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Kerberos Services Tickets Requested"; NumberOfOccurences=$KerberosServiceRequested}
    $global:ResultsArray+=$hash
    Write-Host "Kerberos Services Tickets Requested: " $KerberosServiceRequested -ForegroundColor Green  
    
}

function ComputerToValidate  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4776
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "ComputerToValidate.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID " 
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ComputerToValidate= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Computer to Validate"; NumberOfOccurences=$ComputerToValidate}
    $global:ResultsArray+=$hash
    Write-Host "Computer to validate: " $ComputerToValidate -ForegroundColor Green

}

function RDPReconnected  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4778
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPReconnected.csv"
    $Query= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID" 
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPReconencted= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="RemoteDesktop"; Event="RDP sessions reconnected"; NumberOfOccurences=$RDPReconencted}
    $global:ResultsArray+=$hash
    Write-Host "RDP sessions reconnected: " $RDPReconencted -ForegroundColor Green

    
}

function RDPDisconnected  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4779
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPDisconnected.csv"
    $Query= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID" 
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPDisconnected= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="RemoteDesktop"; Event="RDP sessions Disconnected"; NumberOfOccurences=$RDPDisconnected}
    $global:ResultsArray+=$hash
    Write-Host "RDP sessions Disconnected: " $RDPDisconnected  -ForegroundColor Green 
}
function NetworkShareAccessed  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=5140
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "NetworkShareAccessed.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 5, '|') AS SourcePort, EXTRACT_TOKEN(Strings, 6, '|') AS ShareName INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $NetworkShareAccessed= GetStats $
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Network Share Objects Accessed"; NumberOfOccurences=$NetworkShareAccessed}
    $global:ResultsArray+=$hash
    Write-Host "Network Share Objects Accessed: " $NetworkShareAccessed -ForegroundColor Green
}

function NetworkShareChecked  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$NoSecurity
    )
    if($NoSecurity -eq "no"){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red

        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=5145
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "NetworkShareChecked.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccounName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ObjectType, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 6, '|') AS SourePort, EXTRACT_TOKEN(Strings, 7, '|') AS ShareName, EXTRACT_TOKEN(Strings, 8, '|') AS SharePath, EXTRACT_TOKEN(Strings, 11, '|') as Accesses, EXTRACT_TOKEN(Strings, 12, '|') as AccessesCheckResult INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $NetworkShareChecked= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Security.evtx";SANSCateogry="MapNetworkShares"; Event="Network Share Objects Checked"; NumberOfOccurences=$NetworkShareChecked}
    $global:ResultsArray+=$hash
    Write-Host "Network Share Objects Checked : " $NetworkShareChecked -ForegroundColor Green
}



function ServiceCrashedUnexpect {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=7034
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceCrashedUnexpect.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS Times INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceCrashedUnexpect= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Crashed unexpectedly"; NumberOfOccurences=$ServiceCrashedUnexpect}
    $global:ResultsArray+=$hash    
    Write-Host "Services Crashed unexpectedly [System Log]: " $ServiceCrashedUnexpect -ForegroundColor Green
}

function ServicesStatus {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=7036
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServicesStatus.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS ServiceName INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ServicesStatus= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Stopped Or Started"; NumberOfOccurences=$ServicesStatus}
    $global:ResultsArray+=$hash 
    Write-Host "Services Stopped Or Started: " $ServicesStatus -ForegroundColor Green
 
}
function ServiceSentStartStopControl {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=7035
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceSentStartStopControl.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS RequestSent INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceSentStartStopControl= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Sent Stop/Start Control [System Log]"; NumberOfOccurences=$ServiceSentStartStopControl}
    $global:ResultsArray+=$hash 
    Write-Host "Services Sent Stop/Start Control [System Log]: " $ServiceSentStartStopControl -ForegroundColor Green
}

function ServiceStartTypeChanged {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=7040
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceStartTypeChanged.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ChangedFrom , EXTRACT_TOKEN(Strings, 2, '|') AS ChangedTo INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceStartTypeChanged= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="Services"; Event="Services Start Type Changed [System Log]"; NumberOfOccurences=$ServiceStartTypeChanged}
    $global:ResultsArray+=$hash     
    Write-Host "Services Start Type Changed [System Log]: " $ServiceStartTypeChanged -ForegroundColor Green
}

function SystemInstalledServices {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=7045
    $OutputFile= Join-Path -Path $PsExec_Path -ChildPath "SystemInstalledServices.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ImagePath, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceType , EXTRACT_TOKEN(Strings, 3, '|') AS StartType, EXTRACT_TOKEN(Strings, 4, '|') AS AccountName INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $SystemInstalledServices= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="System.evtx";SANSCateogry="PsExec"; Event="Services Installed on System [System Log]"; NumberOfOccurences=$SystemInstalledServices}
    $global:ResultsArray+=$hash
    Write-Host "Services Installed on System [System Log]: " $SystemInstalledServices -ForegroundColor Green
}

########################################## WMI ################################################
function WMIOperationStarted {
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=5857
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "WMIOperationStarted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ProviderName, EXTRACT_TOKEN(Strings, 1, '|') AS Code, EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ProviderPath INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $WMIOperationStarted= GetStats $
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WMIActivity%4Operational.evtx";SANSCateogry="WMI/WMIC"; Event="Services Installed on System [System Log]"; NumberOfOccurences=$WMIOperationStarted}
    $global:ResultsArray+=$hash
    Write-Host "WMI Operations Started [WMI Log]: " $WMIOperationStarted   -ForegroundColor Green
}


function WMIOperationTemporaryEssStarted {
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=5860
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "WMIOperationTemporaryEssStarted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS Query,EXTRACT_TOKEN(Strings, 2, '|') AS User ,EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ClientMachine INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $WMIOperationTemporaryEssStarted= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WMIActivity%4Operational.evtx";SANSCateogry="WMI/WMIC"; Event="WMI Operations ESS Started [WMI Log]"; NumberOfOccurences=$WMIOperationTemporaryEssStarted}
    $global:ResultsArray+=$hash
    Write-Host "WMI Operations ESS Started [WMI Log]: " $WMIOperationTemporaryEssStarted  -ForegroundColor Green 
}


function WMIOperationESStoConsumerBinding {
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=5861
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "WMIOperationESStoConsumerBinding.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS ESS,EXTRACT_TOKEN(Strings, 2, '|') AS Consumer ,EXTRACT_TOKEN(Strings, 3, '|') AS PossibleCause INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $WMIOperationESStoConsumerBinding= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WMIActivity%4Operational.evtx";SANSCateogry="WMI/WMIC"; Event="WMI Operations ESS to Consumer Binding [WMI Log]"; NumberOfOccurences=$WMIOperationESStoConsumerBinding}
    $global:ResultsArray+=$hash
    Write-Host "WMI Operations ESS to Consumer Binding [WMI Log]: " $WMIOperationESStoConsumerBinding  -ForegroundColor Green  
}


#===============Microsoft-Windows-PowerShell%4Operational.evtx=========
function PSModuleLogging {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4103
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSModuleLogging.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ContextINFO, EXTRACT_TOKEN(Strings, 2, '|') AS Payload INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $PSModuleLogging= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Modules Logged"; NumberOfOccurences=$PSModuleLogging}
    $global:ResultsArray+=$hash
    Write-Host "PS Modules Logged : " $PSModuleLogging -ForegroundColor Green

}

function PSScriptBlockLogging  {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=4104
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSScriptBlockLogging.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS MessageNumber, EXTRACT_TOKEN(Strings, 1, '|') AS TotalMessages, EXTRACT_TOKEN(Strings, 2, '|') AS ScriptBlockText , EXTRACT_TOKEN(Strings, 3, '|') AS ScriptBlockID , EXTRACT_TOKEN(Strings,4 , '|') AS ScriptPath INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $PSScriptBlockLogging= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Script Blocks Logged"; NumberOfOccurences=$PSScriptBlockLogging}
    $global:ResultsArray+=$hash
    Write-Host "PS Script Blocks Logged : " $PSScriptBlockLogging -ForegroundColor Green  
}    

function PSAuthneticatingUser  {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=53504
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSAuthneticatingUser.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS Process, EXTRACT_TOKEN(Strings, 1, '|') AS AppDomain INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $PSAuthneticatingUser= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-PowerShell%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="PS Authenticating User"; NumberOfOccurences=$PSAuthneticatingUser}
    $global:ResultsArray+=$hash
    Write-Host "PS Authenticating User : " $PSAuthneticatingUser -ForegroundColor Green  
}
#=====================WinRM log=======================
function SessionCreated {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=91
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "SessionCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ResourceUrl INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $SessionCreated= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="Session Created [WinRM log]"; NumberOfOccurences=$SessionCreated}
    $global:ResultsArray+=$hash
    Write-Host "Session Created [WinRM log] : " $SessionCreated -ForegroundColor Green  
}  

function WinRMAuthneticatingUser {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=168
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WinRMAuthneticatingUser.csv"
    $Query= "Select TimeGenerated,EventID, Message INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $WinRMAuthneticatingUser= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-WinRM%4Operational.evtx";SANSCateogry="PowerShellRemoting"; Event="WinRM Authenticating User [WinRM log]"; NumberOfOccurences=$WinRMAuthneticatingUser}
    $global:ResultsArray+=$hash
    Write-Host "WinRM Authenticating User [WinRM log] : " $WinRMAuthneticatingUser -ForegroundColor Green

}

#####======= Windows PowerShell.evtx======
function ServerRemoteHostStarted {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=400
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "ServerRemoteHostStarted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ServerRemoteHostStarted= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Windows PowerShell.evtx";SANSCateogry="PowerShellRemoting"; Event="Server Remote Hosts Started"; NumberOfOccurences=$ServerRemoteHostStarted}
    $global:ResultsArray+=$hash
    Write-Host "Server Remote Hosts Started : " $ServerRemoteHostStarted -ForegroundColor Green

    
}
function ServerRemoteHostEnded {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=403
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "ServerRemoteHostEnded.csv"
    $Query= "Select TimeGenerated,EventID,  EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ServerRemoteHostEnded= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Windows PowerShell.evtx";SANSCateogry="PowerShellRemoting"; Event="Server Remote Hosts Ended"; NumberOfOccurences=$ServerRemoteHostEnded}
    $global:ResultsArray+=$hash
    Write-Host "Server Remote Hosts Ended : " $ServerRemoteHostEnded -ForegroundColor Green
}

function PSPartialCode {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=800
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSPartialCode.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication  INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $PSPartialCode= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Windows PowerShell.evtx";SANSCateogry="PowerShellRemoting"; Event="Partial Scripts Code"; NumberOfOccurences=$PSPartialCode}
    $global:ResultsArray+=$hash
    Write-Host "Partial Scripts Code : " $PSPartialCode   -ForegroundColor Green
}

#==============Task Scheduler=============

function ScheduledTasksCreatedTS {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=106
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTasksCreatedTS.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksCreatedTS= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Created [Task Scheduler Log]"; NumberOfOccurences=$ScheduledTasksCreatedTS}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Created [Task Scheduler Log] : " $ScheduledTasksCreatedTS  -ForegroundColor Green
 
}

function ScheduledTasksUpdatedTS {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=140
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTasksUpdatedTS.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksUpdatedTS= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Updated [Task Scheduler Log]"; NumberOfOccurences=$ScheduledTasksUpdatedTS}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Updated [Task Scheduler Log]: " $ScheduledTasksUpdatedTS  -ForegroundColor Green
 
}

function ScheduledTasksDeletedTS {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=141
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTasksDeletedTS.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksDeletedTS= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Deleted [Task Scheduler Log]"; NumberOfOccurences=$ScheduledTasksDeletedTS}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Deleted [Task Scheduler Log] : " $ScheduledTasksDeletedTS  -ForegroundColor Green
 
}

function ScheduledTasksExecutedTS {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=200
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTasksExecutedTS.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksExecutedTS= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Executed [Task Scheduler Log]"; NumberOfOccurences=$ScheduledTasksExecutedTS}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Executed [Task Scheduler Log]: " $ScheduledTasksExecutedTS  -ForegroundColor Green
}


function ScheduledTasksCompletedTS {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=201
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduledTasksCompletedTS.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksCompletedTS= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TaskScheduler%4Operational.evtx";SANSCateogry="ScheduledTasks"; Event="Scheduled Tasks Completed [Task Scheduler Log]"; NumberOfOccurences=$ScheduledTasksCompletedTS}
    $global:ResultsArray+=$hash
    Write-Host "Scheduled Tasks Completed [Task Scheduler Log] : " $ScheduledTasksCompletedTS  -ForegroundColor Green
}

##============= Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx============
function RDPLocalSuccessfulLogon1 {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=21
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPLocalSuccessfulLogon1.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPLocalSuccessfulLogon1= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Local Successful Logons [EventID=21]"; NumberOfOccurences=$RDPLocalSuccessfulLogon1}
    $global:ResultsArray+=$hash
    Write-Host "RDP Local Successful Logons [EventID=21] : " $RDPLocalSuccessfulLogon1 -ForegroundColor Green
}

function RDPLocalSuccessfulLogon2 {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=22
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPLocalSuccessfulLogon2.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPLocalSuccessfulLogon2= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Local Successful Logons [EventID=22]"; NumberOfOccurences=$RDPLocalSuccessfulLogon2}
    $global:ResultsArray+=$hash
    Write-Host "RDP Local Successful Logons [EventID=22]: " $RDPLocalSuccessfulLogon2 -ForegroundColor Green
}

function RDPLocalSuccessfulReconnection {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=25
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPLocalSuccessfulReconnection.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPLocalSuccessfulReconnection= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event=" RDP Local Successful Reconnections"; NumberOfOccurences=$RDPLocalSuccessfulReconnection}
    $global:ResultsArray+=$hash
    Write-Host "RDP Local Successful Reconnections: " $RDPLocalSuccessfulReconnection -ForegroundColor Green
}
function RDPBegainSession {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=41
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPBeginSession.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPBeginSession= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event=" RDP Sessios Begain"; NumberOfOccurences=$RDPBeginSession}
    $global:ResultsArray+=$hash
    Write-Host "RDP Sessios Begain : " $RDPBeginSession -ForegroundColor Green
}

#=========================Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx=======================
function RDPConnectionEstablished {
    if ($Valid_RemoteConnection_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=1149
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPConnectionEstablished.csv"
    $Query= "Select TimeGenerated,EventID  ,extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as Domain ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$RemoteConnection_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPConnectionEstablished= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Connections Established"; NumberOfOccurences=$RDPConnectionEstablished}
    $global:ResultsArray+=$hash
    Write-Host "RDP Connections Established: " $RDPConnectionEstablished -ForegroundColor Green  
    
}


#============Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx=============

function RDPConnectionsAttempts {
    if ($Valid_RDPCORETS_Path -eq $false) {
        write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=131
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPConnectionsAttempts.csv"
    $Query= "Select TimeGenerated,EventID  ,extract_token(strings, 0, '|') as ConnectionType, extract_token(strings, 1, '|') as CLientIP INTO '$OutputFile' FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPConnectionsAttempts= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Connections Attempts"; NumberOfOccurences=$RDPConnectionsAttempts}
    $global:ResultsArray+=$hash
    Write-Host "RDP Connections Attempts : " $RDPConnectionsAttempts -ForegroundColor Green
}

function RDPSuccessfulTCPConnections {
    if ($Valid_RDPCORETS_Path -eq $false) {
        write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID=98
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPSuccessfulTCPConnections.csv"
    $Query= "Select TimeGenerated,EventID  INTO '$OutputFile' FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    $LogOut=LogParser.exe -stats:OFF -i:EVT $Query
    $RDPSuccessfulTCPConnections= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog="Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx";SANSCateogry="RemoteDesktop"; Event="RDP Successful TCP Connections"; NumberOfOccurences=$RDPSuccessfulTCPConnections}
    $global:ResultsArray+=$hash
    Write-Host "RDP Successful TCP Connections: " $RDPSuccessfulTCPConnections -ForegroundColor Green
}
