function parse_log {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        [string] $EventID,
        [Parameter(Mandatory=$true, Position=1)]
        [string] $event_name,
        [Parameter(Mandatory=$true, Position=2)]
        [string] $OutputFile,
        [Parameter(Mandatory=$true, Position=3)]
        [string] $event_file_type,
        [Parameter(Mandatory=$true, Position=4)]
        [string] $sans_catagory,
        [Parameter(Mandatory=$true, Position=5)]
        [string] $Query
    )
    LogParser\Executable\local-LogParser.exe -stats:OFF -i:EVT $Query
    $StatsOut= GetStats $OutputFile
    $hash= New-Object PSObject -property @{EventID=$EventID;EventLog=$event_file_type;SANSCateogry=$sans_catagory; Event=$event_name; NumberOfOccurences=$StatsOut}
    $global:ResultsArray += $hash
    Write-Host $event_name":" $StatsOut -ForegroundColor Green
}
function AllSuccessfulLogons {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4624"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "AllSuccessfulLogons.csv"
    $Query="SELECT TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain, EXTRACT_TOKEN(Strings, 8, '|') as LogonType,EXTRACT_TOKEN(strings, 9, '|') AS AuthPackage, EXTRACT_TOKEN(Strings, 11, '|') AS Workstation, EXTRACT_TOKEN(Strings, 17, '|') AS ProcessName, EXTRACT_TOKEN(Strings, 18, '|') AS SourceIP INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID  And LogonType<>'5'"
    parse_log $EventID "Successful Logons" $OutputFile "Security.evtx" "Remote Desktop" $Query
}
function UnsuccessfulLogons {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4625"
    $OutputFile= Join-Path -Path $ExtraEvents_Path -ChildPath "UnsuccessfulLogons.csv"
    $Query="SELECT TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain, EXTRACT_TOKEN(Strings, 10, '|') as LogonType,EXTRACT_TOKEN(strings, 11, '|') AS AuthPackage, EXTRACT_TOKEN(Strings, 13, '|') AS Workstation, EXTRACT_TOKEN(Strings, 11, '|') AS ProcessName, EXTRACT_TOKEN(Strings, 18, '|') AS ProcessPath ,EXTRACT_TOKEN(Strings, 19, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 20, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID  And LogonType<>'5'"  
    parse_log $EventID "Unsuccessful Logons" $OutputFile "Security.evtx" "Extra Events" $Query
}

function AdminLogonCreated  {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4672"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "AdminLogonCreated.csv"
    $Query="Select TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 1, '|') AS Username, EXTRACT_TOKEN(Strings, 2, '|') AS Domain , EXTRACT_TOKEN(Strings, 3, '|') as LogonID, EXTRACT_TOKEN(Strings, 4, '|') as PrivilegeList INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Admin Logons Created" $OutputFile "Security.evtx" "Map Network Shares" $Query
}


function ServiceInstalledonSystem {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4697"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceInstalledonSystem.csv" 
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 5, '|') AS ServiceFileName, EXTRACT_TOKEN(Strings, 6, '|') AS ServiceType,  EXTRACT_TOKEN(Strings, 7, '|') AS ServiceStartType  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Installed Services [Security Log]" $OutputFile "Security.evtx" "Services" $Query
}

function ScheduleTaskCreated {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4698"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Created [Security Log]" $OutputFile "Security.evtx" "Scheduled Tasks" $Query
}

function ScheduleTaskDeleted {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
                Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4699"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskDeleted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Deleted [Security Log]" $OutputFile "Security.evtx" "Scheduled Tasks" $Query
}

function ScheduleTaskEnabled {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
         Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4700"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskEnabled.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Enabled [Security Log]" $OutputFile "Security.evtx" "Scheduled Tasks" $Query
}

function ScheduleTaskDisabled{
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4701"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskDisabled.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Disabled [Security Log]" $OutputFile "Security.evtx" "Scheduled Tasks" $Query
}


function ScheduleTaskUpdated{
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
         Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4702"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ScheduleTaskUpdated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Updated [Security Log]" $OutputFile "Security.evtx" "Scheduled Tasks" $Query
}


function KerberosAuthRequest {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4768"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "KerberosAuthRequest.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 9, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 10, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Kerberos Authentication Tickets Requested" $OutputFile "Security.evtx" "Map Network Shares" $Query
}

function KerberosServiceRequest {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4769"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "KerberosServiceRequest.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceName ,EXTRACT_TOKEN(Strings, 6, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 7, '|') AS SourcePort INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Kerberos Services Tickets Requested" $OutputFile "Security.evtx" "Map Network Shares" $Query
}

function ComputerToValidate  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4776"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "ComputerToValidate.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID " 
    parse_log $EventID "Computer to validate" $OutputFile "Security.evtx" "Map Network Shares" $Query
}
function EventlogClearedSecurity  {
    param (
      [Parameter(Mandatory=$true)]
      [string]$security
  )
  if($security -eq $false){
      Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
      return
  }
  if ($Valid_Security_Path -eq $false) {
      write-host "Error: Security event log is not found" -ForegroundColor Red
      return  
  }
  $EventID="1102"
  $OutputFile= Join-Path -Path $ExtraEvents_Path -ChildPath "EventlogClearedSecurity.csv"
  $Query="SELECT TimeGenerated , EXTRACT_TOKEN(Strings, 1, '|') as Username, EXTRACT_TOKEN(Strings, 2, '|') AS DomainName, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
  parse_log $EventID "Cleared Event Log [Security log]" $OutputFile "Security.evtx" "Extra Events" $Query
}

function EventlogClearedSystem  {
    if ($Valid_System_Path -eq $false) {
      write-host "Error: System event log is not found" -ForegroundColor Red
      return  
    }
    $EventID="104"
    $OutputFile= Join-Path -Path $ExtraEvents_Path -ChildPath "EventlogClearedSystem.csv"
    $Query="SELECT TimeGenerated , EXTRACT_TOKEN(Strings, 0, '|') AS Username , EXTRACT_TOKEN(Strings, 1, '|') as Domain, EXTRACT_TOKEN(Strings, 2, '|') AS Channel INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    parse_log $EventID "Cleared Event Log [System log]" $OutputFile "System.evtx" "Extra Events" $Query}
function RDPreconnected  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4778"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPreconnected.csv"
    $Query="SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"     
    parse_log $EventID "RDP sessions reconnected" $OutputFile "Security.evtx" "Remote Desktop" $Query
}

function RDPDisconnected  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4779"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPDisconnected.csv"
    $Query= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID" 
    parse_log $EventID "RDP sessions disconnected" $OutputFile "Security.evtx" "Remote Desktop" $Query
}
function NetworkShareAccessed  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5140"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "NetworkShareAccessed.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 5, '|') AS SourcePort, EXTRACT_TOKEN(Strings, 6, '|') AS ShareName INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Network Share Objects Accessed" $OutputFile "Security.evtx" "Map Network Shares" $Query
}

function AuditingofSharedfiles  {
      param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5145"
    $OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "AuditingofSharedfiles.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccounName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ObjectType, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 6, '|') AS SourePort, EXTRACT_TOKEN(Strings, 7, '|') AS ShareName, EXTRACT_TOKEN(Strings, 8, '|') AS SharePath, EXTRACT_TOKEN(Strings, 11, '|') as Accesses, EXTRACT_TOKEN(Strings, 12, '|') as AccessesCheckResult INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = $EventID"
    parse_log $EventID "Network Share Objects Checked" $OutputFile "Security.evtx" "Map Network Shares" $Query
}



function ServiceCrashed	 {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7034"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceCrashed.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS Times INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    parse_log $EventID "Services Crashed unexpectedly" $OutputFile "System.evtx" "Services" $Query
}

function ServiceStartorStop {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7036"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceStartorStop.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ServiceStatus INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    parse_log $EventID "Services Stopped or Started" $OutputFile "System.evtx" "Services" $Query
}
function ServiceSentControl {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7035"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "ServiceSentControl.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS RequestSent INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    parse_log $EventID "Services Sent Stop/Start Control" $OutputFile "System.evtx" "Services" $Query
}

function StartTypeChanged {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7040"
    $OutputFile= Join-Path -Path $Services_Path -ChildPath "StartTypeChanged.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ChangedFrom , EXTRACT_TOKEN(Strings, 2, '|') AS ChangedTo INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    parse_log $EventID "Services Start Type Changed" $OutputFile "System.evtx" "Services" $Query
}

function ServiceInstall {
    if ($Valid_System_Path -eq $false) {
        write-host "Error: System event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="7045"
    $OutputFile= Join-Path -Path $PsExec_Path -ChildPath "ServiceInstall.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ImagePath, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceType , EXTRACT_TOKEN(Strings, 3, '|') AS StartType, EXTRACT_TOKEN(Strings, 4, '|') AS AccountName INTO '$OutputFile' FROM '$System_Path' WHERE EventID = $EventID"
    parse_log $EventID "Installed Services [System Log]" $OutputFile "System.evtx" "PsExec" $Query
}


########################################## WMI ################################################
function SystemQueryWMI {
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5857"
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "SystemQueryWMI.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ProviderName, EXTRACT_TOKEN(Strings, 1, '|') AS Code, EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ProviderPath INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    parse_log $EventID "WMI Operations Started" $OutputFile "Microsoft-Windows-WMIActivity%4Operational.evtx" "WMI/WMIC" $Query
}


function TemporaryEventConsumer {
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5860"
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "TemporaryEventConsumer.csv" 
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS Query,EXTRACT_TOKEN(Strings, 2, '|') AS User ,EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ClientMachine INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    parse_log $EventID "WMI Temporary Event Consumer" $OutputFile "Microsoft-Windows-WMIActivity%4Operational.evtx" "WMI/WMIC" $Query
}


function PermenantEventConsumer{
    if ($Valid_WMI_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="5861"
    $OutputFile= Join-Path -Path $WMIOut_Path -ChildPath "PermenantEventConsumer.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS ESS,EXTRACT_TOKEN(Strings, 2, '|') AS Consumer ,EXTRACT_TOKEN(Strings, 3, '|') AS PossibleCause INTO '$OutputFile' FROM '$WMI_Path' WHERE EventID = $EventID"
    parse_log $EventID "WMI Permenant Event Consumer" $OutputFile "Microsoft-Windows-WMIActivity%4Operational.evtx" "WMI/WMIC" $Query
}
#===============Microsoft-Windows-PowerShell%4Operational.evtx=========
function ScriptBlockLogging {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4103"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "ScriptBlockLogging.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ContextINFO, EXTRACT_TOKEN(Strings, 2, '|') AS Payload INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    parse_log $EventID "PS Script block Logged" $OutputFile "Microsoft-Windows-PowerShell%4Operational.evtx" "Power Shell Remoting" $Query
}

function ScriptBlockAuditing  {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4104"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "ScriptBlockAuditing.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS MessageNumber, EXTRACT_TOKEN(Strings, 1, '|') AS TotalMessages, EXTRACT_TOKEN(Strings, 2, '|') AS ScriptBlockText , EXTRACT_TOKEN(Strings, 3, '|') AS ScriptBlockID , EXTRACT_TOKEN(Strings,4 , '|') AS ScriptPath INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    parse_log $EventID "PS Script block Auditing" $OutputFile "Microsoft-Windows-PowerShell%4Operational.evtx" "Power Shell Remoting" $Query
}    

function LateralMovementDetection  {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="53504"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "LateralMovementDetection.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS Process, EXTRACT_TOKEN(Strings, 1, '|') AS AppDomain INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"    
    parse_log $EventID "PS Authenticating User" $OutputFile "Microsoft-Windows-PowerShell%4Operational.evtx" "Power Shell Remoting" $Query
}
#=====================WinRM log=======================
function SessionCreated {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="91"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "SessionCreated.csv" 
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ResourceUrl INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    parse_log $EventID "Sessions Created" $OutputFile "Microsoft-Windows-WinRM%4Operational.evtx" "Power Shell Remoting" $Query
}  

function AuthRecorded {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="168"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "AuthRecorded.csv"
    $Query="Select TimeGenerated,EventID, Message INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    parse_log $EventID "WinRM Authenticating User" $OutputFile "Microsoft-Windows-WinRM%4Operational.evtx" "Power Shell Remoting" $Query
}

#####======= Windows PowerShell.evtx======
function StartPSRemoteSession {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="400"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "StartPSRemoteSession.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    parse_log $EventID "PS Remote Sessions Started" $OutputFile "Windows PowerShell.evtx" "Power Shell Remoting" $Query
}
function EndPSRemoteSession {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="403"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "EndPSRemoteSession.csv"
    $Query="Select TimeGenerated,EventID,  EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    parse_log $EventID "PS Remote Sessions Ended" $OutputFile "Windows PowerShell.evtx" "Power Shell Remoting" $Query
}

function PipelineExecution {
    if ($Valid_WinPowerShell_Path -eq $false) {
        write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="800"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PipelineExecution.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication  INTO '$OutputFile' FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    parse_log $EventID "Partial Scripts Content" $OutputFile "Windows PowerShell.evtx" "Power Shell Remoting" $Query
}

#==============Task Scheduler=============

function CreatingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="106"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "CreatingTaskSchedulerTask.csv"
    $Query="Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Created [Task Scheduler Log]" $OutputFile "Microsoft-Windows-TaskScheduler%4Operational.evtx" "Scheduled Tasks" $Query
}

function UpdatingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="140"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "UpdatingTaskSchedulerTask.csv"
    $Query="Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Updated [Task Scheduler Log]" $OutputFile "Microsoft-Windows-TaskScheduler%4Operational.evtx" "Scheduled Tasks" $Query
}

function DeletingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="141"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "DeletingTaskSchedulerTask.csv"
    $Query="Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Deleted [Task Scheduler Log]" $OutputFile "Microsoft-Windows-TaskScheduler%4Operational.evtx" "Scheduled Tasks" $Query
}

function ExecutingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="200"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "ExecutingTaskSchedulerTask.csv"
    $Query="Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Executed [Task Scheduler Log]" $OutputFile "Microsoft-Windows-TaskScheduler%4Operational.evtx" "Scheduled Tasks" $Query
}


function CompletingTaskSchedulerTask {
    if ($Valid_TaskScheduler_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TaskScheduler%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="201"
    $OutputFile= Join-Path -Path $ScheduledTasks_Path -ChildPath "CompletingTaskSchedulerTask.csv"
    $Query="Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO '$OutputFile' FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    parse_log $EventID "Scheduled Tasks Completed [Task Scheduler Log]" $OutputFile "Microsoft-Windows-TaskScheduler%4Operational.evtx" "Scheduled Tasks" $Query
}

##============= Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx============
function RDPSessionLogonSucceeded {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="21"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPSessionLogonSucceeded.csv"
    $Query="Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Successful Logons Sessions [EventID=21]" $OutputFile "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "Remote Desktop" $Query
}

function RDPShellStartNotificationReceived {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="22"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPShellStartNotificationReceived.csv"
    $Query="Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Successful Logons Sessions [EventID=22]" $OutputFile "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "Remote Desktop" $Query
}

function RDPShellSessionReconnectedSucceeded {
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="25"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPShellSessionReconnectedSucceeded.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Successful Shell Sessions Reconnected" $OutputFile "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "Remote Desktop" $Query
}
function RDPbeginSession { 
    if ($Valid_TerminalServices_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="41"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPBeginSession.csv"
    $Query="Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID INTO '$OutputFile' FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Sessions Begain" $OutputFile "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "Remote Desktop" $Query
}
#=========================Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx=======================
function UserAuthSucceeded {
    if ($Valid_RemoteConnection_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="1149"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "UserAuthSucceeded.csv"
    $Query="Select TimeGenerated,EventID  ,extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as Domain ,extract_token(strings,2, '|') as SourceIP   INTO '$OutputFile' FROM '$RemoteConnection_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP User authentication succeeded" $OutputFile "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx" "Remote Desktop" $Query
}
#============Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx============
function RDPConnectionsAttempts {
    if ($Valid_RDPCORETS_Path -eq $false) {
        write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="131"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPConnectionsAttempts.csv"
    $Query="Select TimeGenerated,EventID ,extract_token(strings, 0, '|') as ConnectionType, extract_token(strings, 1, '|') as CLientIP INTO '$OutputFile' FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Connections Attempts" $OutputFile "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx" "Remote Desktop" $Query
}

function RDPSuccessfulConnections {
    if ($Valid_RDPCORETS_Path -eq $false) {
        write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="98"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPSuccessfulTCPConnections.csv"
    $Query="Select TimeGenerated,EventID  INTO '$OutputFile' FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Successful TCP Connections" $OutputFile "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx" "Remote Desktop" $Query
}
##==========================Source Event IDs============
##Security.evtx
function ExplicitCreds {
    param (
        [Parameter(Mandatory=$true)]
        [string]$security
    )
    if($security -eq $false){
        Write-Host "Discarded==> Depends on Security event log" -ForegroundColor Red
        return
    }
    if ($Valid_Security_Path -eq $false) {
        write-host "Error: Security event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="4648"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "ExplicitCreds.csv"
    $Query="SELECT TimeGenerated,EventID, extract_token(Strings, 1, '|') as SubjectUserName, extract_token(Strings, 2, '|') as SubjectDomain, extract_token(Strings, 5, '|') as TargetUsername, extract_token(Strings, 6, '|') as TargetDomain, extract_token(Strings, 8, '|') as TargetServer, extract_token(strings, 9, '|') as TargetInfo, extract_token(strings, 11, '|') as ProcessName, extract_token(strings, 12, '|') as SourceIP,extract_token(strings, 13, '|') as SourcePort INTO '$OutputFile' from '$Security_Path' WHERE EventID = $EventID" 
    parse_log $EventID "Logons using Explicit Credential" $OutputFile "Security.evtx" "Remote Desktop" $Query
}
##Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx
function RDPActiveXControls {
    if ($global:Valid_TerminalServicesRDP_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-RDPClient%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="1024"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPActiveXControls.csv"
    $Query="Select TimeGenerated,EventID, extract_token(Strings, 0, '|') as Name, extract_token(Strings, 1, '|') as IP/HostName, extract_token(Strings, 2, '|') as Level INTO '$OutputFile' FROM '$TerminalServicesRDP_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Destination Hostname [ActiveX controls]" $OutputFile "Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx" "Remote Desktop" $Query
}
function RDPAMultitransportCon {
    if ($global:Valid_TerminalServicesRDP_Path -eq $false) {
        write-host "Error: Microsoft-Windows-TerminalServices-RDPClient%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="1102"
    $OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPAMultitransportCon.csv"
    $Query="Select TimeGenerated,EventID, extract_token(Strings, 0, '|') as Name, extract_token(Strings, 1, '|') as IP/HostName, extract_token(Strings, 2, '|') as Level INTO '$OutputFile' FROM '$TerminalServicesRDP_Path' WHERE EventID = $EventID"
    parse_log $EventID "RDP Destination IPs [client Multitransport Connections]" $OutputFile "Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx" "Remote Desktop" $Query
}
###=====Microsoft-Windows-WinRM%4Operational.evtx
function WSManSessions {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="6"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManSessionsCreated.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ConnectionString INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"   
    parse_log $EventID "WSMan Sessions Created" $OutputFile "Microsoft-Windows-WinRM%4Operational.evtx" "Power Shell Remoting" $Query
}  
function WSManClosedCommand {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="15"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManClosedCommand.csv"
    $Query="Select TimeGenerated,EventID INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    parse_log $EventID "WSMan Closed Commands" $OutputFile "Microsoft-Windows-WinRM%4Operational.evtx" "Power Shell Remoting" $Query
}  
function WSManClosedShell {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="16"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManClosedShell.csv"
    $Query="Select TimeGenerated,EventID INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    parse_log $EventID "WSMan Closed Shells" $OutputFile "Microsoft-Windows-WinRM%4Operational.evtx" "Power Shell Remoting" $Query
}  
function WSManSessionsClosed {
    if ($Valid_WinRM_Path -eq $false) {
        write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="33"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "WSManSessionsClosed.csv"
    $Query="Select TimeGenerated,EventID, Message INTO '$OutputFile' FROM '$WinRM_Path' WHERE EventID = $EventID"
    parse_log $EventID "WSMan Closed Sessions" $OutputFile "Microsoft-Windows-WinRM%4Operational.evtx" "Power Shell Remoting" $Query
}  
#=========Microsoft-Windows-PowerShell%4Operational.evtx
function PSSessionsCreated {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="8194"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSSessionsCreated.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS InstanceID, EXTRACT_TOKEN(Strings, 1, '|') AS MinRunSpaces, EXTRACT_TOKEN(Strings, 2, '|') AS MaxRunspaces  INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    parse_log $EventID "PS Created Sessions" $OutputFile "Microsoft-Windows-PowerShell%4Operational.evtx" "Power Shell Remoting" $Query
}

function PSSessionsClosed {
    if ($Valid_PowerShellOperational_Path -eq $false) {
        write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red
        return  
    }
    $EventID="8197"
    $OutputFile= Join-Path -Path $PowerShellRemoting_Path -ChildPath "PSSessionsClosed.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS State  INTO '$OutputFile' FROM '$PowerShellOperational_Path' WHERE EventID = $EventID and State = 'Closed'"
    parse_log $EventID "PS Closed Sessions" $OutputFile "Microsoft-Windows-PowerShell%4Operational.evtx" "Power Shell Remoting" $Query
}

