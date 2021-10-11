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
if ($security) {
	$securityparam = "yes"
}

#making results and its sub directories
$Destination_Path = Join-Path -Path $Logs_Path -ChildPath "Results"
if ((Test-Path -Path "$Destination_Path") -eq $false) {
	New-Item -Path $Destination_Path -ItemType Directory    
} 
$RemoteDesktop_Path = Join-Path -Path $Destination_Path -ChildPath "RemoteDesktop"
#Check if Remote Desktop already exist
if ((Test-Path -Path "$RemoteDesktop_Path") -eq $false) {
	New-Item -Path $RemoteDesktop_Path -ItemType Directory    
}
$MapNetworkShares_Path = Join-Path -Path $Destination_Path -ChildPath "MapNetworkShares"
#Check if MapNetworkShares already exist
if ((Test-Path -Path "$MapNetworkShares_Path") -eq $false) {
	New-Item -Path $MapNetworkShares_Path -ItemType Directory    
}
$PsExec_Path = Join-Path -Path $Destination_Path -ChildPath "PsExec"
#Check if PsExec already exist
if ((Test-Path -Path "$PsExec_Path") -eq $false) {
	New-Item -Path $PsExec_Path -ItemType Directory    
}
$ScheduledTasks_Path = Join-Path -Path $Destination_Path -ChildPath "ScheduledTasks"
#Check if ScheduledTasks already exist
if ((Test-Path -Path "$ScheduledTasks_Path") -eq $false) {
	New-Item -Path $ScheduledTasks_Path -ItemType Directory    
}
$Services_Path = Join-Path -Path $Destination_Path -ChildPath "Services"
#Check if Services already exist
if ((Test-Path -Path "$Services_Path") -eq $false) {
	New-Item -Path $Services_Path -ItemType Directory    
}
$WMIOut_Path = Join-Path -Path $Destination_Path -ChildPath "WMI"
#Check if WMI already exist
if ((Test-Path -Path "$WMIOut_Path") -eq $false) {
	New-Item -Path $WMIOut_Path -ItemType Directory    
}
$PowerShellRemoting_Path = Join-Path -Path $Destination_Path -ChildPath "PowerShellRemoting"
#Check if PowerShellRemoting already exist
if ((Test-Path -Path "$PowerShellRemoting_Path") -eq $false) {
	New-Item -Path $PowerShellRemoting_Path -ItemType Directory    
}
$ExtraEvents_Path = Join-Path -Path $Destination_Path -ChildPath "ExtraEvents"
#Check if ExtraEvents already exist
if ((Test-Path -Path "$ExtraEvents_Path") -eq $false) {
	New-Item -Path $ExtraEvents_Path -ItemType Directory    
}

$Security_Path = Join-Path -Path $Logs_Path -ChildPath "Security.evtx"
$System_Path = Join-Path -Path $Logs_Path -ChildPath "System.evtx"
$RDPCORETS_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
$WMI_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evtx"
$PowerShellOperational_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evtx"
$WinPowerShell_Path = Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evtx"
$WinRM_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evtx"
$TaskScheduler_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evtx"
$TerminalServices_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
$RemoteConnection_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"

#converting evt to evtx files
$evtFiles = Get-ChildItem -Recurse -Path $Logs_Path -filter (-NOT '*.evtx') 
if (-NOT ($evtFiles -eq $null)) {
	## Convert evt to evtx
	$Securityevt_Path = Join-Path -Path $Logs_Path -ChildPath "Security.evt"
	$Systemevt_Path = Join-Path -Path $Logs_Path -ChildPath "System.evt"
	$RDPCORETSevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
	$WMIevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
	$PowerShellOperationalevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
	$WinPowerShellevt_Path = Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
	$WinRMevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
	$TaskSchedulerevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evt"
	$TerminalServiceevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
	$RemoteConnectionevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evt"

	function Evt2Evtx {
		param (
			[Parameter(Mandatory = $true)]
			[string]$EvtPath,
			[Parameter(Mandatory = $true)]
			[string]$EvtxPath
		)
		if (((Test-Path -Path $EvtPath) -eq $true) -and ((Test-Path -Path $EvtxPath) -eq $false)) {
			wevtutil epl $EvtPath $EvtxPath /lf:true 
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
}

## Testing if the log file exist ? 
$LogsPathTest = Test-Path -Path "$Logs_Path"
##Validating Paths
$Valid_Security_Path = Test-Path -Path $Security_Path
$Valid_System_Path = Test-Path -Path $System_Path
$Valid_RDPCORETS_Path = Test-Path -Path $RDPCORETS_Path
$Valid_WMI_Path = Test-Path -Path $WMI_Path
$Valid_PowerShellOperational_Path = Test-Path -Path $PowerShellOperational_Path
$Valid_WinPowerShell_Path = Test-Path -Path $WinPowerShell_Path
$Valid_WinRM_Path = Test-Path -Path $WinRM_Path
$Valid_TaskScheduler_Path = Test-Path -Path $TaskScheduler_Path
$Valid_TerminalServices_Path = Test-Path -Path $TerminalServices_Path
$Valid_RemoteConnection_Path = Test-Path -Path $RemoteConnection_Path

$global:ResultsArray = @()
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

function export_data {
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $EventID,
		[Parameter(Mandatory = $true, Position = 1)]
		[AllowEmptyCollection()]
		[system.Object[]] $events,
		[Parameter(Mandatory = $true, Position = 2)]
		[string] $OutputFile,
		[Parameter(Mandatory = $true, Position = 3)]
		[string] $event_file_type,
		[Parameter(Mandatory = $true, Position = 4)]
		[string] $sans_catagory,
		[Parameter(Mandatory = $true, Position = 5)]
		[string] $event_name
	)
	$events | Export-Csv -Path $OutputFile -NoTypeInformation 
	$hash = New-Object PSObject -property @{EventID = $EventID; EventLog = $event_file_type; SANSCateogry = $sans_catagory; Event = $event_name; NumberOfOccurences = $events.count }
	$global:ResultsArray += $hash
	Write-Host $event_name":" $events.count -ForegroundColor Green

}

# Remote Access
#Remote desktop
#destination#
if ($securityparam -eq "yes") {
 if ($Valid_Security_Path -eq $true) {

		$x = Get-AllSuccessfulLogons -Path $Security_Path  
		if ($x -eq $null) { $x = @() }
		export_data "4624" $x $RemoteDesktop_Path\AllSuccessfulLogons.csv "Security.evtx" "RemoteDesktop" "All Successful Logons"

		$x = Get-RDPreconnected -Path $Security_Path
		if ($x -eq $null) { $x = @() }
		export_data "4778" $x $RemoteDesktop_Path\RDPreconnected.csv "Security.evtx" "RemoteDesktop" "RDP sessions reconnected"
		
		$x = Get-RDPDisconnected -Path $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4779" $x $RemoteDesktop_Path\RDPDisconnected.csv "Security.evtx" "RemoteDesktop" "RDP sessions disconnected"

	}
 else { 
  write-host "Error: Security event log is not found" -ForegroundColor Red
        
 }
}
else {
	write-host " AllSuccessfulLogons- RDPreconnected -RDPDisconnected depend on Security event log which you choose not to parse" -ForegroundColor Red
}

if ($Valid_RDPCORETS_Path -eq $true) {

	$x = Get-RDPConnectionAttempts -Path $RDPCORETS_Path  
	if ($x -eq $null) { $x = @() }
	export_data "131" $x $RemoteDesktop_Path\RDPConnectionAttempts.csv "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx" "RemoteDesktop" "RDP Connection Attempts"

	$x = Get-RDPSuccessfulConnections -Path $RDPCORETS_Path 
	if ($x -eq $null) { $x = @() }
	export_data "98" $x $RemoteDesktop_Path\RDPSuccessfulConnections.csv "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx" "RemoteDesktop" "RDP Successful Connections"
}
else {
 write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
}

if ($Valid_RemoteConnection_Path -eq $true) {

	$x = Get-UserAuthSucceeded -Path $RemoteConnection_Path  
	if ($x -eq $null) { $x = @() }
	export_data "1149" $x $RemoteDesktop_Path\UserAuthSucceeded.csv.csv "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx" "RemoteDesktop" "RDP User authentication succeeded"
	
}
else {
 write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
}

if ($Valid_TerminalServices_Path -eq $true) {

	$x = Get-RDPSessionLogonSucceed -Path $TerminalServices_Path 
	if ($x -eq $null) { $x = @() }
	export_data "21" $x $RemoteDesktop_Path\RDPSessionLogonSucceeded.csv "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "RemoteDesktop" "RDP Successful Logons Sessions"

	$x = Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  
	if ($x -eq $null) { $x = @() }
	export_data "22" $x $RemoteDesktop_Path\RDPShellStartNotificationReceived.csv "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "RemoteDesktop" "RDP Shell Start Notification recieved"

	$x = Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path 
	if ($x -eq $null) { $x = @() }
	export_data "25" $x $RemoteDesktop_Path\RDPShellSessionReconnectedSucceeded.csv "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "RemoteDesktop" "RDP Shell Session reconnection succeeded"

	$x = Get-RDPbeginSession -Path $TerminalServices_Path 
	if ($x -eq $null) { $x = @() }
	export_data "41" $x $RemoteDesktop_Path\RDPbeginSession.csv "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "RemoteDesktop" "RDP Begin Session"

}
else {
 write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
}

# Remote Access
#Remote desktop
#source
function Source_RDP {
	if ($securityparam -eq "yes") {
		if ($Valid_Security_Path -eq $true) {
	
			$x = Get-ExplicitCreds -Path $Security_Path  
			write-host  "Number of ExplicitCreds  events:" , $x.count
			$x | Export-Csv -Path $RemoteDesktop_Path\ExplicitCreds.csv -NoTypeInformation
			$hash = New-Object PSObject -property @{EventID = "4648"; SANSCateogry = "RemoteDesktop"; Event = "Exolicit Credentials"; NumberOfOccurences = $x.count }
			$ResultsArray += $hash
		}
		else { 
			write-host "Error: Security event log is not found" -ForegroundColor Red  
		}
	}
	else {
		write-host " ExplicitCreds depends on Security event log which you choose not to parse" -ForegroundColor Red
	}
	
	if ($Valid_RDPCORETS_Path -eq $true) {
	
		$x = Get-RDPConnectingtoServer -Path $RDPCORETS_Path  
		write-host  "Number of RDPConnectingtoServer  events:" , $x.count
		$x | Export-Csv -Path $RemoteDesktop_Path\RDPConnectingtoServer.csv -NoTypeInformation
		$hash = New-Object PSObject -property @{EventID = "1024"; SANSCateogry = "RemoteDesktop"; Event = "RDP Connecting to Server"; NumberOfOccurences = $x.count }
		$ResultsArray += $hash01	
	}
	else {
	 write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
	}
}
#################################################################################################################################################3

#Remote Access	
# Map Network Shares 
#destination
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
		$x = Get-AdminLogonCreated -Path $Security_Path  
		if ($x -eq $null) { $x = @() }
		export_data "4672" $x $MapNetworkShares_Path\AdminLogonCreated.csv "Security.evtx" "MapNetworkShares" "Admin Logon created"

		$x = Get-ComputerToValidate -Path $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4776" $x $MapNetworkShares_Path\ComputerToValidate.csv "Security.evtx" "MapNetworkShares" "Computer to validate"

		$x = Get-KerberosAuthRequest -Path $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4768" $x $MapNetworkShares_Path\KerberosAuthRequest.csv "Security.evtx" "MapNetworkShares" "Kerberos Authentication Request"

		$x = Get-KerberosServiceRequest -Path $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4769" $x $MapNetworkShares_Path\KerberosServiceRequest.csv "Security.evtx" "MapNetworkShares" "Kerberos Service Request"

		$x = Get-NetworkShareAccessed -Path $Security_Path  
		if ($x -eq $null) { $x = @() }
		export_data "5140" $x $MapNetworkShares_Path\NetworkShareAccessed.csv "Security.evtx" "MapNetworkShares" "Network Share Accessed"

		$x = Get-AuditingofSharedfiles -Path $Security_Path  
		if ($x -eq $null) { $x = @() }
		export_data "5145" $x $MapNetworkShares_Path\AuditingofSharedfiles.csv "Security.evtx" "MapNetworkShares" "Auditing of Shared Files"

		# Remote Access 
		#Map Network Shares
		# source
		function Source_NetworkMap {
			. .\MapNetworkShares\ExplicitCreds.ps1
			Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\ExplicitCreds.csv -NoTypeInformation
			$hash = New-Object PSObject -property @{EventID = "4648"; SANSCateogry = "MapNetworkShares"; Event = "RDP Connection Attempts"; NumberOfOccurences = (Import-Csv $MapNetworkShares_Path\ExplicitCreds.csv).count }
			$ResultsArray += $hash
			FailedLogintoDestination TODO
		}

		#######################################################################################################################

		
	}
	else { 
		write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else {
	write-host " AdminLogonCreated- ComputerToValidate-KerberosAuthRequest-KerberosServiceRequest-NetworkShareAccessed-AuditingofSharedfiles depend on Security event log which you choose not to parse" -ForegroundColor Red
}

#Remote Execution
#PsExec
#Destination
if ($Valid_System_Path -eq $true) {
	$x = Get-ServiceInstall -Path $System_Path  
	if ($x -eq $null) { $x = @() }
	export_data "5145" $x $PsExec_Path\ServiceInstall.csv "System.evtx" "PSExec" "Installed Service"
}
else { 
	write-host "Error: System event log is not found" -ForegroundColor Red   
}

# PSExec/ source Repeated

#Remote Execution
#Scheduled Tasks
#Destination
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {

		$x = Get-ScheduleTaskCreated -Path $Security_Path
		if ($x -eq $null) { $x = @() }
		export_data "4698" $x $ScheduledTasks_Path\ScheduleTaskDeleted.csv "Security.evtx" "ScheduledTasks" "Schedule Task Created"

		$x = Get-ScheduleTaskDeleted -Path  $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4699" $x $ScheduledTasks_Path\ScheduleTaskDeleted.csv "Security.evtx" "ScheduledTasks" "Schedule Task Deleted"

		$x = Get-ScheduleTaskEnabled -Path  $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4700" $x $ScheduledTasks_Path\ScheduleTaskEnabled.csv "Security.evtx" "ScheduledTasks" "Schedule Task Enabled"

		$x = Get-ScheduleTaskDisabled -Path  $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4701" $x $ScheduledTasks_Path\ScheduleTaskDisabled.csv "Security.evtx" "ScheduledTasks" "Schedule Task Disabled"

		$x = Get-ScheduleTaskUpdated -Path  $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "4702" $x $ScheduledTasks_Path\ScheduleTaskUpdated.csv "Security.evtx" "ScheduledTasks" "Schedule Task Updated"
	}
	else { 
		write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else {
	write-host " ScheduleTaskCreated- ScheduleTaskDeleted-ScheduleTaskEnabled-ScheduleTaskDisabled-ScheduleTaskUpdated depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_TaskScheduler_Path -eq $true) {

	$x = Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path 
	if ($x -eq $null) { $x = @() }
	export_data "106" $x $ScheduledTasks_Path\CreatingTaskSchedulerTask.csv "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Creating TaskScheduler Task"

	$x = Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path
	if ($x -eq $null) { $x = @() }
	export_data "140" $x $ScheduledTasks_Path\UpdatingTaskSchedulerTask.csv "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Updating TaskScheduler Task"

	$x = Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path 
	if ($x -eq $null) { $x = @() }
	export_data "141" $x $ScheduledTasks_Path\DeletingTaskSchedulerTask.csv "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Deleting TaskScheduler Task"

	$x = Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path
	if ($x -eq $null) { $x = @() }
	export_data "200" $x $ScheduledTasks_Path\ExecutingTaskSchedulerTask.csv "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Executing TaskScheduler Task"

	$x = Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path 
	if ($x -eq $null) { $x = @() }
	export_data "201" $x $ScheduledTasks_Path\CompletingTaskSchedulerTask.csv "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Completing TaskScheduler Task"
}
else { 
	write-host "Error: Microsoft-Windows-TaskScheduler%4en4Operational event log is not found" -ForegroundColor Red   
}


#Scheduled Tasks/ source Repetead

#Remote Execution
#services
#destination
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {

		$x = Get-ServiceInstalledonSystem -Path $Security_Path  
		if ($x -eq $null) { $x = @() }
		export_data "4697" $x $Services_Path\ServiceInstalledonSystem.csv "Security.evtx" "Services" "Service Installed on System"
	}
	else { 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else {
 write-host "ServiceInstalledonSystem depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_System_Path -eq $true) {

	$x = Get-ServiceCrashed -Path $System_Path  
	if ($x -eq $null) { $x = @() }
	export_data "7034" $x $Services_Path\ServiceCrashed.csv "System.evtx" "Services" "Service Crashed"

	$x = Get-ServiceSentControl -Path $System_Path  
	if ($x -eq $null) { $x = @() }
	export_data "7035" $x $Services_Path\ServiceSentControl.csv "System.evtx" "Services" "Service Sent Control"

	# 99% Of system.evtx is this event
	if($all_logs){
		$x = Get-ServiceStartorStop -Path $System_Path 
		if ($x -eq $null) { $x = @() }
		export_data "7036" $x $Services_Path\ServiceStartorStop.csv "System.evtx" "Services" "Service Start or Stop"
	}

	$x = Get-StartTypeChanged -Path $System_Path  
	if ($x -eq $null) { $x = @() }
	export_data "7040" $x $Services_Path\StartTypeChanged.csv "System.evtx" "Services" "Start Type Changed"

	$x = Get-ServiceInstall -Path $System_Path  
	if ($x -eq $null) { $x = @() }
	export_data "7045" $x $Services_Path\ServiceInstall.csv "System.evtx" "Services" "Service Install"
}
else { 
	write-host "Error: System event log is not found" -ForegroundColor Red   
}
####################################################################################################################################
#Remote Execution
#WMI\WMIC
#destination

if ($Valid_WMI_Path -eq $true) {

	$x = Get-SystemQueryWMI -Path $WMI_Path  
	if ($x -eq $null) { $x = @() }
	export_data "5857" $x $WMIOut_Path\SystemQueryWMI.csv "Microsoft-Windows-WMIActivity%4Operational.evtx" "WMI\WMIC" "System Query WMI"

	$x = Get-TemporaryEventConsumer -Path $WMI_Path 
	if ($x -eq $null) { $x = @() }
	export_data "5860" $x $WMIOut_Path\TemporaryEventConsumer.csv "Microsoft-Windows-WMIActivity%4Operational.evtx" "WMI\WMIC" "Temporary Event Consumer"

	$x = Get-PermenantEventConsumer -Path $WMI_Path
	if ($x -eq $null) { $x = @() }
	export_data "5861" $x $WMIOut_Path\PermenantEventConsumer.csv "Microsoft-Windows-WMIActivity%4Operational.evtx" "WMI\WMIC" "Permenant Event Consumer"
}
else { 
	write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red   
}

#WMI\WMIC source Repeated

#Remote Execution
#powershell remoting
#destination

if ($Valid_PowerShellOperational_Path -eq $true) {

	$x = Get-ScriptBlockLogging -Path $PowerShellOperational_Path  
	if ($x -eq $null) { $x = @() }
	export_data "4103" $x $PowerShellRemoting_Path\ScriptBlockLogging.csv "Microsoft-Windows-PowerShell%4Operational.evtx" "PowerShellRemoting" "Script Block Logging"

	$x = Get-ScriptBlockAuditing -Path $PowerShellOperational_Path   
	if ($x -eq $null) { $x = @() }
	export_data "4104" $x $PowerShellRemoting_Path\ScriptBlockAuditing.csv "Microsoft-Windows-PowerShell%4Operational.evtx" "PowerShellRemoting" "Script Block Auditing"

	$x = Get-LateralMovementDetection -Path $PowerShellOperational_Path  
	if ($x -eq $null) { $x = @() }
	export_data "53504" $x $PowerShellRemoting_Path\PowerShellOperational_Path.csv "Microsoft-Windows-PowerShell%4Operational.evtx" "PowerShellRemoting" "Lateral Movement Detection"
}
else { 
	write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red   
}

if ($Valid_WinPowerShell_Path -eq $true) {

	$x = Get-StartPSRemoteSession -Path $WinPowerShell_Path 
	if ($x -eq $null) { $x = @() }
	export_data "400" $x $PowerShellRemoting_Path\StartPSRemoteSession.csv "Windows PowerShell.evtx" "PowerShellRemoting" "Start PSRemote Session"

	$x = Get-EndPSRemoteSession -Path $WinPowerShell_Path 
	if ($x -eq $null) { $x = @() }
	export_data "403" $x $PowerShellRemoting_Path\EndPSRemoteSession.csv "Windows PowerShell.evtx" "PowerShellRemoting" "End PSRemote Session"


	$x = Get-PipelineExecution -Path $WinPowerShell_Path
	if ($x -eq $null) { $x = @() }
	export_data "800" $x $PowerShellRemoting_Path\PipelineExecution.csv "Windows PowerShell.evtx" "PowerShellRemoting" "Partial Scripts Code"
}
else { 
	write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red   
}
	
if ($Valid_WinRM_Path -eq $true) {
	$x = Get-SessionCreated -Path $WinRM_Path
	if ($x -eq $null) { $x = @() }
	export_data "800" $x $PowerShellRemoting_Path\SessionCreated.csv "Microsoft-Windows-WinRM%4Operational.evtx" "PowerShellRemoting" "Session Created"

	$x = Get-AuthRecorded -Path $WinRM_Path
	if ($x -eq $null) { $x = @() }
	export_data "168" $x $PowerShellRemoting_Path\AuthRecorded.csv "Microsoft-Windows-WinRM%4Operational.evtx" "PowerShellRemoting" "Authentication recorded"
}
else { 
	write-host "Error: Microsoft-Windows-WinRM%4Operational.evtx event log is not found" -ForegroundColor Red   
}
#Remote Execution
#powershell remoting
#source
function PS_remoting_source {
	
	if ($securityparam -eq "yes") {
		. .\PSFunctions\PowerShellRemoting\ExplicitCreds.ps1
		Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation
		$hash = New-Object PSObject -property @{EventID = "131"; SANSCateogry = "PowerShellRemoting"; Event = "RDP Connection Attempts"; NumberOfOccurences = (Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count }
		$ResultsArray += $hash
	}
	. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
	Get-RDPreconnected -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "131"; SANSCateogry = "PowerShellRemoting"; Event = "RDP Connection Attempts"; NumberOfOccurences = (Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count }
	$ResultsArray += $hash

	$x = Get-ClosingWSManSession -Path $WinRM_Path  
	write-host  "Number of ClosingWSManSession  events:" , $x.count
	$x | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManSession.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "8"; SANSCateogry = "PowerShellRemoting"; Event = "Closing WSMan Session"; NumberOfOccurences = $x.count }
	$ResultsArray += $hash

	$x = Get-ClosingWSManCommand  -Path $WinRM_Path 
	write-host  "Number of ClosingWSManCommand  events:" , $x.count
	$x  | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManCommand.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "15"; SANSCateogry = "PowerShellRemoting"; Event = "Closing WSMan Command"; NumberOfOccurences = $x.count }
	$ResultsArray += $hash

	$x = Get-ClosingWSManShell -Path $WinRM_Path  
	write-host  "Number of ClosingWSManShell  events:" , $x.count
	$x | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManShell.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "16"; SANSCateogry = "PowerShellRemoting"; Event = "Closing WSMan Shell"; NumberOfOccurences = $x.count }
	$ResultsArray += $hash

	$x = Get-ClosingWSManSessionSucceeded -Path $WinRM_Path 
	write-host  "Number of ClosingWSManSessionSucceeded  events:" , $x.count
	$x  | Export-Csv -Path  $PowerShellRemoting_Path\ClosingWSManSessionSucceeded.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "33"; SANSCateogry = "PowerShellRemoting"; Event = "Closing WSMan Session Succeeded"; NumberOfOccurences = $x.count }
	$ResultsArray += $hash

	. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
	Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "131"; SANSCateogry = "PowerShellRemoting"; Event = "RDP Connection Attempts"; NumberOfOccurences = (Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count }
	$ResultsArray += $hash

	. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
	Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "131"; SANSCateogry = "PowerShellRemoting"; Event = "RDP Connection Attempts"; NumberOfOccurences = (Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count }
	$ResultsArray += $hash

	$x = Get-CreatingRunspaceObject -Path $PowerShellOperational_Path  
	write-host  "Number of CreatingRunspaceObject  events:" , $x.count
	$x | Export-Csv -Path  $PowerShellRemoting_Path\reatingRunspaceObject.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "8193"; SANSCateogry = "PowerShellRemoting"; Event = "Creating Runspace Object"; NumberOfOccurences = $x.count }
	$ResultsArray += $hash

	$x = Get-CreatingRunspacePoolObject -Path $PowerShellOperational_Path  
	write-host  "Number of CreatingRunspacePoolObject  events:" , $x.count
	$x | Export-Csv -Path  $PowerShellRemoting_Path\CreatingRunspacePoolObject.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "8194"; SANSCateogry = "PowerShellRemoting"; Event = "Creating Runspace Pool Object"; NumberOfOccurences = $x.count }
	$ResultsArray += $hash

	$x = Get-RunspaceState -Path $PowerShellOperational_Path 
	write-host  "Number of RunspaceState  events:" , $x.count
	$x  | Export-Csv -Path  $PowerShellRemoting_Path\RunspaceState.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "8197"; SANSCateogry = "PowerShellRemoting"; Event = "RDP Connection Attempts"; NumberOfOccurences = $x.count }
	$ResultsArray += $hash
}

#Extra events
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
		$x = Get-UnsuccessfulLogons  -Path $Security_Path
		if ($x -eq $null) { $x = @() }
		export_data "4625" $x $ExtraEvents_Path\UnsuccessfulLogons.csv "Security.evtx" "Extra Events" "Authentication recorded"

		$x = Get-EventlogCleared  -Path $Security_Path 
		if ($x -eq $null) { $x = @() }
		export_data "1102" $x $ExtraEvents_Path\EventlogCleared.csv "Security.evtx" "Extra Events" "Event log Cleared"
	}
	else { 
		write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else {
 write-host "UnsuccessfulLogons depend on Security event log which you choose not to parse" -ForegroundColor Red
}


$ResultsArray | Out-GridView -Title "Evilize"
