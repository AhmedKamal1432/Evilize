. ./Helper/helper.ps1

#Remote desktop
. .\WinEvent\RemoteDesktop\AllSuccessfulLogons.ps1
. .\WinEvent\RemoteDesktop\RDPreconnected.ps1
. .\WinEvent\RemoteDesktop\RDPDisconnected.ps1
. .\WinEvent\RemoteDesktop\RDPConnectionAttempts.ps1
. .\WinEvent\RemoteDesktop\RDPSuccessfulConnections.ps1
. .\WinEvent\RemoteDesktop\UserAuthSucceeded.ps1
. .\WinEvent\RemoteDesktop\RDPSessionLogonSucceed.ps1
. .\WinEvent\RemoteDesktop\RDPShellStartNotificationReceived.ps1
. .\WinEvent\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
. .\WinEvent\RemoteDesktop\RDPbeginSession.ps1
. .\WinEvent\RemoteDesktop\ExplicitCreds.ps1
. .\WinEvent\RemoteDesktop\RDPConnectingtoServer.ps1

#Map network shares
. .\WinEvent\MapNetworkShares\AdminLogonCreated.ps1
. .\WinEvent\MapNetworkShares\ComputerToValidate.ps1
. .\WinEvent\MapNetworkShares\KerberosAuthRequest.ps1
. .\WinEvent\MapNetworkShares\KerberosServiceRequest.ps1
. .\WinEvent\MapNetworkShares\NetworkShareAccessed.ps1
. .\WinEvent\MapNetworkShares\AuditingofSharedfiles.ps1
#PSExec
. .\WinEvent\PsExec\ServiceInstall.ps1
#Scheduled Tasks
. .\WinEvent\ScheduledTasks\ScheduleTaskCreated.ps1
. .\WinEvent\ScheduledTasks\ScheduleTaskDeleted.ps1
. .\WinEvent\ScheduledTasks\ScheduleTaskEnabled.ps1
. .\WinEvent\ScheduledTasks\ScheduleTaskDisabled.ps1
. .\WinEvent\ScheduledTasks\ScheduleTaskUpdated.ps1
. .\WinEvent\ScheduledTasks\CreatingTaskSchedulerTask.ps1
. .\WinEvent\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
. .\WinEvent\ScheduledTasks\DeletingTaskSchedulerTask.ps1
. .\WinEvent\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
. .\WinEvent\ScheduledTasks\CompletingTaskSchedulerTask.ps1
#Services
. .\WinEvent\Services\ServiceInstalledonSystem.ps1
. .\WinEvent\Services\ServiceCrashed.ps1
. .\WinEvent\Services\ServiceSentControl.ps1
. .\WinEvent\Services\ServiceStartorStop.ps1
. .\WinEvent\Services\StartTypeChanged.ps1
#	WMI\WMIC
. .\WinEvent\WMI_WMIC\SystemQueryWMI.ps1
. .\WinEvent\WMI_WMIC\TemporaryEventConsumer.ps1
. .\WinEvent\WMI_WMIC\PermenantEventConsumer.ps1
#PowerShellRemoting
. .\WinEvent\PowerShellRemoting\ScriptBlockLogging.ps1
. .\WinEvent\PowerShellRemoting\ScriptBlockAuditing.ps1
. .\WinEvent\PowerShellRemoting\LateralMovementDetection.ps1
. .\WinEvent\PowerShellRemoting\StartPSRemoteSession.ps1
. .\WinEvent\PowerShellRemoting\EndPSRemoteSession.ps1
. .\WinEvent\PowerShellRemoting\PipelineExecution.ps1
. .\WinEvent\PowerShellRemoting\SessionCreated.ps1
. .\WinEvent\PowerShellRemoting\AuthRecorded.ps1
. .\WinEvent\PowerShellRemoting\ClosingWSManSession.ps1
. .\WinEvent\PowerShellRemoting\ClosingWSManCommand.ps1
. .\WinEvent\PowerShellRemoting\ClosingWSManShell.ps1
. .\WinEvent\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
. .\WinEvent\PowerShellRemoting\CreatingRunspaceObject.ps1
. .\WinEvent\PowerShellRemoting\CreatingRunspacePoolObject.ps1
. .\WinEvent\PowerShellRemoting\RunspaceState.ps1
#extra events
. .\WinEvent\ExtraEvents\UnsuccessfulLogons.ps1
. .\WinEvent\ExtraEvents\EventlogCleared.ps1
. .\WinEvent\ExtraEvents\EventlogClearedSystem.ps1

$global:securityparam
function winevent_main {
	print_logo "winevent"
	if (check_logs_path $Logs_Path) {
        evt_conversion $Logs_Path
        csv_output_directories $Logs_Path
        check_individual_logs
        $global:securityparam = "no"
		if ($security) {
			$global:securityparam = "yes"
		}
    }
	
}
winevent_main


function parse_log_winevent {
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string] $EventID,
		[Parameter(Mandatory = $true, Position = 1)]
		[scriptblock] $parser,
		[Parameter(Mandatory = $true, Position = 2)]
		[string] $OutputFile,
		[Parameter(Mandatory = $true, Position = 3)]
		[string] $event_file_type,
		[Parameter(Mandatory = $true, Position = 4)]
		[string] $sans_catagory,
		[Parameter(Mandatory = $true, Position = 5)]
		[string] $event_name,
		[Parameter(Mandatory = $true, Position = 6)]
		[string] $log_file_path
	)
	$events = $parser.invoke($log_file_path)
	$events | Export-Csv -Path $OutputFile -NoTypeInformation 
	$hash = New-Object PSObject -property @{EventID = $EventID; EventLog = $event_file_type; SANSCateogry = $sans_catagory; Event = $event_name; NumberOfOccurences = $events.count }
	$global:ResultsArray += $hash
	Write-Host $event_name":" $events.count -ForegroundColor Green

}

# Remote Access
#Remote desktop
#destination#
Print_Seprator "RemoteDesktop"

if ($securityparam -eq "yes") {
 if ($Valid_Security_Path -eq $true) {

	parse_log_winevent "4624" ${function:\Get-AllSuccessfulLogons} $RemoteDesktop_Path\AllSuccessfulLogons.csv "Security.evtx" "RemoteDesktop" "All Successful Logons" $Security_Path 

	parse_log_winevent "4778" ${function:\Get-RDPreconnected} $RemoteDesktop_Path\RDPreconnected.csv "Security.evtx" "RemoteDesktop" "RDP sessions reconnected"  $Security_Path
		
	parse_log_winevent "4779" ${function:\Get-RDPDisconnected} $RemoteDesktop_Path\RDPDisconnected.csv "Security.evtx" "RemoteDesktop" "RDP sessions disconnected"  $Security_Path 

	}
 else { 
  write-host "Error: Security event log is not found" -ForegroundColor Red
        
 }
}
else {
	write-host " AllSuccessfulLogons- RDPreconnected -RDPDisconnected depend on Security event log which you choose not to parse" -ForegroundColor Red
}

if ($Valid_RDPCORETS_Path -eq $true) {

	parse_log_winevent "131" ${function:\Get-RDPConnectionAttempts} $RemoteDesktop_Path\RDPConnectionAttempts.csv  "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx" "RemoteDesktop" "RDP Connection Attempts" $RDPCORETS_Path  

	parse_log_winevent "98" ${function:\Get-RDPSuccessfulConnections} $RemoteDesktop_Path\RDPSuccessfulConnections.csv  "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx" "RemoteDesktop" "RDP Successful Connections" $RDPCORETS_Path 
}
else {
 write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
}

if ($Valid_RemoteConnection_Path -eq $true) {

	parse_log_winevent "1149" ${function:\Get-UserAuthSucceeded} $RemoteDesktop_Path\UserAuthSucceeded.csv.csv "Microsoft-Windows-TerminalServices-RemoteC onnectionManager%4Operational.evtx" "RemoteDesktop" "RDP User authentication succeeded" $RemoteConnection_Path  
	
}
else {
 write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
}

if ($Valid_TerminalServices_Path -eq $true) {

	parse_log_winevent "21" ${function:\Get-RDPSessionLogonSucceed} $RemoteDesktop_Path\RDPSessionLogonSucceeded.csv  "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "RemoteDesktop" "RDP Successful Logons Sessions" $TerminalServices_Path 

	parse_log_winevent "22" ${function:\Get-RDPShellStartNotificationReceived} $RemoteDesktop_Path\RDPShellStartNotificationReceived.csv  "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "RemoteDesktop" "RDP Shell Start Notification recieved" $TerminalServices_Path  

	parse_log_winevent "25" ${function:\Get-RDPShellSessionReconnectedSucceeded} $RemoteDesktop_Path\RDPShellSessionReconnectedSucceeded.csv  "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx" "RemoteDesktop" "RDP Shell Session reconnection succeeded" $TerminalServices_Path 

	parse_log_winevent "41" ${function:\Get-RDPbeginSession} $RemoteDesktop_Path\RDPbeginSession.csv "Microsoft-Windows-TerminalServices-LocalSessio nManager%4Operational.evtx" "RemoteDesktop" "RDP Begin Session" $TerminalServices_Path 

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
Print_Seprator "MapNetworkShare"

if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
		parse_log_winevent "4672" ${function:\Get-AdminLogonCreated} $MapNetworkShares_Path\AdminLogonCreated.csv "Security.evtx" "MapNetworkShares" "Admin  Logon created" $Security_Path  

		parse_log_winevent "4776" ${function:\Get-ComputerToValidate} $MapNetworkShares_Path\ComputerToValidate.csv "Security.evtx" "MapNetworkShares"  "Computer to validate" $Security_Path 

		parse_log_winevent "4768" ${function:\Get-KerberosAuthRequest} $MapNetworkShares_Path\KerberosAuthRequest.csv "Security.evtx" "MapNetworkShares"  "Kerberos Authentication Request" $Security_Path 

		parse_log_winevent "4769" ${function:\Get-KerberosServiceRequest} $MapNetworkShares_Path\KerberosServiceRequest.csv "Security.evtx" "MapNetworkShares"  "Kerberos Service Request" $Security_Path 

		parse_log_winevent "5140" ${function:\Get-NetworkShareAccessed} $MapNetworkShares_Path\NetworkShareAccessed.csv "Security.evtx" "MapNetworkShares"  "Network Share Accessed" $Security_Path  

		parse_log_winevent "5145" ${function:\Get-AuditingofSharedfiles} $MapNetworkShares_Path\AuditingofSharedfiles.csv "Security.evtx" "MapNetworkShares"  "Auditing of Shared Files" $Security_Path  

		# Remote Access 
		#Map Network Shares
		# source
		function Source_NetworkMap {
			. .\WinEvent\MapNetworkShares\ExplicitCreds.ps1
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
Print_Seprator "PsExec"

if ($Valid_System_Path -eq $true) {
	parse_log_winevent "5145" ${function:\Get-ServiceInstall} $PsExec_Path\ServiceInstall.csv "System.evtx" "PSExec" "Installed Service"  $System_Path  
}
else { 
	write-host "Error: System event log is not found" -ForegroundColor Red   
}

# PSExec/ source Repeated

#Remote Execution
#Scheduled Tasks
#Destination
Print_Seprator "ScheduledTasks"

if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {

		parse_log_winevent "4698" ${function:\Get-ScheduleTaskCreated} $ScheduledTasks_Path\ScheduleTaskDeleted.csv "Security.evtx" "ScheduledTasks" "Schedule  Task Created" $Security_Path

		parse_log_winevent "4699" ${function:\Get-ScheduleTaskDeleted} $ScheduledTasks_Path\ScheduleTaskDeleted.csv "Security.evtx" "ScheduledTasks" "Schedule  Task Deleted" $Security_Path 

		parse_log_winevent "4700" ${function:\Get-ScheduleTaskEnabled} $ScheduledTasks_Path\ScheduleTaskEnabled.csv "Security.evtx" "ScheduledTasks" "Schedule  Task Enabled" $Security_Path 

		parse_log_winevent "4701" ${function:\Get-ScheduleTaskDisabled} $ScheduledTasks_Path\ScheduleTaskDisabled.csv "Security.evtx" "ScheduledTasks" "Schedule  Task Disabled" $Security_Path 

		parse_log_winevent "4702" ${function:\Get-ScheduleTaskUpdated} $ScheduledTasks_Path\ScheduleTaskUpdated.csv "Security.evtx" "ScheduledTasks" "Schedule  Task Updated" $Security_Path 
	}
	else { 
		write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else {
	write-host " ScheduleTaskCreated- ScheduleTaskDeleted-ScheduleTaskEnabled-ScheduleTaskDisabled-ScheduleTaskUpdated depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_TaskScheduler_Path -eq $true) {

	parse_log_winevent "106" ${function:\Get-CreatingTaskSchedulerTask} $ScheduledTasks_Path\CreatingTaskSchedulerTask.csv  "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Creating TaskScheduler Task" $TaskScheduler_Path 

	parse_log_winevent "140" ${function:\Get-UpdatingTaskSchedulerTask} $ScheduledTasks_Path\UpdatingTaskSchedulerTask.csv  "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Updating TaskScheduler Task" $TaskScheduler_Path

	parse_log_winevent "141" ${function:\Get-DeletingTaskSchedulerTask} $ScheduledTasks_Path\DeletingTaskSchedulerTask.csv  "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Deleting TaskScheduler Task" $TaskScheduler_Path 

	parse_log_winevent "200" ${function:\Get-ExecutingTaskSchedulerTask} $ScheduledTasks_Path\ExecutingTaskSchedulerTask.csv  "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Executing TaskScheduler Task" $TaskScheduler_Path

	parse_log_winevent "201" ${function:\Get-CompletingTaskSchedulerTask} $ScheduledTasks_Path\CompletingTaskSchedulerTask.csv  "Microsoft-Windows-TaskScheduler%4Operational.evtx" "ScheduledTasks" "Completing TaskScheduler Task" $TaskScheduler_Path 
}
else { 
	write-host "Error: Microsoft-Windows-TaskScheduler%4en4Operational event log is not found" -ForegroundColor Red   
}


#Scheduled Tasks/ source Repetead

#Remote Execution
#services
#destination
Print_Seprator "Services"

if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {

		parse_log_winevent "4697" ${function:\Get-ServiceInstalledonSystem} $Services_Path\ServiceInstalledonSystem.csv "Security.evtx" "Services" "Service  Installed on System" $Security_Path  
	}
	else { 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else {
 write-host "ServiceInstalledonSystem depend on Security event log which you choose not to parse" -ForegroundColor Red
}
if ($Valid_System_Path -eq $true) {

	parse_log_winevent "7034" ${function:\Get-ServiceCrashed} $Services_Path\ServiceCrashed.csv "System.evtx" "Services" "Service Crashed"  $System_Path  

	parse_log_winevent "7035" ${function:\Get-ServiceSentControl} $Services_Path\ServiceSentControl.csv "System.evtx" "Services" "Service Sent Control"  $System_Path  

	# 99% Of system.evtx is this event
	if($all_logs){
		parse_log_winevent "7036" ${function:\Get-ServiceStartorStop} $Services_Path\ServiceStartorStop.csv "System.evtx" "Services" "Service Start or Stop"  $System_Path 
	}

	parse_log_winevent "7040" ${function:\Get-StartTypeChanged} $Services_Path\StartTypeChanged.csv "System.evtx" "Services" "Start Type Changed"  $System_Path  

	parse_log_winevent "7045" ${function:\Get-ServiceInstall} $Services_Path\ServiceInstall.csv "System.evtx" "Services" "Service Install"  $System_Path  
}
else { 
	write-host "Error: System event log is not found" -ForegroundColor Red   
}
####################################################################################################################################
#Remote Execution
#WMI\WMIC
#destination
Print_Seprator "WMI/WMIC"

if ($Valid_WMI_Path -eq $true) {

	parse_log_winevent "5857" ${function:\Get-SystemQueryWMI} $WMIOut_Path\SystemQueryWMI.csv "Microsoft-Windows-WMIActivity%4Operational.evtx" "WMI\WMIC" "System Query WMI"  $WMI_Path  

	parse_log_winevent "5860" ${function:\Get-TemporaryEventConsumer} $WMIOut_Path\TemporaryEventConsumer.csv "Microsoft-Windows-WMIActivity%4Operational.evtx"  "WMI\WMIC" "Temporary Event Consumer" $WMI_Path 

	parse_log_winevent "5861" ${function:\Get-PermenantEventConsumer} $WMIOut_Path\PermenantEventConsumer.csv "Microsoft-Windows-WMIActivity%4Operational.evtx"  "WMI\WMIC" "Permenant Event Consumer" $WMI_Path
}
else { 
	write-host "Error: Microsoft-Windows-WMI-Activity%4Operational event log is not found" -ForegroundColor Red   
}

#WMI\WMIC source Repeated

#Remote Execution
#powershell remoting
#destination
Print_Seprator "PowerShellRemoting"

if ($Valid_PowerShellOperational_Path -eq $true) {

	parse_log_winevent "4103" ${function:\Get-ScriptBlockLogging} $PowerShellRemoting_Path\ScriptBlockLogging.csv "Microsoft-Windows-PowerShell%4Operational.evtx" "PowerShellRemoting" "Script Block Logging" $PowerShellOperational_Path  

	parse_log_winevent "4104" ${function:\Get-ScriptBlockAuditing} $PowerShellRemoting_Path\ScriptBlockAuditing.csv "Microsoft-Windows-PowerShell%4Operational.evtx" "PowerShellRemoting" "Script Block Auditing" $PowerShellOperational_Path   

	parse_log_winevent "53504" ${function:\Get-LateralMovementDetection} $PowerShellRemoting_Path\PowerShellOperational_Path.csv  "Microsoft-Windows-PowerShell%4Operational.evtx" "PowerShellRemoting" "Lateral Movement Detection" $PowerShellOperational_Path  
}
else { 
	write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red   
}

if ($Valid_WinPowerShell_Path -eq $true) {

	parse_log_winevent "400" ${function:\Get-StartPSRemoteSession} $PowerShellRemoting_Path\StartPSRemoteSession.csv "Wi ndows PowerShell.evtx" "PowerShellRemoting" "Start PSRemote Session" $WinPowerShell_Path 

	parse_log_winevent "403" ${function:\Get-EndPSRemoteSession} $PowerShellRemoting_Path\EndPSRemoteSession.csv "Wi ndows PowerShell.evtx" "PowerShellRemoting" "End PSRemote Session" $WinPowerShell_Path 


	parse_log_winevent "800" ${function:\Get-PipelineExecution} $PowerShellRemoting_Path\PipelineExecution.csv "Wi ndows PowerShell.evtx" "PowerShellRemoting" "Partial Scripts Code" $WinPowerShell_Path
}
else { 
	write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red   
}
	
if ($Valid_WinRM_Path -eq $true) {
	parse_log_winevent "800" ${function:\Get-SessionCreated} $PowerShellRemoting_Path\SessionCreated.csv "Microsoft-Windows-WinRM%4Operational.evtx" "PowerShellRemoting" "Session Created"  $WinRM_Path

	parse_log_winevent "168" ${function:\Get-AuthRecorded} $PowerShellRemoting_Path\AuthRecorded.csv "Microsoft-Windows-WinRM%4Operational.evtx" "PowerShellRemoting" "Authentication recorded"  $WinRM_Path
}
else { 
	write-host "Error: Microsoft-Windows-WinRM%4Operational.evtx event log is not found" -ForegroundColor Red   
}
#Remote Execution
#powershell remoting
#source
function PS_remoting_source {
	
	if ($securityparam -eq "yes") {
		. .\WinEvent\PowerShellRemoting\ExplicitCreds.ps1
		Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation
		$hash = New-Object PSObject -property @{EventID = "131"; SANSCateogry = "PowerShellRemoting"; Event = "RDP Connection Attempts"; NumberOfOccurences = (Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count }
		$ResultsArray += $hash
	}
	. .\WinEvent\PowerShellRemoting\RDPreconnected.ps1
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

	. .\WinEvent\PowerShellRemoting\RDPreconnected.ps1
	Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
	$hash = New-Object PSObject -property @{EventID = "131"; SANSCateogry = "PowerShellRemoting"; Event = "RDP Connection Attempts"; NumberOfOccurences = (Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count }
	$ResultsArray += $hash

	. .\WinEvent\PowerShellRemoting\RDPreconnected.ps1
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
Print_Seprator "Extra Events"

if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
		parse_log_winevent "4625" ${function:\Get-UnsuccessfulLogons} $ExtraEvents_Path\UnsuccessfulLogons.csv "Security.evtx" "Extra Events" "Unsuccessful Logons" $Security_Path

		parse_log_winevent "1102" ${function:\Get-EventlogCleared} $ExtraEvents_Path\EventlogCleared.csv "Security.evtx" "Extra Events" "Event log Cleared[Security.evtx]"  $Security_Path

	}
	else { 
		write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
else {
 write-host "UnsuccessfulLogons depend on Security event log which you choose not to parse" -ForegroundColor Red
}

if ($Valid_System_Path) {
	parse_log_winevent "104" ${function:\Get-EventlogClearedSystem} $ExtraEvents_Path\EventlogClearedSystem.csv "Security.evtx" "Extra Events" "Event log Cleared[System.evtx]"  $System_Path
}

$ResultsArray | Out-GridView -Title "Evilize"
