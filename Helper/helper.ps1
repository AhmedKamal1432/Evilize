Write-Host  "Welcome to Evilize" 
$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path" 
$Destination_Path=Read-Host -Prompt "Please, Enter Path of Results you want to save to"

##Validating Paths
$LogsPathTest=Test-Path -Path "$Logs_Path"
$DestPathTest=Test-Path -Path "$Destination_Path"
if((($LogsPathTest -eq $true) -and ($DestPathTest -eq $true)) -ne $true ){
        Write-Host "Error 0x001: Invalid Paths, Enter a valid path"
        exit
    }
##Create Results Directory

$Destination_Path= Join-Path -Path $Destination_Path -ChildPath "Results"
$DestPathTest=Test-Path -Path "$Destination_Path"
#check if it's already exist
if ($DestPathTest -eq $false) {
    New-Item -Path $Destination_Path -ItemType Directory    
}

#Event Logs Paths
$Security_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evtx"
$System_Path= Join-Path -Path $Logs_Path -ChildPath "System.evtx"
$RDPCORETS_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
$WMI_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evtx"
$PowerShellOperational_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evtx"
$WinPowerShell_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evtx"
$WinRM_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evtx"
$TaskScheduler_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evtx"
$TerminalServices_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
$RemoteConnection_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"



function GetStats {
    param (
        # Parameter help description
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    $Valid=Test-Path -Path "$FilePath"
    if($Valid -eq $true){
        $NumRows=LogParser.exe -i:csv -stats:OFF "Select Count (*) from '$FilePath'" | Out-String
        $NumRows.Substring([int](29)) 
    } 
    else {
        Return 0
    }
}
function SuccessfulLogons {
    $EventID=4624
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "SuccessfulLogons.csv"
    $Query="SELECT TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 5, '|') as Username, EXTRACT_TOKEN(Strings, 6, '|') as Domain, EXTRACT_TOKEN(Strings, 8, '|') as LogonType,EXTRACT_TOKEN(strings, 9, '|') AS AuthPackage, EXTRACT_TOKEN(Strings, 11, '|') AS Workstation, EXTRACT_TOKEN(Strings, 17, '|') AS ProcessName, EXTRACT_TOKEN(Strings, 18, '|') AS SourceIP INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID  And LogonType<>'5'"  
    LogParser.exe -stats:OFF -i:EVT $Query
    $SuccessfulLogons= GetStats $OutputFile
    Write-Host "Successful Logons:" $SuccessfulLogons
}


function AdminLogonCreated  {
    $EventID=4672
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "AdminLogonCreated.csv"
    $Query="Select TimeGenerated,EventID , EXTRACT_TOKEN(Strings, 1, '|') AS Username, EXTRACT_TOKEN(Strings, 2, '|') AS Domain , EXTRACT_TOKEN(Strings, 3, '|') as LogonID INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $AdminLogonsCreated= GetStats $OutputFile
    Write-Host "Admin Logons Created: " $AdminLogonsCreated
    
}


function InstalledServices {
    $EventID=4697
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "InstalledServices.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 5, '|') AS ServiceFileName, EXTRACT_TOKEN(Strings, 6, '|') AS ServiceType,  EXTRACT_TOKEN(Strings, 7, '|') AS ServiceStartType  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $InstalledServices= GetStats $OutputFile
    Write-Host "Installed Services [Security Log]: " $InstalledServices
    
}



function ScheduledTaskCreated {
    $EventID=4698
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTaskCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskCreated= GetStats $OutputFile
    Write-Host "Scheduled Tasks Created: " $ScheduledTaskCreated
    
}

function ScheduledTaskDeleted {
    $EventID=4699
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTaskDeleted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskDeleted= GetStats $OutputFile
    Write-Host "Scheduled Tasks Deleted: " $ScheduledTaskDeleted
    
}

function ScheduledTaskEnabled {
    $EventID=4700
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTaskEnabled.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskEnabled= GetStats $OutputFile
    Write-Host "Scheduled Tasks Enbaled: " $ScheduledTaskEnabled 
}

function ScheduledTaskDisabled{
    $EventID=4701
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTaskDisabled.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskDisabled= GetStats $OutputFile
    Write-Host "Scheduled Tasks Disabled: " $ScheduledTaskDisabled 
}


function ScheduledTaskUpdated{
    $EventID=4702
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTaskUpdated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS TaskName, EXTRACT_TOKEN(Strings, 5, '|') AS TaskContent  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTaskUpdated= GetStats $OutputFile
    Write-Host "Scheduled Tasks Updated: " $ScheduledTaskUpdated 
}


function KerberosAuthenticationRequested {
    $EventID=4768
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "KerberosAuthenticationRequested.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 9, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 10, '|') AS SourcePort INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $KerberosAuthenticationRequested= GetStats $OutputFile
    Write-Host "Kerberos Authentication Tickets Requested: " $KerberosAuthenticationRequested 
    
}

function KerberosServiceRequested {
    $EventID=4769
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "KerberosServiceRequested.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS AccountName, EXTRACT_TOKEN(Strings, 1, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceName ,EXTRACT_TOKEN(Strings, 6, '|') AS SourceIP , EXTRACT_TOKEN(Strings, 7, '|') AS SourcePort INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $KerberosServiceRequested= GetStats $OutputFile
    Write-Host "Kerberos Services Tickets Requested: " $KerberosServiceRequested 
    
    
}

function ComputerToValidate  {
    $EventID=4776
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ComputerToValidate.csv"
    $Query="Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID " 
    LogParser.exe -stats:OFF -i:EVT $Query
    $ComputerToValidate= GetStats $OutputFile
    Write-Host "Computer To Validate: " $ComputerToValidate

}

function RDPReconnected  {
    $EventID=4778
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPReconnected.csv"
    $Query= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID" 
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPReconencted= GetStats $OutputFile
    Write-Host "RDP sessions reconnected: " $RDPReconencted

    
}


function RDPDisconnected  {
    $EventID=4779
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPDisconnected.csv"
    $Query= "SELECT TimeGenerated,EventID ,EXTRACT_TOKEN(Strings, 0, '|') AS Username, EXTRACT_TOKEN(Strings, 1, '|') AS Domain, EXTRACT_TOKEN(Strings, 4, '|') AS Workstation, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP  INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID" 
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPDisconnected= GetStats $OutputFile
    Write-Host "RDP sessions Disconnected: " $RDPDisconnected   
}
function NetworkShareAccessed  {
    $EventID=5140
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "NetworkShareAccessed.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccountName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 5, '|') AS SourcePort, EXTRACT_TOKEN(Strings, 6, '|') AS ShareName INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $NetworkShareAccessed= GetStats $OutputFile
    Write-Host "Network Share Objects Accessed: " $NetworkShareAccessed
}

function NetworkShareChecked  {
    $EventID=5145
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "NetworkShareChecked.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 1, '|') AS AccounName, EXTRACT_TOKEN(Strings, 2, '|') AS AccountDomain, EXTRACT_TOKEN(Strings, 3, '|') AS LogonID , EXTRACT_TOKEN(Strings, 4, '|') AS ObjectType, EXTRACT_TOKEN(Strings, 5, '|') AS SourceIP, EXTRACT_TOKEN(Strings, 6, '|') AS SourePort, EXTRACT_TOKEN(Strings, 7, '|') AS ShareName, EXTRACT_TOKEN(Strings, 8, '|') AS SharePath, EXTRACT_TOKEN(Strings, 11, '|') as Accesses, EXTRACT_TOKEN(Strings, 12, '|') as AccessesCheckResult INTO $OutputFile FROM '$Security_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $NetworkShareChecked= GetStats $OutputFile
    Write-Host "Network Share Objects Checked : " $NetworkShareChecked
}



function ServiceCrashedUnexpect {
    $EventID=7034
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ServiceCrashedUnexpect.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS Times INTO $OutputFile FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceCrashedUnexpect= GetStats $OutputFile
    Write-Host "Services Crashed unexpectedly [System Log]: " $ServiceCrashedUnexpect
}

function ServicesStatus {
    $EventID=7036
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ServicesStatus.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS State INTO $OutputFile FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServicesStatus= GetStats $OutputFile
    Write-Host "Services Stopped Or Started: " $ServicesStatus
 
}
function ServiceSentStartStopControl {
    $EventID=7035
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ServiceSentStartStopControl.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS RequestSent INTO $OutputFile FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceSentStartStopControl= GetStats $OutputFile
    Write-Host "Services Sent Stop/Start Control [System Log]: " $ServiceSentStartStopControl
}

function ServiceStartTypeChanged {
    $EventID=7040
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ServiceStartTypeChanged.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ChangedFrom , EXTRACT_TOKEN(Strings, 2, '|') AS ChangedTo INTO $OutputFile FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServiceStartTypeChanged= GetStats $OutputFile
    Write-Host "Services Start Type Changed [System Log]: " $ServiceStartTypeChanged
}

function SystemInstalledServices {
    $EventID=7045
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "SystemInstalledServices.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ServiceName, EXTRACT_TOKEN(Strings, 1, '|') AS ImagePath, EXTRACT_TOKEN(Strings, 2, '|') AS ServiceType , EXTRACT_TOKEN(Strings, 3, '|') AS StartType, EXTRACT_TOKEN(Strings, 4, '|') AS AccountName INTO $OutputFile FROM '$System_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $SystemInstalledServices= GetStats $OutputFile
    Write-Host "Services Installed on System [System Log]: " $SystemInstalledServices
}

########################################## WMI ################################################
function WMIOperationStarted {
    $EventID=5857
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "WMIOperationStarted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ProviderName, EXTRACT_TOKEN(Strings, 1, '|') AS Code, EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ProviderPath INTO $OutputFile FROM '$WMI_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WMIOperationStarted= GetStats $OutputFile
    Write-Host "WMI Operations Started [WMI Log]: " $WMIOperationStarted    
}


function WMIOperationTemporaryEssStarted {
    $EventID=5860
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "WMIOperationTemporaryEssStarted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS Query,EXTRACT_TOKEN(Strings, 2, '|') AS User ,EXTRACT_TOKEN(Strings, 3, '|') AS ProcessID, EXTRACT_TOKEN(Strings, 4, '|') AS ClientMachine INTO $OutputFile FROM '$WMI_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WMIOperationTemporaryEssStarted= GetStats $OutputFile
    Write-Host "WMI Operations ESS Started [WMI Log]: " $WMIOperationTemporaryEssStarted    
}


function WMIOperationESStoConsumerBinding {
    $EventID=5861
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "WMIOperationESStoConsumerBinding.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS NameSpace, EXTRACT_TOKEN(Strings, 1, '|') AS ESS,EXTRACT_TOKEN(Strings, 2, '|') AS Consumer ,EXTRACT_TOKEN(Strings, 3, '|') AS PossibleCause INTO $OutputFile FROM '$WMI_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WMIOperationESStoConsumerBinding= GetStats $OutputFile
    Write-Host "WMI Operations ESS to Consumer Binding [WMI Log]: " $WMIOperationESStoConsumerBinding    
}


#===============Microsoft-Windows-PowerShell%4Operational.evtx=========
function PSModuleLogging {
    $EventID=4103
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "PSModuleLogging.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ContextINFO, EXTRACT_TOKEN(Strings, 2, '|') AS Payload INTO $OutputFile FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PSModuleLogging= GetStats $OutputFile
    Write-Host "PS Modules Logged : " $PSModuleLogging

}

function PSScriptBlockLogging  {
    $EventID=4104
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "PSScriptBlockLogging.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS MessageNumber, EXTRACT_TOKEN(Strings, 1, '|') AS TotalMessages, EXTRACT_TOKEN(Strings, 2, '|') AS ScriptBlockText , EXTRACT_TOKEN(Strings, 3, '|') AS ScriptBlockID , EXTRACT_TOKEN(Strings,4 , '|') AS ScriptPath INTO $OutputFile FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PSScriptBlockLogging= GetStats $OutputFile
    Write-Host "PS Script Blocks Logged : " $PSScriptBlockLogging
    
}    

function PSAuthneticatingUser  {
    $EventID=53504
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "PSAuthneticatingUser.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS Process, EXTRACT_TOKEN(Strings, 1, '|') AS AppDomain INTO $OutputFile FROM '$PowerShellOperational_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PSAuthneticatingUser= GetStats $OutputFile
    Write-Host "PS Authenticating User : " $PSAuthneticatingUser
    
}
  
function SessionCreated {
    $EventID=91
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "SessionCreated.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_TOKEN(Strings, 0, '|') AS ResourceUrl INTO $OutputFile FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $SessionCreated= GetStats $OutputFile
    Write-Host "Session Created [WinRM log] : " $SessionCreated
    
}  

function WinRMAuthneticatingUser {
    $EventID=168
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "WinRMAuthneticatingUser.csv"
    $Query= "Select TimeGenerated,EventID, Message INTO $OutputFile FROM '$WinRM_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $WinRMAuthneticatingUser= GetStats $OutputFile
    Write-Host "WinRM Authenticating User  [WinRM log] : " $WinRMAuthneticatingUser

}

#####======= Windows PowerShell.evtx======
function ServerRemoteHostStarted {
    $EventID=400
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ServerRemoteHostStarted.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO $OutputFile FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServerRemoteHostStarted= GetStats $OutputFile
    Write-Host "ServerRemoteHosts Started : " $ServerRemoteHostStarted

    
}
function ServerRemoteHostEnded {
    $EventID=403
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ServerRemoteHostEnded.csv"
    $Query= "Select TimeGenerated,EventID,  EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication INTO $OutputFile FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ServerRemoteHostEnded= GetStats $OutputFile
    Write-Host "ServerRemoteHosts Ended : " $ServerRemoteHostEnded
}

function PSPartialCode {
    $EventID=800
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "PSPartialCode.csv"
    $Query= "Select TimeGenerated,EventID, EXTRACT_Suffix(Message, 0, 'HostApplication=') AS HostApplication  INTO $OutputFile FROM '$WinPowerShell_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $PSPartialCode= GetStats $OutputFile
    Write-Host "Partial Scripts Code : " $PSPartialCode   
}

#==============Task Scheduler=============

function ScheduledTasksCreated {
    $EventID=106
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTasksCreated.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO $OutputFile FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksCreated= GetStats $OutputFile
    Write-Host "Scheduled Tasks Updated : " $ScheduledTasksCreated  
 
}

function ScheduledTasksUpdated {
    $EventID=140
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTasksUpdated.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO $OutputFile FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksUpdated= GetStats $OutputFile
    Write-Host "Scheduled Tasks Updated : " $ScheduledTasksUpdated  
 
}

function ScheduledTasksDeleted {
    $EventID=141
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTasksDeleted.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as TaskName, extract_token(strings, 1, '|') as User INTO $OutputFile FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksDeleted= GetStats $OutputFile
    Write-Host "Scheduled Tasks Deleted : " $ScheduledTasksDeleted  
 
}

function ScheduledTasksExecuted {
    $EventID=200
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTasksExecuted.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO $OutputFile FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksExecuted= GetStats $OutputFile
    Write-Host "Scheduled Tasks Executed : " $ScheduledTasksExecuted  
}


function ScheduledTasksCompleted {
    $EventID=201
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "ScheduledTasksCompleted.csv"
    $Query= "Select TimeGenerated,EventID, extract_token(strings,0, '|') as TaskName, extract_token(strings, 1, '|') as TaskAction, extract_token(strings, 2, '|') as Instance  INTO $OutputFile FROM '$TaskScheduler_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $ScheduledTasksCompleted= GetStats $OutputFile
    Write-Host "Scheduled Tasks Completed : " $ScheduledTasksCompleted  
}

##============= Terminal Services=======
function RDPLocalSuccessfulLogon1 {
    $EventID=21
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPLocalSuccessfulLogon1.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO $OutputFile FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPLocalSuccessfulLogon1= GetStats $OutputFile
    Write-Host "RDP Local Successful Logons [EventID=21] : " $RDPLocalSuccessfulLogon1 
}

function RDPLocalSuccessfulLogon2 {
    $EventID=22
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPLocalSuccessfulLogon2.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO $OutputFile FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPLocalSuccessfulLogon2= GetStats $OutputFile
    Write-Host "RDP Local Successful Logons [EventID=22]: " $RDPLocalSuccessfulLogon2 
}

function RDPLocalSuccessfulReconnection {
    $EventID=22
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPLocalSuccessfulReconnection.csv"
    $Query= "Select TimeGenerated,EventID , extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as SessionID ,extract_token(strings,2, '|') as SourceIP   INTO $OutputFile FROM '$TerminalServices_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPLocalSuccessfulReconnection= GetStats $OutputFile
    Write-Host "RDP Local Successful Reconnections: " $RDPLocalSuccessfulReconnection 
}

#=========================Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx=======================
function RDPConnectionEstablished {
    $EventID=1149
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPConnectionEstablished.csv"
    $Query= "Select TimeGenerated,EventID  ,extract_token(strings, 0, '|') as User, extract_token(strings, 1, '|') as Domain ,extract_token(strings,2, '|') as SourceIP   INTO $OutputFile FROM '$RemoteConnection_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPConnectionEstablished= GetStats $OutputFile
    Write-Host "RDP Connections Established: " $RDPConnectionEstablished 
    
    
}


#============Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx=============

function RDPConnectionsAttempts {
    $EventID=131
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPConnectionsAttempts.csv"
    $Query= "Select TimeGenerated,EventID  ,extract_token(strings, 0, '|') as ConnectionType, extract_token(strings, 1, '|') as CLientIP INTO $OutputFile FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPConnectionsAttempts= GetStats $OutputFile
    Write-Host "RDP Connections Attempts : " $RDPConnectionsAttempts 
}

function RDPSuccessfulTCPConnections {
    $EventID=98
    $OutputFile= Join-Path -Path $Destination_Path -ChildPath "RDPSuccessfulTCPConnections.csv"
    $Query= "Select TimeGenerated,EventID  INTO $OutputFile FROM '$RDPCORETS_Path' WHERE EventID = $EventID"
    LogParser.exe -stats:OFF -i:EVT $Query
    $RDPSuccessfulTCPConnections= GetStats $OutputFile
    Write-Host "RDP Successful TCP Connections: " $RDPSuccessfulTCPConnections 
}
