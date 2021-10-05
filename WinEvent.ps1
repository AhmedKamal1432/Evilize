Write-host "
    ______           _     __    _            
   / ____/ _   __   (_)   / /   (_) ____  ___ 
  / __/   | | / /  / /   / /   / / /_  / / _ \
 / /___   | |/ /  / /   / /   / /   / /_/  __/
/_____/   |___/  /_/   /_/   /_/   /___/\___/ 
                                              
" -ForegroundColor Red -BackgroundColor black
Write-host "  
                                                          _____ 
\            / _   |\   |    ___    _   __   ___   |\   |   |
 \    /\    / (_)  | \  |   / _ \  | | / /  / _ \  | \  |   |
  \  /  \  /  | |  |  \ |  /  __/  | |/ /  /  __/  |  \ |   |
   \/    \/   |_|  |   \|  \___/   |___/   \___/   |   \|   |
" -ForegroundColor Red -BackgroundColor black
#inputing the log path
$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path" 
$securityparam= Read-Host -Prompt "Do you want to parse the security event log? yes\no [default is no because security event is usually very big]"

#making results and its sub directories
$Destination_Path= Join-Path -Path $Logs_Path -ChildPath "Results"
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
$ExtraEvents_Path=Join-Path -Path $Destination_Path -ChildPath "ExtraEvents"
#Check if ExtraEvents already exist
if ((Test-Path -Path "$ExtraEvents_Path")-eq $false) {
    New-Item -Path $ExtraEvents_Path -ItemType Directory    
}

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

#converting evt to evtx files
$evtFiles = Get-ChildItem -Recurse -Path $Logs_Path -filter (-NOT '*.evtx') 
if (-NOT ($evtFiles -eq $null)){
	## Convert evt to evtx
	$Securityevt_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evt"
	$Systemevt_Path= Join-Path -Path $Logs_Path -ChildPath "System.evt"
	$RDPCORETSevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
	$WMIevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
	$PowerShellOperationalevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
	$WinPowerShellevt_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
	$WinRMevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
	$TaskSchedulerevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evt"
	$TerminalServiceevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
	$RemoteConnectionevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evt"

	function Evt2Evtx {
		param (
			[Parameter(Mandatory=$true)]
			[string]$EvtPath,
			[Parameter(Mandatory=$true)]
			[string]$EvtxPath
		)
			if (((Test-Path -Path $EvtPath) -eq $true) -and ((Test-Path -Path $EvtxPath) -eq $false)) {
		wevtutil epl $EvtPath $EvtxPath /lf:true }     
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
}

## Testing if the log file exist ? 
$LogsPathTest=Test-Path -Path "$Logs_Path"
##Validating Paths
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

$ResultsArray=@()
#Remote desktop
. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
. .\PSFunctions\RemoteDesktop\RDPreconnected.ps1
. .\PSFunctions\RemoteDesktop\RDPDisconnected.ps1
. .\PSFunctions\RemoteDesktop\RDPConnectionAttempts.ps1
. .\PSFunctions\RemoteDesktop\RDPSuccessfulConnections.ps1
. .\PSFunctions\RemoteDesktop\UserAuthSucceeded.ps1
. .\PSFunctions\RemoteDesktop\RDPSessionLogonSucceed.ps1
. .\PSFunctions\RemoteDesktop\RDPShellStartNotificationReceived.ps1
. .\PSFunctions\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
. .\PSFunctions\RemoteDesktop\RDPbeginSession.ps1
. .\PSFunctions\RemoteDesktop\ExplicitCreds.ps1
. .\PSFunctions\RemoteDesktop\RDPConnectingtoServer.ps1

#Map network shares
. .\PSFunctions\MapNetworkShares\AdminLogonCreated.ps1
. .\PSFunctions\MapNetworkShares\ComputerToValidate.ps1
. .\PSFunctions\MapNetworkShares\KerberosAuthRequest.ps1
. .\PSFunctions\MapNetworkShares\KerberosServiceRequest.ps1
. .\PSFunctions\MapNetworkShares\NetworkShareAccessed.ps1
. .\PSFunctions\MapNetworkShares\AuditingofSharedfiles.ps1
#PSExec
. .\PSFunctions\PsExec\ServiceInstall.ps1
#Scheduled Tasks
. .\PSFunctions\ScheduledTasks\ScheduleTaskCreated.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskDeleted.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskEnabled.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskDisabled.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskUpdated.ps1
. .\PSFunctions\ScheduledTasks\CreatingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\DeletingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\CompletingTaskSchedulerTask.ps1
#Services
. .\PSFunctions\Services\ServiceInstalledonSystem.ps1
. .\PSFunctions\Services\ServiceCrashed.ps1
. .\PSFunctions\Services\ServiceSentControl.ps1
. .\PSFunctions\Services\ServiceStartorStop.ps1
. .\PSFunctions\Services\StartTypeChanged.ps1
#	WMI\WMIC
. .\PSFunctions\WMI_WMIC\SystemQueryWMI.ps1
. .\PSFunctions\WMI_WMIC\TemporaryEventConsumer.ps1
. .\PSFunctions\WMI_WMIC\PermenantEventConsumer.ps1
#PowerShellRemoting
. .\PSFunctions\PowerShellRemoting\ScriptBlockLogging.ps1
. .\PSFunctions\PowerShellRemoting\ScriptBlockAuditing.ps1
. .\PSFunctions\PowerShellRemoting\LateralMovementDetection.ps1
. .\PSFunctions\PowerShellRemoting\StartPSRemoteSession.ps1
. .\PSFunctions\PowerShellRemoting\EndPSRemoteSession.ps1
. .\PSFunctions\PowerShellRemoting\PipelineExecution.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManSession.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManCommand.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManShell.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
. .\PSFunctions\PowerShellRemoting\CreatingRunspaceObject.ps1
. .\PSFunctions\PowerShellRemoting\CreatingRunspacePoolObject.ps1
. .\PSFunctions\PowerShellRemoting\RunspaceState.ps1
#extra events
. .\PSFunctions\ExtraEvents\UnsuccessfulLogons.ps1
. .\PSFunctions\ExtraEvents\EventlogCleared.ps1

# Remote Access
	#Remote desktop
		#destination#
if ($securityparam -eq "yes") {
 if ($Valid_Security_Path -eq $true) {

$x= Get-AllSuccessfulLogons -Path $Security_Path  
write-host  "Number of AllSuccessfulLogons:" , $x.count
$x| Export-Csv -Path $RemoteDesktop_Path\AllSuccessfulLogons.csv -NoTypeInformation 
$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="RemoteDesktop"; Event="All Successful Logons"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPreconnected -Path $Security_Path  
write-host  "Number of RDPreconnected  events:" , $x.count
$x|  Export-Csv -Path $RemoteDesktop_Path\RDPreconnected.csv -NoTypeInformation 
$hash= New-Object PSObject -property @{EventID="4778"; SANSCateogry="RemoteDesktop"; Event="RDP sessions reconnected"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPDisconnected -Path $Security_Path 
write-host  "Number of RDPDisconnected  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPDisconnected.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4779"; SANSCateogry="RemoteDesktop"; Event="RDP sessions disconnected"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
	}
 else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red
        
 }
}
else {
	write-host " AllSuccessfulLogons- RDPreconnected -RDPDisconnected depend on Security event log which you choose not to parse" -ForegroundColor Red
}

if ($Valid_RDPCORETS_Path -eq $true) {

$x= Get-RDPConnectionAttempts -Path $RDPCORETS_Path  
write-host  "Number of RDPConnectionAttempts  events:" , $x.count
$x | Export-Csv -Path $RemoteDesktop_Path\RDPConnectionAttempts.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="RemoteDesktop"; Event="RDP Connection Attempts"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash


$x= Get-RDPSuccessfulConnections -Path $RDPCORETS_Path 
$x=write-host  "Number of RDPSuccessfulConnections  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPSuccessfulConnections.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="98";SANSCateogry="RemoteDesktop"; Event="RDP Successful Connections"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
          }

if ($Valid_RemoteConnection_Path -eq $true) {

$x= Get-UserAuthSucceeded -Path $RemoteConnection_Path  
write-host  "Number of UserAuthSucceeded  events:" , $x.count
$x | Export-Csv -Path $RemoteDesktop_Path\UserAuthSucceeded.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="1149";SANSCateogry="RemoteDesktop"; Event="User authentication succeeded"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else { write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
          }

if ($Valid_TerminalServices_Path -eq $true) {

$x= Get-RDPSessionLogonSucceed -Path $TerminalServices_Path 
write-host  "Number of RDPSessionLogonSucceed  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPSessionLogonSucceed.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="21";SANSCateogry="RemoteDesktop"; Event="RDP Session Logon suceeded"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  
write-host  "Number of RDPShellStartNotificationReceived  events:" , $x.count
$x | Export-Csv -Path $RemoteDesktop_Path\RDPShellStartNotificationReceived.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="22";SANSCateogry="RemoteDesktop"; Event="RDP Shell Start Notification recieved"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path 
write-host  "Number of RDPShellSessionReconnectedSucceeded  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="25";SANSCateogry="RemoteDesktop"; Event="RDP Shell Session reconnection succeeded"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPbeginSession -Path $TerminalServices_Path 
write-host  "Number of RDPbeginSession  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPbeginSession.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="41";SANSCateogry="RemoteDesktop"; Event="RDP Begin Session"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else { write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
         }

# Remote Access
	#Remote desktop
		#source
#if ($securityparam -eq "yes") {
 #if ($Valid_Security_Path -eq $true) {

#$x= Get-ExplicitCreds -Path $Security_Path  
#write-host  "Number of ExplicitCreds  events:" , $x.count
#$x | Export-Csv -Path $RemoteDesktop_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="RemoteDesktop"; Event="Exolicit Credentials"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash
	#}
 #else{ 
  #write-host "Error: Security event log is not found" -ForegroundColor Red  
 #}
#}
#else {
#	write-host " ExplicitCreds depends on Security event log which you choose not to parse" -ForegroundColor Red
#}

if ($Valid_RDPCORETS_Path -eq $true) {

#$x= Get-RDPConnectingtoServer -Path $RDPCORETS_Path  
#write-host  "Number of RDPConnectingtoServer  events:" , $x.count
#$x | Export-Csv -Path $RemoteDesktop_Path\RDPConnectingtoServer.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="1024";SANSCateogry="RemoteDesktop"; Event="RDP Connecting to Server"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash


}
else{ write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
       }
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#. .\PSFunctions\MapNetworkShares\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\AllSuccessfulLogons.csv -NoTypeInformation
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\MapNetworkSharescsv\AllSuccessfulLogons.csv).Length -1)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="MapNetworkShares"; Event="Succesful Logons"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash 

$x= Get-AdminLogonCreated -Path $Security_Path  
write-host  "Number of AdminLogonCreated  events:" , $x.count
$x | Export-Csv -Path $MapNetworkShares_Path\AdminLogonCreated.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="MapNetworkShares"; Event="Admin Logon created"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ComputerToValidate -Path $Security_Path 
write-host  "Number of ComputerToValidate  events:" , $x.count
$x  | Export-Csv -Path $MapNetworkShares_Path\ComputerToValidate.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4776";SANSCateogry="MapNetworkShares"; Event="Computer to validate"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-KerberosAuthRequest -Path $Security_Path 
write-host  "Number of KerberosAuthRequest  events:" , $x.count
$x  | Export-Csv -Path $MapNetworkShares_Path\KerberosAuthRequest.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4768";SANSCateogry="MapNetworkShares"; Event="Kerberos Authentication Request"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-KerberosServiceRequest -Path $Security_Path 
write-host  "Number of KerberosServiceRequest  events:" , $x.count
$x  | Export-Csv -Path $MapNetworkShares_Path\KerberosServiceRequest.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4769";SANSCateogry="MapNetworkShares"; Event="Kerberos Service Request"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-NetworkShareAccessed -Path $Security_Path  
write-host  "Number of NetworkShareAccessed  events:" , $x.count
$x| Export-Csv -Path $MapNetworkShares_Path\NetworkShareAccessed.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5140";SANSCateogry="MapNetworkShares"; Event="Network Share Accessed"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-AuditingofSharedfiles -Path $Security_Path  
write-host  "Number of AuditingofSharedfiles  events:" , $x.count
$x| Export-Csv -Path $MapNetworkShares_Path\AuditingofSharedfiles.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5145";SANSCateogry="MapNetworkShares"; Event="Auditing of Shared Files"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

# Remote Access 
	#Map Network Shares
		# source
#. .\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="MapNetworkShares"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash
#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination

#. .\PSFunctions\PsExec\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $PsExec_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $PsExec_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="PSExec"; Event="Successful Logons"; NumberOfOccurences=(Import-Csv $PsExec_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PsExec\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $PsExec_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $PsExec_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="PSExec"; Event="Admin Logon created"; NumberOfOccurences=(Import-Csv $PsExec_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PsExec\NetworkShareAccessed.ps1
#Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path $PsExec_Path\NetworkShareAccessed.csv -NoTypeInformation
#write-host  "Number of NetworkShareAccessed  events:" , ((Import-Csv $PsExec_Path\NetworkShareAccessed.csv).count)
#$hash= New-Object PSObject -property @{EventID="5140";SANSCateogry="PSExec"; Event="Network Share Accessed"; NumberOfOccurences=(Import-Csv $PsExec_Path\NetworkShareAccessed.csv).count}
#$ResultsArray+=$hash
	}
	 else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
write-host " AdminLogonCreated- ComputerToValidate-KerberosAuthRequest-KerberosServiceRequest-NetworkShareAccessed-AuditingofSharedfiles depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_System_Path -eq $true) {

$x= Get-ServiceInstall -Path $System_Path  
write-host  "Number of ServiceInstall  events:" , $x.count
$x | Export-Csv -Path $PsExec_Path\ServiceInstall.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7045";SANSCateogry="PSExec"; Event="Installed Service"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: System event log is not found" -ForegroundColor Red   
}

#Remote Execution
	#PsExec
		#source
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#. .\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $PsExec_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="PSExec"; Event="Exolicit Credentials"; NumberOfOccurences=(Import-Csv $PsExec_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash

############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination

#. .\PSFunctions\ScheduledTasks\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path $ScheduledTasks_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $ScheduledTasks_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="ScheduledTasks"; Event="Successful Logons"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\ScheduledTasks\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $ScheduledTasks_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $ScheduledTasks_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="ScheduledTasks"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash

$x= Get-ScheduleTaskCreated -Path $Security_Path
write-host  "Number of ScheduleTaskCreated  events:" , $x.count
$x  | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskCreated.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4698";SANSCateogry="ScheduledTasks"; Event="Schedule Task Created"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskDeleted -Path  $Security_Path 
write-host  "Number of ScheduleTaskDeleted  events:" , $x.count
$x| Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskDeleted.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4699";SANSCateogry="ScheduledTasks"; Event="Schedule Task Deleted"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskEnabled -Path  $Security_Path 
write-host  "Number of ScheduleTaskEnabled  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskEnabled.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4700";SANSCateogry="ScheduledTasks"; Event="Schedule Task Enabled"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskDisabled -Path  $Security_Path 
write-host  "Number of ScheduleTaskDisabled  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskDisabled.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4701";SANSCateogry="ScheduledTasks"; Event="Schedule Task Disabled"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskUpdated -Path  $Security_Path 
write-host  "Number of ScheduleTaskUpdated  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskUpdated.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4702";SANSCateogry="ScheduledTasks"; Event="Schedule Task Updated"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
	}
	else{ 
	  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
write-host " ScheduleTaskCreated- ScheduleTaskDeleted-ScheduleTaskEnabled-ScheduleTaskDisabled-ScheduleTaskUpdated depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_TaskScheduler_Path -eq $true) {

$x= Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path 
write-host  "Number of CreatingTaskSchedulerTask  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\CreatingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="106";SANSCateogry="ScheduledTasks"; Event="Creating TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path
write-host  "Number of UpdatingTaskSchedulerTask  events:" , $x.count
$x  | Export-Csv -Path $ScheduledTasks_Path\UpdatingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="140";SANSCateogry="ScheduledTasks"; Event="Updating TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path 
write-host  "Number of DeletingTaskSchedulerTask  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\DeletingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="141";SANSCateogry="ScheduledTasks"; Event="Deleting TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path
write-host  "Number of ExecutingTaskSchedulerTask  events:" , $x.count
$x  | Export-Csv -Path $ScheduledTasks_Path\ExecutingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="200";SANSCateogry="ScheduledTasks"; Event="Executing TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path 
write-host  "Number of CompletingTaskSchedulerTask  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\CompletingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="201";SANSCateogry="ScheduledTasks"; Event="Completing TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Microsoft-Windows-TaskScheduler%4Maintenance event log is not found" -ForegroundColor Red   
}

#Remote Execution
	#Scheduled Tasks
		#source
#. .\ScheduledTasks\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $ScheduledTasks_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="ScheduledTasks"; Event="Explicit credentials"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash

#####################################################################################################################################
#Remote Execution
	#services
		#destination

#. .\PSFunctions\Services\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $Services_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $Services_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="Services"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $Services_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

$x= Get-ServiceInstalledonSystem -Path $Security_Path  
write-host  "Number of ServiceInstalledonSystem  events:" , $x.count
$x | Export-Csv -Path $Services_Path\ServiceInstalledonSystem.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4697";SANSCateogry="Services"; Event="Service Installed on System"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
	}
	else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
 write-host "ServiceInstalledonSystem depend on Security event log which you choose not to parse" -ForegroundColor Red
}

if ($Valid_System_Path -eq $true) {

$x= Get-ServiceCrashed -Path $System_Path  
write-host  "Number of ServiceCrashed  events:" , $x.count
$x | Export-Csv -Path $Services_Path\ServiceCrashed.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7034";SANSCateogry="Services"; Event="Service Crashed"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ServiceSentControl -Path $System_Path  
write-host  "Number of ServiceSentControl  events:" , $x.count
$x | Export-Csv -Path $Services_Path\ServiceSentControl.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7035";SANSCateogry="Services"; Event="Service Sent Control"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ServiceStartorStop -Path $System_Path 
write-host  "Number of ServiceStartorStop  events:" , $x.count
$x  | Export-Csv -Path $Services_Path\ServiceStartorStop.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7036";SANSCateogry="Services"; Event="Service Start or Stop"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-StartTypeChanged -Path $System_Path  
write-host  "Number of StartTypeChanged  events:" , $x.count
$x | Export-Csv -Path $Services_Path\StartTypeChanged.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7040";SANSCateogry="Services"; Event="Start Type Changed"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

#. .\PSFunctions\Services\ServiceInstall.ps1
#Get-ServiceInstall -Path $System_Path  | Export-Csv -Path $Services_Path\ServiceInstall.csv -NoTypeInformation
#write-host  "Number of ServiceInstall  events:" , ((Import-Csv $Services_Path\ServiceInstall.csv).count)
#$hash= New-Object PSObject -property @{EventID="7045";SANSCateogry="Services"; Event="Service Install"; NumberOfOccurences=(Import-Csv $Services_Path\ServiceInstall.csv).count}
#$ResultsArray+=$hash
}
else{ 
  write-host "Error: System event log is not found" -ForegroundColor Red   
	}
####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\WMI_WMIC\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $WMIOut_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="WMI\WMIC"; Event="All Successful Logons"; NumberOfOccurences=(Import-Csv $WMIOut_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\WMI_WMIC\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $WMIOut_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="WMI\WMIC"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $WMIOut_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash
}

if ($Valid_WinRM_Path -eq $true) {

$x= Get-SystemQueryWMI -Path $WinRM_Path  
write-host  "Number of SystemQueryWMI  events:" , $x.count
$x | Export-Csv -Path $WMIOut_Path\SystemQueryWMI.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5857";SANSCateogry="WMI\WMIC"; Event="System Query WMI"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-TemporaryEventConsumer -Path $WinRM_Path 
write-host  "Number of TemporaryEventConsumer  events:" ,$x.count
$x | Export-Csv -Path $WMIOut_Path\TemporaryEventConsumer.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5860";SANSCateogry="WMI\WMIC"; Event="Temporary Event Consumer"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-PermenantEventConsumer -Path $WinRM_Path  
write-host  "Number of PermenantEventConsumer  events:" , $x.count
$x  | Export-Csv -Path $WMIOut_Path\PermenantEventConsumer.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5861";SANSCateogry="WMI\WMIC"; Event="Permenant Event Consumer"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
	else{ 
	  write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red   
		}
#Remote Execution
	#WMI\WMIC
		#source
#. .\WMI\WMIC\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="WMI\WMIC"; Event="Explicit Credentials"; NumberOfOccurences=(Import-Csv $WMIOut_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash
}
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\PowerShellRemoting\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path $PowerShellRemoting_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $PowerShellRemoting_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="PowerShellRemoting"; Event="All Successful Logons"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $PowerShellRemoting_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $PowerShellRemoting_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="PowerShellRemoting"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash
}

if ($Valid_PowerShellOperational_Path -eq $true) {

$x= Get-ScriptBlockLogging -Path $PowerShellOperational_Path  
write-host  "Number of ScriptBlockLogging  events:" , $x.count 
$x | Export-Csv -Path $PowerShellRemoting_Path\ScriptBlockLogging.csv -NoTypeInformation  -ErrorAction SilentlyContinue
$hash= New-Object PSObject -property @{EventID="4103";SANSCateogry="PowerShellRemoting"; Event="Script Block Logging"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScriptBlockAuditing -Path $PowerShellOperational_Path   
write-host  "Number of ScriptBlockAuditing  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\ScriptBlockAuditing.csv -NoTypeInformation 
$hash= New-Object PSObject -property @{EventID="4104";SANSCateogry="PowerShellRemoting"; Event="Script Block Auditing"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-LateralMovementDetection -Path $PowerShellOperational_Path  
write-host  "Number of LateralMovementDetection  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\LateralMovementDetection.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="53504";SANSCateogry="PowerShellRemoting"; Event="Lateral Movement Detection"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red   
	}

if ($Valid_WinPowerShell_Path -eq $true) {

$x= Get-StartPSRemoteSession -Path $WinPowerShell_Path 
write-host  "Number of StartPSRemoteSession  events:" , $x.count
$x  | Export-Csv -Path $PowerShellRemoting_Path\StartPSRemoteSession.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="400";SANSCateogry="PowerShellRemoting"; Event="Start PSRemote Session"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-EndPSRemoteSession -Path $WinPowerShell_Path 
write-host  "Number of EndPSRemoteSession  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\EndPSRemoteSession.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="403";SANSCateogry="PowerShellRemoting"; Event="End PSRemote Session"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash


$x= Get-PipelineExecution -Path $WinPowerShell_Path
write-host  "Number of PipelineExecution  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\PipelineExecution.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="800";SANSCateogry="PowerShellRemoting"; Event="Pipeline Execution"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red   
	}
#Remote Execution
	#powershell remoting
		#source
#if ($securityparam -eq "yes") {
#. .\PSFunctions\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash
#}
#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManSession -Path $WinRM_Path  
#write-host  "Number of ClosingWSManSession  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManSession.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Session"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManCommand  -Path $WinRM_Path 
#write-host  "Number of ClosingWSManCommand  events:" , $x.count
#$x  | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManCommand.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="15";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Command"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManShell -Path $WinRM_Path  
#write-host  "Number of ClosingWSManShell  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManShell.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="16";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Shell"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManSessionSucceeded -Path $WinRM_Path 
#write-host  "Number of ClosingWSManSessionSucceeded  events:" , $x.count
#$x  | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManSessionSucceeded.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="33";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Session Succeeded"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#$x= Get-CreatingRunspaceObject -Path $PowerShellOperational_Path  
#write-host  "Number of CreatingRunspaceObject  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\reatingRunspaceObject.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8193";SANSCateogry="PowerShellRemoting"; Event="Creating Runspace Object"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-CreatingRunspacePoolObject -Path $PowerShellOperational_Path  
#write-host  "Number of CreatingRunspacePoolObject  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\CreatingRunspacePoolObject.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8194";SANSCateogry="PowerShellRemoting"; Event="Creating Runspace Pool Object"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-RunspaceState -Path $PowerShellOperational_Path 
#write-host  "Number of RunspaceState  events:" , $x.count
#$x  | Export-Csv -Path  $PowerShellRemoting_Path\RunspaceState.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8197";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#Extra events
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
	$x= Get-UnsuccessfulLogons  -Path $Security_Path
	write-host  "Number of UnsuccessfulLogons events:" , $x.count
	$x  | Export-Csv -Path $ExtraEvents_Path\UnsuccessfulLogons.csv -NoTypeInformation
	$hash= New-Object PSObject -property @{EventID="4625";SANSCateogry="Extra Events"; Event="Unsuccessful Logons"; NumberOfOccurences=$x.count}
	$ResultsArray+=$hash
	}
	else{ 
		write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
 write-host "UnsuccessfulLogons depend on Security event log which you choose not to parse" -ForegroundColor Red
}


if ($Valid_RDPCORETS_Path -eq $true) {
$x= Get-EventlogCleared  -Path $RDPCORETS_Path 
write-host  "Number of EventlogCleared events:" , $x.count
$x  | Export-Csv -Path $ExtraEvents_Path\EventlogCleared.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="1102";SANSCateogry="Extra Events"; Event="Event log Cleared"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
       } 

$ResultsArray| Out-GridView
=======
Write-host "
    ______           _     __    _            
   / ____/ _   __   (_)   / /   (_) ____  ___ 
  / __/   | | / /  / /   / /   / / /_  / / _ \
 / /___   | |/ /  / /   / /   / /   / /_/  __/
/_____/   |___/  /_/   /_/   /_/   /___/\___/ 
                                              
" -ForegroundColor Red -BackgroundColor black
Write-host "  
                                                          _____ 
\            / _   |\   |    ___    _   __   ___   |\   |   |
 \    /\    / (_)  | \  |   / _ \  | | / /  / _ \  | \  |   |
  \  /  \  /  | |  |  \ |  /  __/  | |/ /  /  __/  |  \ |   |
   \/    \/   |_|  |   \|  \___/   |___/   \___/   |   \|   |
" -ForegroundColor Red -BackgroundColor black
#inputing the log path
$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path" 
$securityparam= Read-Host -Prompt "Do you want to parse the security event log? yes\no [default is no because security event is usually very big]"

#making results and its sub directories
$Destination_Path= Join-Path -Path $Logs_Path -ChildPath "Results"
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
$ExtraEvents_Path=Join-Path -Path $Destination_Path -ChildPath "ExtraEvents"
#Check if ExtraEvents already exist
if ((Test-Path -Path "$ExtraEvents_Path")-eq $false) {
    New-Item -Path $ExtraEvents_Path -ItemType Directory    
}

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

#converting evt to evtx files
$evtFiles = Get-ChildItem -Recurse -Path $Logs_Path -filter (-NOT '*.evtx') 
if (-NOT ($evtFiles -eq $null)){
	## Convert evt to evtx
	$Securityevt_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evt"
	$Systemevt_Path= Join-Path -Path $Logs_Path -ChildPath "System.evt"
	$RDPCORETSevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
	$WMIevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
	$PowerShellOperationalevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
	$WinPowerShellevt_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
	$WinRMevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
	$TaskSchedulerevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evt"
	$TerminalServiceevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
	$RemoteConnectionevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evt"

	function Evt2Evtx {
		param (
			[Parameter(Mandatory=$true)]
			[string]$EvtPath,
			[Parameter(Mandatory=$true)]
			[string]$EvtxPath
		)
			if (((Test-Path -Path $EvtPath) -eq $true) -and ((Test-Path -Path $EvtxPath) -eq $false)) {
		wevtutil epl $EvtPath $EvtxPath /lf:true }     
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
}

## Testing if the log file exist ? 
$LogsPathTest=Test-Path -Path "$Logs_Path"
##Validating Paths
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

$ResultsArray=@()
#Remote desktop
. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
. .\PSFunctions\RemoteDesktop\RDPreconnected.ps1
. .\PSFunctions\RemoteDesktop\RDPDisconnected.ps1
. .\PSFunctions\RemoteDesktop\RDPConnectionAttempts.ps1
. .\PSFunctions\RemoteDesktop\RDPSuccessfulConnections.ps1
. .\PSFunctions\RemoteDesktop\UserAuthSucceeded.ps1
. .\PSFunctions\RemoteDesktop\RDPSessionLogonSucceed.ps1
. .\PSFunctions\RemoteDesktop\RDPShellStartNotificationReceived.ps1
. .\PSFunctions\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
. .\PSFunctions\RemoteDesktop\RDPbeginSession.ps1
. .\PSFunctions\RemoteDesktop\ExplicitCreds.ps1
. .\PSFunctions\RemoteDesktop\RDPConnectingtoServer.ps1

#Map network shares
. .\PSFunctions\MapNetworkShares\AdminLogonCreated.ps1
. .\PSFunctions\MapNetworkShares\ComputerToValidate.ps1
. .\PSFunctions\MapNetworkShares\KerberosAuthRequest.ps1
. .\PSFunctions\MapNetworkShares\KerberosServiceRequest.ps1
. .\PSFunctions\MapNetworkShares\NetworkShareAccessed.ps1
. .\PSFunctions\MapNetworkShares\AuditingofSharedfiles.ps1
#PSExec
. .\PSFunctions\PsExec\ServiceInstall.ps1
#Scheduled Tasks
. .\PSFunctions\ScheduledTasks\ScheduleTaskCreated.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskDeleted.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskEnabled.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskDisabled.ps1
. .\PSFunctions\ScheduledTasks\ScheduleTaskUpdated.ps1
. .\PSFunctions\ScheduledTasks\CreatingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\DeletingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
. .\PSFunctions\ScheduledTasks\CompletingTaskSchedulerTask.ps1
#Services
. .\PSFunctions\Services\ServiceInstalledonSystem.ps1
. .\PSFunctions\Services\ServiceCrashed.ps1
. .\PSFunctions\Services\ServiceSentControl.ps1
. .\PSFunctions\Services\ServiceStartorStop.ps1
. .\PSFunctions\Services\StartTypeChanged.ps1
#	WMI\WMIC
. .\PSFunctions\WMI_WMIC\SystemQueryWMI.ps1
. .\PSFunctions\WMI_WMIC\TemporaryEventConsumer.ps1
. .\PSFunctions\WMI_WMIC\PermenantEventConsumer.ps1
#PowerShellRemoting
. .\PSFunctions\PowerShellRemoting\ScriptBlockLogging.ps1
. .\PSFunctions\PowerShellRemoting\ScriptBlockAuditing.ps1
. .\PSFunctions\PowerShellRemoting\LateralMovementDetection.ps1
. .\PSFunctions\PowerShellRemoting\StartPSRemoteSession.ps1
. .\PSFunctions\PowerShellRemoting\EndPSRemoteSession.ps1
. .\PSFunctions\PowerShellRemoting\PipelineExecution.ps1
. .\PSFunctions\PowerShellRemoting\SessionCreated.ps1
. .\PSFunctions\PowerShellRemoting\AuthRecorded.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManSession.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManCommand.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManShell.ps1
. .\PSFunctions\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
. .\PSFunctions\PowerShellRemoting\CreatingRunspaceObject.ps1
. .\PSFunctions\PowerShellRemoting\CreatingRunspacePoolObject.ps1
. .\PSFunctions\PowerShellRemoting\RunspaceState.ps1
#extra events
. .\PSFunctions\ExtraEvents\UnsuccessfulLogons.ps1
. .\PSFunctions\ExtraEvents\EventlogCleared.ps1

# Remote Access
	#Remote desktop
		#destination#
if ($securityparam -eq "yes") {
 if ($Valid_Security_Path -eq $true) {

$x= Get-AllSuccessfulLogons -Path $Security_Path  
write-host  "Number of AllSuccessfulLogons:" , $x.count
$x| Export-Csv -Path $RemoteDesktop_Path\AllSuccessfulLogons.csv -NoTypeInformation 
$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="RemoteDesktop"; Event="All Successful Logons"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPreconnected -Path $Security_Path  
write-host  "Number of RDPreconnected  events:" , $x.count
$x|  Export-Csv -Path $RemoteDesktop_Path\RDPreconnected.csv -NoTypeInformation 
$hash= New-Object PSObject -property @{EventID="4778"; SANSCateogry="RemoteDesktop"; Event="RDP sessions reconnected"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPDisconnected -Path $Security_Path 
write-host  "Number of RDPDisconnected  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPDisconnected.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4779"; SANSCateogry="RemoteDesktop"; Event="RDP sessions disconnected"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
	}
 else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red
        
 }
}
else {
	write-host " AllSuccessfulLogons- RDPreconnected -RDPDisconnected depend on Security event log which you choose not to parse" -ForegroundColor Red
}

if ($Valid_RDPCORETS_Path -eq $true) {

$x= Get-RDPConnectionAttempts -Path $RDPCORETS_Path  
write-host  "Number of RDPConnectionAttempts  events:" , $x.count
$x | Export-Csv -Path $RemoteDesktop_Path\RDPConnectionAttempts.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="RemoteDesktop"; Event="RDP Connection Attempts"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash


$x= Get-RDPSuccessfulConnections -Path $RDPCORETS_Path 
$x=write-host  "Number of RDPSuccessfulConnections  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPSuccessfulConnections.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="98";SANSCateogry="RemoteDesktop"; Event="RDP Successful Connections"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
          }

if ($Valid_RemoteConnection_Path -eq $true) {

$x= Get-UserAuthSucceeded -Path $RemoteConnection_Path  
write-host  "Number of UserAuthSucceeded  events:" , $x.count
$x | Export-Csv -Path $RemoteDesktop_Path\UserAuthSucceeded.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="1149";SANSCateogry="RemoteDesktop"; Event="User authentication succeeded"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else { write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
          }

if ($Valid_TerminalServices_Path -eq $true) {

$x= Get-RDPSessionLogonSucceed -Path $TerminalServices_Path 
write-host  "Number of RDPSessionLogonSucceed  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPSessionLogonSucceed.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="21";SANSCateogry="RemoteDesktop"; Event="RDP Session Logon suceeded"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  
write-host  "Number of RDPShellStartNotificationReceived  events:" , $x.count
$x | Export-Csv -Path $RemoteDesktop_Path\RDPShellStartNotificationReceived.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="22";SANSCateogry="RemoteDesktop"; Event="RDP Shell Start Notification recieved"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path 
write-host  "Number of RDPShellSessionReconnectedSucceeded  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="25";SANSCateogry="RemoteDesktop"; Event="RDP Shell Session reconnection succeeded"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-RDPbeginSession -Path $TerminalServices_Path 
write-host  "Number of RDPbeginSession  events:" , $x.count
$x  | Export-Csv -Path $RemoteDesktop_Path\RDPbeginSession.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="41";SANSCateogry="RemoteDesktop"; Event="RDP Begin Session"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else { write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
         }

# Remote Access
	#Remote desktop
		#source
#if ($securityparam -eq "yes") {
 #if ($Valid_Security_Path -eq $true) {

#$x= Get-ExplicitCreds -Path $Security_Path  
#write-host  "Number of ExplicitCreds  events:" , $x.count
#$x | Export-Csv -Path $RemoteDesktop_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="RemoteDesktop"; Event="Exolicit Credentials"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash
	#}
 #else{ 
  #write-host "Error: Security event log is not found" -ForegroundColor Red  
 #}
#}
#else {
#	write-host " ExplicitCreds depends on Security event log which you choose not to parse" -ForegroundColor Red
#}

if ($Valid_RDPCORETS_Path -eq $true) {

#$x= Get-RDPConnectingtoServer -Path $RDPCORETS_Path  
#write-host  "Number of RDPConnectingtoServer  events:" , $x.count
#$x | Export-Csv -Path $RemoteDesktop_Path\RDPConnectingtoServer.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="1024";SANSCateogry="RemoteDesktop"; Event="RDP Connecting to Server"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash


}
else{ write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
       }
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#. .\PSFunctions\MapNetworkShares\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\AllSuccessfulLogons.csv -NoTypeInformation
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\MapNetworkSharescsv\AllSuccessfulLogons.csv).Length -1)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="MapNetworkShares"; Event="Succesful Logons"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash 

$x= Get-AdminLogonCreated -Path $Security_Path  
write-host  "Number of AdminLogonCreated  events:" , $x.count
$x | Export-Csv -Path $MapNetworkShares_Path\AdminLogonCreated.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="MapNetworkShares"; Event="Admin Logon created"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ComputerToValidate -Path $Security_Path 
write-host  "Number of ComputerToValidate  events:" , $x.count
$x  | Export-Csv -Path $MapNetworkShares_Path\ComputerToValidate.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4776";SANSCateogry="MapNetworkShares"; Event="Computer to validate"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-KerberosAuthRequest -Path $Security_Path 
write-host  "Number of KerberosAuthRequest  events:" , $x.count
$x  | Export-Csv -Path $MapNetworkShares_Path\KerberosAuthRequest.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4768";SANSCateogry="MapNetworkShares"; Event="Kerberos Authentication Request"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-KerberosServiceRequest -Path $Security_Path 
write-host  "Number of KerberosServiceRequest  events:" , $x.count
$x  | Export-Csv -Path $MapNetworkShares_Path\KerberosServiceRequest.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4769";SANSCateogry="MapNetworkShares"; Event="Kerberos Service Request"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-NetworkShareAccessed -Path $Security_Path  
write-host  "Number of NetworkShareAccessed  events:" , $x.count
$x| Export-Csv -Path $MapNetworkShares_Path\NetworkShareAccessed.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5140";SANSCateogry="MapNetworkShares"; Event="Network Share Accessed"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-AuditingofSharedfiles -Path $Security_Path  
write-host  "Number of AuditingofSharedfiles  events:" , $x.count
$x| Export-Csv -Path $MapNetworkShares_Path\AuditingofSharedfiles.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5145";SANSCateogry="MapNetworkShares"; Event="Auditing of Shared Files"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

# Remote Access 
	#Map Network Shares
		# source
#. .\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="MapNetworkShares"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash
#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination

#. .\PSFunctions\PsExec\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $PsExec_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $PsExec_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="PSExec"; Event="Successful Logons"; NumberOfOccurences=(Import-Csv $PsExec_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PsExec\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $PsExec_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $PsExec_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="PSExec"; Event="Admin Logon created"; NumberOfOccurences=(Import-Csv $PsExec_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PsExec\NetworkShareAccessed.ps1
#Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path $PsExec_Path\NetworkShareAccessed.csv -NoTypeInformation
#write-host  "Number of NetworkShareAccessed  events:" , ((Import-Csv $PsExec_Path\NetworkShareAccessed.csv).count)
#$hash= New-Object PSObject -property @{EventID="5140";SANSCateogry="PSExec"; Event="Network Share Accessed"; NumberOfOccurences=(Import-Csv $PsExec_Path\NetworkShareAccessed.csv).count}
#$ResultsArray+=$hash
	}
	 else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
write-host " AdminLogonCreated- ComputerToValidate-KerberosAuthRequest-KerberosServiceRequest-NetworkShareAccessed-AuditingofSharedfiles depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_System_Path -eq $true) {

$x= Get-ServiceInstall -Path $System_Path  
write-host  "Number of ServiceInstall  events:" , $x.count
$x | Export-Csv -Path $PsExec_Path\ServiceInstall.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7045";SANSCateogry="PSExec"; Event="Installed Service"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: System event log is not found" -ForegroundColor Red   
}

#Remote Execution
	#PsExec
		#source
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#. .\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $PsExec_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="PSExec"; Event="Exolicit Credentials"; NumberOfOccurences=(Import-Csv $PsExec_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash

############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination

#. .\PSFunctions\ScheduledTasks\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path $ScheduledTasks_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $ScheduledTasks_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="ScheduledTasks"; Event="Successful Logons"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\ScheduledTasks\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $ScheduledTasks_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $ScheduledTasks_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="ScheduledTasks"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash

$x= Get-ScheduleTaskCreated -Path $Security_Path
write-host  "Number of ScheduleTaskCreated  events:" , $x.count
$x  | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskCreated.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4698";SANSCateogry="ScheduledTasks"; Event="Schedule Task Created"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskDeleted -Path  $Security_Path 
write-host  "Number of ScheduleTaskDeleted  events:" , $x.count
$x| Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskDeleted.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4699";SANSCateogry="ScheduledTasks"; Event="Schedule Task Deleted"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskEnabled -Path  $Security_Path 
write-host  "Number of ScheduleTaskEnabled  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskEnabled.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4700";SANSCateogry="ScheduledTasks"; Event="Schedule Task Enabled"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskDisabled -Path  $Security_Path 
write-host  "Number of ScheduleTaskDisabled  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskDisabled.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4701";SANSCateogry="ScheduledTasks"; Event="Schedule Task Disabled"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScheduleTaskUpdated -Path  $Security_Path 
write-host  "Number of ScheduleTaskUpdated  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskUpdated.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4702";SANSCateogry="ScheduledTasks"; Event="Schedule Task Updated"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
	}
	else{ 
	  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
write-host " ScheduleTaskCreated- ScheduleTaskDeleted-ScheduleTaskEnabled-ScheduleTaskDisabled-ScheduleTaskUpdated depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_TaskScheduler_Path -eq $true) {

$x= Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path 
write-host  "Number of CreatingTaskSchedulerTask  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\CreatingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="106";SANSCateogry="ScheduledTasks"; Event="Creating TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path
write-host  "Number of UpdatingTaskSchedulerTask  events:" , $x.count
$x  | Export-Csv -Path $ScheduledTasks_Path\UpdatingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="140";SANSCateogry="ScheduledTasks"; Event="Updating TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path 
write-host  "Number of DeletingTaskSchedulerTask  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\DeletingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="141";SANSCateogry="ScheduledTasks"; Event="Deleting TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path
write-host  "Number of ExecutingTaskSchedulerTask  events:" , $x.count
$x  | Export-Csv -Path $ScheduledTasks_Path\ExecutingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="200";SANSCateogry="ScheduledTasks"; Event="Executing TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path 
write-host  "Number of CompletingTaskSchedulerTask  events:" , $x.count
$x | Export-Csv -Path $ScheduledTasks_Path\CompletingTaskSchedulerTask.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="201";SANSCateogry="ScheduledTasks"; Event="Completing TaskScheduler Task"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Microsoft-Windows-TaskScheduler%4Maintenance event log is not found" -ForegroundColor Red   
}

#Remote Execution
	#Scheduled Tasks
		#source
#. .\ScheduledTasks\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $ScheduledTasks_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="ScheduledTasks"; Event="Explicit credentials"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash

#####################################################################################################################################
#Remote Execution
	#services
		#destination

#. .\PSFunctions\Services\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $Services_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $Services_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="Services"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $Services_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

$x= Get-ServiceInstalledonSystem -Path $Security_Path  
write-host  "Number of ServiceInstalledonSystem  events:" , $x.count
$x | Export-Csv -Path $Services_Path\ServiceInstalledonSystem.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="4697";SANSCateogry="Services"; Event="Service Installed on System"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
	}
	else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
 write-host "ServiceInstalledonSystem depend on Security event log which you choose not to parse" -ForegroundColor Red
}

if ($Valid_System_Path -eq $true) {

$x= Get-ServiceCrashed -Path $System_Path  
write-host  "Number of ServiceCrashed  events:" , $x.count
$x | Export-Csv -Path $Services_Path\ServiceCrashed.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7034";SANSCateogry="Services"; Event="Service Crashed"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ServiceSentControl -Path $System_Path  
write-host  "Number of ServiceSentControl  events:" , $x.count
$x | Export-Csv -Path $Services_Path\ServiceSentControl.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7035";SANSCateogry="Services"; Event="Service Sent Control"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ServiceStartorStop -Path $System_Path 
write-host  "Number of ServiceStartorStop  events:" , $x.count
$x  | Export-Csv -Path $Services_Path\ServiceStartorStop.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7036";SANSCateogry="Services"; Event="Service Start or Stop"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-StartTypeChanged -Path $System_Path  
write-host  "Number of StartTypeChanged  events:" , $x.count
$x | Export-Csv -Path $Services_Path\StartTypeChanged.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="7040";SANSCateogry="Services"; Event="Start Type Changed"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

#. .\PSFunctions\Services\ServiceInstall.ps1
#Get-ServiceInstall -Path $System_Path  | Export-Csv -Path $Services_Path\ServiceInstall.csv -NoTypeInformation
#write-host  "Number of ServiceInstall  events:" , ((Import-Csv $Services_Path\ServiceInstall.csv).count)
#$hash= New-Object PSObject -property @{EventID="7045";SANSCateogry="Services"; Event="Service Install"; NumberOfOccurences=(Import-Csv $Services_Path\ServiceInstall.csv).count}
#$ResultsArray+=$hash
}
else{ 
  write-host "Error: System event log is not found" -ForegroundColor Red   
	}
####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\WMI_WMIC\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $WMIOut_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="WMI\WMIC"; Event="All Successful Logons"; NumberOfOccurences=(Import-Csv $WMIOut_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\WMI_WMIC\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $WMIOut_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="WMI\WMIC"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $WMIOut_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash
}

if ($Valid_WinRM_Path -eq $true) {

$x= Get-SystemQueryWMI -Path $WinRM_Path  
write-host  "Number of SystemQueryWMI  events:" , $x.count
$x | Export-Csv -Path $WMIOut_Path\SystemQueryWMI.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5857";SANSCateogry="WMI\WMIC"; Event="System Query WMI"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-TemporaryEventConsumer -Path $WinRM_Path 
write-host  "Number of TemporaryEventConsumer  events:" ,$x.count
$x | Export-Csv -Path $WMIOut_Path\TemporaryEventConsumer.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5860";SANSCateogry="WMI\WMIC"; Event="Temporary Event Consumer"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-PermenantEventConsumer -Path $WinRM_Path  
write-host  "Number of PermenantEventConsumer  events:" , $x.count
$x  | Export-Csv -Path $WMIOut_Path\PermenantEventConsumer.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="5861";SANSCateogry="WMI\WMIC"; Event="Permenant Event Consumer"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
	else{ 
	  write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red   
		}
#Remote Execution
	#WMI\WMIC
		#source
#. .\WMI\WMIC\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="WMI\WMIC"; Event="Explicit Credentials"; NumberOfOccurences=(Import-Csv $WMIOut_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash
}
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination

if ($Valid_PowerShellOperational_Path -eq $true) {

$x= Get-ScriptBlockLogging -Path $PowerShellOperational_Path  
write-host  "Number of ScriptBlockLogging  events:" , $x.count 
$x | Export-Csv -Path $PowerShellRemoting_Path\ScriptBlockLogging.csv -NoTypeInformation  -ErrorAction SilentlyContinue
$hash= New-Object PSObject -property @{EventID="4103";SANSCateogry="PowerShellRemoting"; Event="Script Block Logging"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-ScriptBlockAuditing -Path $PowerShellOperational_Path   
write-host  "Number of ScriptBlockAuditing  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\ScriptBlockAuditing.csv -NoTypeInformation 
$hash= New-Object PSObject -property @{EventID="4104";SANSCateogry="PowerShellRemoting"; Event="Script Block Auditing"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-LateralMovementDetection -Path $PowerShellOperational_Path  
write-host  "Number of LateralMovementDetection  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\LateralMovementDetection.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="53504";SANSCateogry="PowerShellRemoting"; Event="Lateral Movement Detection"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red   
	}

if ($Valid_WinPowerShell_Path -eq $true) {

$x= Get-StartPSRemoteSession -Path $WinPowerShell_Path 
write-host  "Number of StartPSRemoteSession  events:" , $x.count
$x  | Export-Csv -Path $PowerShellRemoting_Path\StartPSRemoteSession.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="400";SANSCateogry="PowerShellRemoting"; Event="Start PSRemote Session"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-EndPSRemoteSession -Path $WinPowerShell_Path 
write-host  "Number of EndPSRemoteSession  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\EndPSRemoteSession.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="403";SANSCateogry="PowerShellRemoting"; Event="End PSRemote Session"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash


$x= Get-PipelineExecution -Path $WinPowerShell_Path
write-host  "Number of PipelineExecution  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\PipelineExecution.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="800";SANSCateogry="PowerShellRemoting"; Event="Pipeline Execution"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red   
	}
	
if ($Valid_WinRM_Path -eq $true) {
$x= Get-SessionCreated -Path $WinRM_Path
write-host  "Number of SessionCreated  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\SessionCreated.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="91";SANSCateogry="PowerShellRemoting"; Event="Session Created"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash

$x= Get-AuthRecorded -Path $WinRM_Path
write-host  "Number of AuthRecorded  events:" , $x.count
$x | Export-Csv -Path $PowerShellRemoting_Path\AuthRecorded.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="168";SANSCateogry="PowerShellRemoting"; Event="Authentication recorded "; NumberOfOccurences=$x.count}
$ResultsArray+=$hash	
}
else{ 
  write-host "Error: Microsoft-Windows-WinRM%4Operational.evtx event log is not found" -ForegroundColor Red   
	}
#Remote Execution
	#powershell remoting
		#source
#if ($securityparam -eq "yes") {
#. .\PSFunctions\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash
#}
#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManSession -Path $WinRM_Path  
#write-host  "Number of ClosingWSManSession  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManSession.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Session"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManCommand  -Path $WinRM_Path 
#write-host  "Number of ClosingWSManCommand  events:" , $x.count
#$x  | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManCommand.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="15";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Command"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManShell -Path $WinRM_Path  
#write-host  "Number of ClosingWSManShell  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManShell.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="16";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Shell"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-ClosingWSManSessionSucceeded -Path $WinRM_Path 
#write-host  "Number of ClosingWSManSessionSucceeded  events:" , $x.count
#$x  | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManSessionSucceeded.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="33";SANSCateogry="PowerShellRemoting"; Event="Closing WSMan Session Succeeded"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#$x= Get-CreatingRunspaceObject -Path $PowerShellOperational_Path  
#write-host  "Number of CreatingRunspaceObject  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\reatingRunspaceObject.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8193";SANSCateogry="PowerShellRemoting"; Event="Creating Runspace Object"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-CreatingRunspacePoolObject -Path $PowerShellOperational_Path  
#write-host  "Number of CreatingRunspacePoolObject  events:" , $x.count
#$x | Export-Csv -Path  $PowerShellRemoting_Path\CreatingRunspacePoolObject.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8194";SANSCateogry="PowerShellRemoting"; Event="Creating Runspace Pool Object"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#$x= Get-RunspaceState -Path $PowerShellOperational_Path 
#write-host  "Number of RunspaceState  events:" , $x.count
#$x  | Export-Csv -Path  $PowerShellRemoting_Path\RunspaceState.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="8197";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=$x.count}
#$ResultsArray+=$hash

#Extra events
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
	$x= Get-UnsuccessfulLogons  -Path $Security_Path
	write-host  "Number of UnsuccessfulLogons events:" , $x.count
	$x  | Export-Csv -Path $ExtraEvents_Path\UnsuccessfulLogons.csv -NoTypeInformation
	$hash= New-Object PSObject -property @{EventID="4625";SANSCateogry="Extra Events"; Event="Unsuccessful Logons"; NumberOfOccurences=$x.count}
	$ResultsArray+=$hash
	}
	else{ 
		write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else{
 write-host "UnsuccessfulLogons depend on Security event log which you choose not to parse" -ForegroundColor Red
}


if ($Valid_RDPCORETS_Path -eq $true) {
$x= Get-EventlogCleared  -Path $RDPCORETS_Path 
write-host  "Number of EventlogCleared events:" , $x.count
$x  | Export-Csv -Path $ExtraEvents_Path\EventlogCleared.csv -NoTypeInformation
$hash= New-Object PSObject -property @{EventID="1102";SANSCateogry="Extra Events"; Event="Event log Cleared"; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
else{ write-host "Error: 	 event log is not found" -ForegroundColor Red
       } 

$ResultsArray| Out-GridView
