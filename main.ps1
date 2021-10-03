Write-host "
    ______           _     __    _            
   / ____/ _   __   (_)   / /   (_) ____  ___ 
  / __/   | | / /  / /   / /   / / /_  / / _ \
 / /___   | |/ /  / /   / /   / /   / /_/  __/
/_____/   |___/  /_/   /_/   /_/   /___/\___/ 
                                              
" -ForegroundColor Red -BackgroundColor black
$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path"  
$Destination_Path=$Logs_Path
$NoSecurity = Read-Host -Prompt "Do you want to parse the security event log? yes\no [Default is no]"
if($NoSecurity -eq ""){
    $NoSecurity="no"
}
##Validating Paths
$LogsPathTest=Test-Path -Path "$Logs_Path"
$DestPathTest=Test-Path -Path "$Destination_Path"
if((($LogsPathTest -eq $true) -and ($DestPathTest -eq $true)) -ne $true ){
        Write-Host "Error: Invalid Paths, Enter a valid path"
        exit
    }
##Create Results Directory

$Destination_Path= Join-Path -Path $Destination_Path -ChildPath "Results"
#check if it's already exist
if ((Test-Path -Path "$Destination_Path")-eq $false) {
    New-Item -Path $Destination_Path -ItemType Directory    
}
$RemoteDesktop_Path=Join-Path -Path $Destination_Path -ChildPath "RemoteDesktop"
#Check if Remote Desktop already exist
if ((Test-Path -Path "$RemoteDesktop_Path")-eq $false) {
    New-Item -Path $RemoteDesktop_Path -ItemType Directory    
}
$MapNetworkShares_Path=Join-Path -Path $Destination_Path -ChildPath "MapNetworkShares"
#Check if MapNetworkShares already exist
if ((Test-Path -Path "$MapNetworkShares_Path")-eq $false) {
    New-Item -Path $MapNetworkShares_Path -ItemType Directory    
}
$PsExec_Path=Join-Path -Path $Destination_Path -ChildPath "PsExec"
#Check if PsExec already exist
if ((Test-Path -Path "$PsExec_Path")-eq $false) {
    New-Item -Path $PsExec_Path -ItemType Directory    
}
$ScheduledTasks_Path=Join-Path -Path $Destination_Path -ChildPath "ScheduledTasks"
#Check if ScheduledTasks already exist
if ((Test-Path -Path "$ScheduledTasks_Path")-eq $false) {
    New-Item -Path $ScheduledTasks_Path -ItemType Directory    
}
$Services_Path=Join-Path -Path $Destination_Path -ChildPath "Services"
#Check if Services already exist
if ((Test-Path -Path "$Services_Path")-eq $false) {
    New-Item -Path $Services_Path -ItemType Directory    
}
$WMIOut_Path=Join-Path -Path $Destination_Path -ChildPath "WMI"
#Check if WMI already exist
if ((Test-Path -Path "$WMIOut_Path")-eq $false) {
    New-Item -Path $WMIOut_Path -ItemType Directory    
}
$PowerShellRemoting_Path=Join-Path -Path $Destination_Path -ChildPath "PowerShellRemoting"
#Check if PowerShellRemoting already exist
if ((Test-Path -Path "$PowerShellRemoting_Path")-eq $false) {
    New-Item -Path $PowerShellRemoting_Path -ItemType Directory    
}


## Convert evt to evtx
$Securityevt_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evt"
$Security_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evtx"
$Systemevt_Path= Join-Path -Path $Logs_Path -ChildPath "System.evt"
$System_Path= Join-Path -Path $Logs_Path -ChildPath "System.evtx"
$RDPCORETS_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
$RDPCORETSevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
$WMI_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evtx"
$WMIevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
$PowerShellOperational_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evtx"
$PowerShellOperationalevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
$WinPowerShell_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evtx"
$WinPowerShellevt_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
$WinRM_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evtx"
$WinRMevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
$TaskScheduler_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evtx"
$TaskSchedulerevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evt"
$TerminalServices_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
$TerminalServiceevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
$RemoteConnection_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"
$RemoteConnectionevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evt"

function Evt2Evtx {
    param (
        [Parameter(Mandatory=$true)]
        [string]$EvtPath,
        [Parameter(Mandatory=$true)]
        [string]$EvtxPath
    )
    if (((Test-Path -Path $EvtPath) -eq $true) -and ((Test-Path -Path $EvtxPath) -eq $false)) {
        wevtutil epl $EvtPath $EvtxPath /lf:true    
    }
    else {
        return
    }   
}
Evt2Evtx $Securityevt_Path $Security_Path
Evt2Evtx $Systemevt_Path  $System_Path
Evt2Evtx $RDPCORETSevt_Path $RDPCORETS_Path
Evt2Evtx $WMIevt_Path $WMI_Path
Evt2Evtx $WinPowerShellevt_Path $WinPowerShell_Path
Evt2Evtx $WinRMevt_Path $WinRM_Path
Evt2Evtx $TaskSchedulerevt_Path $TaskScheduler_Path
Evt2Evtx $TerminalServiceevt_Path $TerminalServices_Path
Evt2Evtx $RemoteConnectionevt_Path $RemoteConnection_Path
Evt2Evtx $PowerShellOperationalevt_Path $PowerShellOperational_Path
#Event Logs Paths

## Testing if the log file exist ? 
$Valid_Security_Path= Test-Path -Path $Security_Path
$Valid_System_Path= Test-Path -Path $System_Path
$Valid_RDPCORETS_Path= Test-Path -Path $RDPCORETS_Path
$Valid_WMI_Path= Test-Path -Path $WMI_Path
$Valid_PowerShellOperational_Path=Test-Path -Path $PowerShellOperational_Path
$Valid_WinPowerShell_Path= Test-Path -Path $WinPowerShell_Path
$Valid_WinRM_Path= Test-Path -Path $WinRM_Path
$Valid_TaskScheduler_Path= Test-Path -Path $TaskScheduler_Path
$Valid_TerminalServices_Path= Test-Path -Path $TerminalServices_Path
$Valid_RemoteConnection_Path= Test-Path -Path $RemoteConnection_Path
# array to stor results
#Dot-sourcing to the helper script
. .\Helper\helper.ps1
# calling function inside the script itself 
$OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "SuccessfulLogons.csv"
$Query1="SELECT TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain, EXTRACT_TOKEN(Strings, 8, '|') as LogonType,EXTRACT_TOKEN(strings, 9, '|') AS AuthPackage, EXTRACT_TOKEN(Strings, 11, '|') AS Workstation, EXTRACT_TOKEN(Strings, 17, '|') AS ProcessName, EXTRACT_TOKEN(Strings, 18, '|') AS SourceIP INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = 4624  And LogonType<>'5'"  
$OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "AdminLogonCreated.csv"
$Query2="Select TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 1, '|') AS Username, EXTRACT_TOKEN(Strings, 2, '|') AS Domain , EXTRACT_TOKEN(Strings, 3, '|') as LogonID INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = 4672"
$OutputFile= Join-Path -Path $Services_Path -ChildPath "InstalledServices.csv"
$Query3= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 5, '|') AS ServiceFileName, EXTRACT_TOKEN(Strings, 6, '|') AS ServiceType,  EXTRACT_TOKEN(Strings, 7, '|') AS ServiceStartType  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = 4697"
$OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "ComputerToValidate.csv"
$Query4="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = 4776 " 
$OutputFile= Join-Path -Path $RemoteDesktop_Path -ChildPath "RDPReconnected.csv"
$Query5= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO '$OutputFile' FROM '$Security_Path' WHERE EventID = 4778" 
$OutputFile= Join-Path -Path $MapNetworkShares_Path -ChildPath "NetworkShareAccessed.csv"
$Query6= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 5, '|') AS SourcePort, EXTRACT_TOKEN(Strings, 6, '|') AS ShareName INTO '$OutputFile' FROM '$Security_Path' WHERE EventID =5140"
$array=@($Query1,$Query2,$Query3,$Query4,$Query5,$Query6)
Measure-Command{ $array | ForEach-Object -parallel {

        LogParser.exe -stats:OFF -i:EVT $_
}-ThrottleLimit 6  } 
#====RemoteDesktop
Function main{
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "*            Remote Desktop                  *"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host "Parsing Successsful Logons"
SuccessfulLogons $NoSecurity
Write-Host "Parsing RDP Sessions Began"
RDPBegainSession
Write-Host "Parsing RDP Connections Attempts"
RDPConnectionsAttempts
Write-Host "Parsing RDP Connections Established"
RDPConnectionEstablished
Write-Host "Parsing RDP Local Successful Logons 1"
RDPLocalSuccessfulLogon1
Write-Host "Parsing RDP Local Successful Logons 2"
RDPLocalSuccessfulLogon2
Write-Host "Parsing RDP Successful TCP Connections"
RDPSuccessfulTCPConnections
Write-Host "Parsing RDP Sessions Reconnected"
RDPReconnected $NoSecurity
Write-Host "Parsing RDP Sessions Disconnected"
RDPDisconnected $NoSecurity
#=====MapNetworkShare
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "*            Map Network Share               *"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host "Parsing Network Share Object Accessed"
NetworkShareAccessed $NoSecurity
Write-Host "Parsing Network Share Object Checked"
NetworkShareChecked $NoSecurity
Write-Host "Parsing Admin Logons Created"
AdminLogonCreated $NoSecurity
Write-Host "Parsing Domain Controller attempts to validate accounts' credentials"
ComputerToValidate $NoSecurity
Write-Host "Parsing Kerberos Authentications Requested"
KerberosAuthenticationRequested $NoSecurity
Write-Host "Parsing Kerberos Services Requested"
KerberosServiceRequested $NoSecurity
#=======PsExec
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "*            Powershell Execution            *"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host "Parsing Installed Services [System Log]"
SystemInstalledServices

#=====ScheduledTasks 
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "*            Scheduled Tasks                 *"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host "Parsing Scheduled Tasks Created [Security Log]"
ScheduledTaskCreatedSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Deleted [Security Log]"
ScheduledTaskDeletedSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Enabled [Security Log]"
ScheduledTaskEnabledSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Disabled [Security Log]"
ScheduledTaskDisabledSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Updated [Security Log]"
ScheduledTaskUpdatedSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Created [Task Scheduler Log]"
ScheduledTasksCreatedTS 
Write-Host "Parsing Scheduled Tasks Deleted [Task Scheduler Log]"
ScheduledTasksDeletedTS 
Write-Host "Parsing Scheduled Tasks Executed [Task Scheduler Log]"
ScheduledTasksExecutedTS
Write-Host "Parsing Scheduled Tasks Completed [Task Scheduler Log]"
ScheduledTasksCompletedTS
Write-Host "Parsing Scheduled Tasks Updated [Task Scheduler Log]"
ScheduledTasksUpdatedTS

#======WMI 
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "*                WMI/WMIC                    *"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host "Parsing WMI Operations Started"
WMIOperationStarted
Write-Host "Parsing WMI Operations Temporary Ess Started"
WMIOperationTemporaryEssStarted
Write-Host "Parsing WMI Operations To Consumer Binding"
WMIOperationESStoConsumerBinding


#=====Services
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "*                Services                    *"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host "Parsing Installed Services [Security Log]"
InstalledServices $NoSecurity
Write-Host "Parsing Services Crashed Unexpectedely"
ServiceCrashedUnexpect
Write-Host "Parsing Services Status"
ServicesStatus
Write-Host "Parsing Services Requested Start Stop Controls"
ServiceSentStartStopControl
Write-Host "Parsing Services Start Type Changed"
ServiceStartTypeChanged

#======PowerShellRemoting 
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "*            PowerShellRemoting              *"  -ForegroundColor yellow -BackgroundColor black
Write-Host  "**********************************************"  -ForegroundColor yellow -BackgroundColor black
Write-Host "Parsing PowerShell Module Logging"
PSModuleLogging
Write-Host "Parsing PowerShell Script Blocking Logging"
PSScriptBlockLogging
Write-Host "Parsing PowerShell Authneticating User"
PSAuthneticatingUser
Write-Host "Parsing PowerShell Partial Code"
PSPartialCode
Write-Host "Parsing Session Created"
SessionCreated
Write-Host "Parsing WinRM Authenticating User "
WinRMAuthneticatingUser
Write-Host "Parsing Server Remote Hosts Started"
ServerRemoteHostStarted
Write-Host "Parsing Server Remote Host Ended"
ServerRemoteHostEnded
}
#main
$ResultsArray| Out-GridView
