$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path"  
$securityparam= Read-Host -Prompt "Do you want to parse the security event log? yes\no"  
##Validating Paths
$LogsPathTest=Test-Path -Path "$Logs_Path"
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
$evtFiles = Get-ChildItem -Recurse -Path $Logs_Path -filter (-NOT '*.evtx') 
if (-NOT ($evtFiles -eq $null)){
	write-output $evtFiles
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
			wevtutil epl $EvtPath $EvtxPath /lf:true      
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


# Remote Access
	#Remote desktop
		#destination#
if ($securityparam -eq "yes") {
#. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of RDPreconnected  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPreconnected.csv).Length -1)

. .\PSFunctions\RemoteDesktop\RDPreconnected.ps1
Get-RDPreconnected -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPreconnected.csv -NoTypeInformation 
write-host  "Number of RDPreconnected  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPreconnected.csv).Length -1)

. .\PSFunctions\RemoteDesktop\RDPDisconnected.ps1
Get-RDPDisconnected -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPDisconnected.csv -NoTypeInformation
write-host  "Number of RDPDisconnected  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPDisconnected.csv).Length -1)
}
. .\PSFunctions\RemoteDesktop\RDPConnectionAttempts.ps1
Get-RDPConnectionAttempts -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPConnectionAttempts.csv -NoTypeInformation
write-host  "Number of RDPConnectionAttempts  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPConnectionAttempts.csv).Length -1)

. .\PSFunctions\RemoteDesktop\RDPSuccessfulConnections.ps1
Get-RDPSuccessfulConnections -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPSuccessfulConnections.csv -NoTypeInformation
write-host  "Number of RDPSuccessfulConnections  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPSuccessfulConnections.csv).Length -1)

. .\PSFunctions\RemoteDesktop\UserAuthSucceeded.ps1
Get-UserAuthSucceeded -Path $RemoteConnection_Path | Export-Csv -Path Results\RemoteDesktopcsv\UserAuthSucceeded.csv -NoTypeInformation 
write-host  "Number of UserAuthSucceeded  events:" , ((Get-Content Results\RemoteDesktopcsv\UserAuthSucceeded.csv).Length -1)

. .\PSFunctions\RemoteDesktop\RDPSessionLogonSucceed.ps1
Get-RDPSessionLogonSucceed -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPSessionLogonSucceed.csv -NoTypeInformation
write-host  "Number of RDPSessionLogonSucceed  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPSessionLogonSucceed.csv).Length -1)

. .\PSFunctions\RemoteDesktop\RDPShellStartNotificationReceived.ps1
Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPShellStartNotificationReceived.csv -NoTypeInformation
write-host  "Number of RDPShellStartNotificationReceived  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPShellStartNotificationReceived.csv).Length -1)

. .\PSFunctions\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation
write-host  "Number of RDPShellSessionReconnectedSucceeded  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPShellSessionReconnectedSucceeded.csv).Length -1)

. .\PSFunctions\RemoteDesktop\RDPbeginSession.ps1
Get-RDPbeginSession -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPbeginSession.csv -NoTypeInformation
write-host  "Number of RDPbeginSession  events:" , ((Get-Content Results\RemoteDesktopcsv\RDPbeginSession.csv).Length -1)

# Remote Access
	#Remote desktop
		#source
if ($securityparam -eq "yes") {
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\ExplicitCreds.csv -NoTypeInformation
}
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectingtoServer.ps1
#Get-RDPConnectingtoServer -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPConnectingtoServer.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectionInitiated.ps1
#Get-RDPConnectionInitiated  -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPConnectionInitiated.csv -NoTypeInformation
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\AllSuccessfulLogons.csv -NoTypeInformation
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\MapNetworkSharescsv\AllSuccessfulLogons.csv).Length -1) 

. .\PSFunctions\MapNetworkShares\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\AdminLogonCreated.csv -NoTypeInformation
write-host  "Number of AdminLogonCreated  events:" , ((Get-Content Results\MapNetworkSharescsv\AdminLogonCreated.csv).Length -1)

. .\PSFunctions\MapNetworkShares\ComputerToValidate.ps1
Get-ComputerToValidate -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\ComputerToValidate.csv -NoTypeInformation
write-host  "Number of ComputerToValidate  events:" , ((Get-Content Results\MapNetworkSharescsv\ComputerToValidate.csv).Length -1)

. .\PSFunctions\MapNetworkShares\KerberosAuthRequest.ps1
Get-KerberosAuthRequest -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\KerberosAuthRequest.csv -NoTypeInformation
write-host  "Number of KerberosAuthRequest  events:" , ((Get-Content Results\MapNetworkSharescsv\KerberosAuthRequest.csv).Length -1)

. .\PSFunctions\MapNetworkShares\KerberosServiceRequest.ps1
Get-KerberosServiceRequest -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\KerberosServiceRequest.csv -NoTypeInformation
write-host  "Number of KerberosServiceRequest  events:" , ((Get-Content Results\MapNetworkSharescsv\KerberosServiceRequest.csv).Length -1)

. .\PSFunctions\MapNetworkShares\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\NetworkShareAccessed.csv -NoTypeInformation
write-host  "Number of NetworkShareAccessed  events:" , ((Get-Content Results\MapNetworkSharescsv\NetworkShareAccessed.csv).Length -1)

. .\PSFunctions\MapNetworkShares\AuditingofSharedfiles.ps1
Get-AuditingofSharedfiles -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\AuditingofSharedfiles.csv -NoTypeInformation
write-host  "Number of AuditingofSharedfiles  events:" , ((Get-Content Results\MapNetworkSharescsv\AuditingofSharedfiles.csv).Length -1)

}
# Remote Access 
	#Map Network Shares
		# source
if ($securityparam -eq "yes") {
#. .\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\ExplicitCreds.csv -NoTypeInformation
}
#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\PsExec\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\PsExeccsv\AllSuccessfulLogons.csv).Length -1)

#. .\PSFunctions\PsExec\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Get-Content Results\PsExeccsv\AdminLogonCreated.csv).Length -1)

#. .\PSFunctions\PsExec\NetworkShareAccessed.ps1
#Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\NetworkShareAccessed.csv -NoTypeInformation
#write-host  "Number of NetworkShareAccessed  events:" , ((Get-Content Results\PsExeccsv\NetworkShareAccessed.csv).Length -1)
}
. .\PSFunctions\PsExec\ServiceInstall.ps1
Get-ServiceInstall -Path $System_Path  | Export-Csv -Path Results\PsExeccsv\ServiceInstall.csv -NoTypeInformation
write-host  "Number of ServiceInstall  events:" , ((Get-Content Results\PsExeccsv\ServiceInstall.csv).Length -1)

#Remote Execution
	#PsExec
		#source
if ($securityparam -eq "yes") {
#. .\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\ExplicitCreds.csv -NoTypeInformation
}
############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\ScheduledTasks\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\ScheduledTaskscsv\AllSuccessfulLogons.csv).Length -1)

#. .\PSFunctions\ScheduledTasks\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\ScheduledTaskscsv\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Get-Content Results\ScheduledTaskscsv\AdminLogonCreated.csv).Length -1)

. .\PSFunctions\ScheduledTasks\ScheduleTaskCreated.ps1
Get-ScheduleTaskCreated -Path $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskCreated.csv -NoTypeInformation
write-host  "Number of ScheduleTaskCreated  events:" , ((Get-Content Results\ScheduledTaskscsv\ScheduleTaskCreated.csv).Length -1)

. .\PSFunctions\ScheduledTasks\ScheduleTaskDeleted.ps1
Get-ScheduleTaskDeleted -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskDeleted.csv -NoTypeInformation
write-host  "Number of ScheduleTaskDeleted  events:" , ((Get-Content Results\ScheduledTaskscsv\ScheduleTaskDeleted.csv).Length -1)

. .\PSFunctions\ScheduledTasks\ScheduleTaskEnabled.ps1
Get-ScheduleTaskEnabled -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskEnabled.csv -NoTypeInformation
write-host  "Number of ScheduleTaskEnabled  events:" , ((Get-Content Results\ScheduledTaskscsv\ScheduleTaskEnabled.csv).Length -1)

. .\PSFunctions\ScheduledTasks\ScheduleTaskDisabled.ps1
Get-ScheduleTaskDisabled -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskDisabled.csv -NoTypeInformation
write-host  "Number of ScheduleTaskDisabled  events:" , ((Get-Content Results\ScheduledTaskscsv\ScheduleTaskDisabled.csv).Length -1)

. .\PSFunctions\ScheduledTasks\ScheduleTaskUpdated.ps1
Get-ScheduleTaskUpdated -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskUpdated.csv -NoTypeInformation
write-host  "Number of ScheduleTaskUpdated  events:" , ((Get-Content Results\ScheduledTaskscsv\ScheduleTaskUpdated.csv).Length -1)
}
. .\PSFunctions\ScheduledTasks\CreatingTaskSchedulerTask .ps1
Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\CreatingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of CreatingTaskSchedulerTask  events:" , ((Get-Content Results\ScheduledTaskscsv\CreatingTaskSchedulerTask.csv).Length -1)

. .\PSFunctions\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\UpdatingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of UpdatingTaskSchedulerTask  events:" , ((Get-Content Results\ScheduledTaskscsv\UpdatingTaskSchedulerTask.csv).Length -1)

. .\PSFunctions\ScheduledTasks\DeletingTaskSchedulerTask .ps1
Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\DeletingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of DeletingTaskSchedulerTask  events:" , ((Get-Content Results\ScheduledTaskscsv\DeletingTaskSchedulerTask.csv).Length -1)

. .\PSFunctions\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\ExecutingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of ExecutingTaskSchedulerTask  events:" , ((Get-Content Results\ScheduledTaskscsv\ExecutingTaskSchedulerTask.csv).Length -1)

. .\PSFunctions\ScheduledTasks\CompletingTaskSchedulerTask.ps1
Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\CompletingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of CompletingTaskSchedulerTask  events:" , ((Get-Content Results\ScheduledTaskscsv\CompletingTaskSchedulerTask.csv).Length -1)

#Remote Execution
	#Scheduled Tasks
		#source
#. .\ScheduledTasks\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\ScheduledTaskscsv\ExplicitCreds.csv -NoTypeInformation
}
#####################################################################################################################################
#Remote Execution
	#services
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\Services\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\Servicescsv\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\Servicescsv\AllSuccessfulLogons.csv).Length -1)

. .\PSFunctions\Services\ServiceInstalledonSystem.ps1
Get-ServiceInstalledonSystem -Path $Security_Path  | Export-Csv -Path Results\Servicescsv\ServiceInstalledonSystem.csv -NoTypeInformation
write-host  "Number of ServiceInstalledonSystem  events:" , ((Get-Content Results\Servicescsv\ServiceInstalledonSystem.csv).Length -1)
}
. .\PSFunctions\Services\ServiceCrashed.ps1
Get-ServiceCrashed -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceCrashed.csv -NoTypeInformation
write-host  "Number of ServiceCrashed  events:" , ((Get-Content Results\Servicescsv\ServiceCrashed.csv).Length -1)

. .\PSFunctions\Services\ServiceSentControl.ps1
Get-ServiceSentControl -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceSentControl.csv -NoTypeInformation
write-host  "Number of ServiceSentControl  events:" , ((Get-Content Results\Servicescsv\ServiceSentControl.csv).Length -1)

. .\PSFunctions\Services\ServiceStartorStop.ps1
Get-ServiceStartorStop -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceStartorStop.csv -NoTypeInformation
write-host  "Number of ServiceStartorStop  events:" , ((Get-Content Results\Servicescsv\ServiceStartorStop.csv).Length -1)

. .\PSFunctions\Services\StartTypeChanged.ps1
Get-StartTypeChanged -Path $System_Path  | Export-Csv -Path Results\Servicescsv\StartTypeChanged.csv -NoTypeInformation
write-host  "Number of StartTypeChanged  events:" , ((Get-Content Results\Servicescsv\StartTypeChanged.csv).Length -1)

#. .\PSFunctions\Services\ServiceInstall.ps1
#Get-ServiceInstall -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceInstall.csv -NoTypeInformation
#write-host  "Number of ServiceInstall  events:" , ((Get-Content Results\Servicescsv\ServiceInstall.csv).Length -1)

####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\WMI_WMIC\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\WMI_WMICcsv\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\WMI_WMICcsv\AllSuccessfulLogons.csv).Length -1)

#. .\PSFunctions\WMI_WMIC\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\WMI_WMICcsv\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Get-Content Results\WMI_WMICcsv\AdminLogonCreated.csv).Length -1)
}
. .\PSFunctions\WMI_WMIC\SystemQueryWMI.ps1
Get-SystemQueryWMI -Path $WinRM_Path  | Export-Csv -Path Results\WMI_WMICcsv\SystemQueryWMI.csv -NoTypeInformation
write-host  "Number of -SystemQueryWMI  events:" , ((Get-Content Results\WMI_WMICcsv\SystemQueryWMI.csv).Length -1)

. .\PSFunctions\WMI_WMIC\TemporaryEventConsumer.ps1
Get-TemporaryEventConsumer -Path $WinRM_Path | Export-Csv -Path Results\WMI_WMICcsv\TemporaryEventConsumer.csv -NoTypeInformation
write-host  "Number of TemporaryEventConsumer  events:" , ((Get-Content Results\WMI_WMICcsv\TemporaryEventConsumer.csv).Length -1)

. .\PSFunctions\WMI_WMIC\PermenantEventConsumer.ps1
Get-PermenantEventConsumer -Path $WinRM_Path   | Export-Csv -Path Results\WMI_WMICcsv\PermenantEventConsumer.csv -NoTypeInformation
write-host  "Number of PermenantEventConsumer  events:" , ((Get-Content Results\WMI_WMICcsv\PermenantEventConsumer.csv).Length -1)

#Remote Execution
	#WMI\WMIC
		#source
#. .\WMI\WMIC\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\WMI_WMICcsv\ExplicitCreds.csv -NoTypeInformation
}
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\PowerShellRemoting\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path Results\PowerShellRemotingcsv\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\PowerShellRemotingcsv\AllSuccessfulLogons.csv).Length -1)

#. .\PSFunctions\PowerShellRemoting\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Get-Content Results\PowerShellRemotingcsv\AdminLogonCreated.csv).Length -1)

}
. .\PSFunctions\PowerShellRemoting\ScriptBlockLogging.ps1
Get-ScriptBlockLogging -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\ScriptBlockLogging.csv -NoTypeInformation
write-host  "Number of ScriptBlockLogging  events:" , ((Get-Content Results\PowerShellRemotingcsv\ScriptBlockLogging.csv).Length -1)

. .\PSFunctions\PowerShellRemoting\ScriptBlockAuditing.ps1
Get-ScriptBlockAuditing -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\ScriptBlockAuditing.csv -NoTypeInformation
write-host  "Number of ScriptBlockAuditing  events:" , ((Get-Content Results\PowerShellRemotingcsv\ScriptBlockAuditing.csv).Length -1)

. .\PSFunctions\PowerShellRemoting\LateralMovementDetection.ps1
Get-LateralMovementDetection -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\LateralMovementDetection.csv -NoTypeInformation
write-host  "Number of LateralMovementDetection  events:" , ((Get-Content Results\PowerShellRemotingcsv\LateralMovementDetection.csv).Length -1)

. .\PSFunctions\PowerShellRemoting\StartPSRemoteSession.ps1
Get-StartPSRemoteSession -Path $WinPowerShell_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\StartPSRemoteSession.csv -NoTypeInformation
write-host  "Number of StartPSRemoteSession  events:" , ((Get-Content Results\PowerShellRemotingcsv\StartPSRemoteSession.csv).Length -1)

. .\PSFunctions\PowerShellRemoting\EndPSRemoteSession.ps1
Get-EndPSRemoteSession -Path $WinPowerShell_Path | Export-Csv -Path Results\PowerShellRemotingcsv\EndPSRemoteSession.csv -NoTypeInformation
write-host  "Number of EndPSRemoteSession  events:" , ((Get-Content Results\PowerShellRemotingcsv\EndPSRemoteSession.csv).Length -1)

. .\PSFunctions\PowerShellRemoting\PipelineExecution.ps1
Get-PipelineExecution -Path $WinPowerShell_Path| Export-Csv -Path Results\PowerShellRemotingcsv\PipelineExecution.csv -NoTypeInformation
write-host  "Number of PipelineExecution  events:" , ((Get-Content Results\PowerShellRemotingcsv\PipelineExecution.csv).Length -1)

#Remote Execution
	#powershell remoting
		#source
if ($securityparam -eq "yes") {
#. .\PSFunctions\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation
}
#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManSession.ps1
#Get-ClosingWSManSession -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManSession.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManCommand .ps1
#Get-ClosingWSManCommand  -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManCommand .csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManShell.ps1
#Get-ClosingWSManShell -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManShell.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
#Get-ClosingWSManSessionSucceeded -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManSessionSucceeded.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\CreatingRunspaceObject.ps1
#Get-CreatingRunspaceObject -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\CreatingRunspaceObject.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\CreatingRunspacePoolObject.ps1
#Get-CreatingRunspacePoolObject -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\CreatingRunspacePoolObject.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\RunspaceState.ps1
#Get-RunspaceState -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RunspaceState.csv -NoTypeInformation
