$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path"  

##Validating Paths
$LogsPathTest=Test-Path -Path "$Logs_Path"


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
$TaskScheduler_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evtx"
$TaskSchedulerevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evt"
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
. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PSFunctions\RemoteDesktop\RDPreconnected.ps1
Get-RDPreconnected -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPreconnected.csv -NoTypeInformation 

. .\PSFunctions\RemoteDesktop\RDPDisconnected.ps1
Get-RDPDisconnected -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPDisconnected.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPConnectionAttempts.ps1
Get-RDPConnectionAttempts -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPConnectionAttempts.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPSuccessfulConnections.ps1
Get-RDPSuccessfulConnections -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPSuccessfulConnections.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\UserAuthSucceeded.ps1
Get-UserAuthSucceeded -Path $RemoteConnection_Path | Export-Csv -Path Results\RemoteDesktopcsv\UserAuthSucceeded.csv -NoTypeInformation 

. .\PSFunctions\RemoteDesktop\RDPSessionLogonSucceed.ps1
Get-RDPSessionLogonSucceed -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPSessionLogonSucceed.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPShellStartNotificationReceived.ps1
Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPShellStartNotificationReceived.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPbeginSession.ps1
Get-RDPbeginSession -Path $TerminalServices_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPbeginSession.csv -NoTypeInformation

# Remote Access
	#Remote desktop
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\ExplicitCreds.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectingtoServer.ps1
#Get-RDPConnectingtoServer -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPConnectingtoServer.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectionInitiated.ps1
#Get-RDPConnectionInitiated  -Path $RDPCORETS_Path  | Export-Csv -Path Results\RemoteDesktopcsv\RDPConnectionInitiated.csv -NoTypeInformation
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
#. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\RemoteDesktopcsv\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PSFunctions\MapNetworkShares\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\ComputerToValidate.ps1
Get-ComputerToValidate -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\ComputerToValidate.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\KerberosAuthRequest.ps1
Get-KerberosAuthRequest -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\KerberosAuthRequest.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\KerberosServiceRequest.ps1
Get-KerberosServiceRequest -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\KerberosServiceRequest.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\NetworkShareAccessed.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\AuditingofSharedfiles.ps1
Get-AuditingofSharedfiles -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\AuditingofSharedfiles.csv -NoTypeInformation
# Remote Access 
	#Map Network Shares
		# source
#. .\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\MapNetworkSharescsv\ExplicitCreds.csv -NoTypeInformation

#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination
#. .\PSFunctions\PsExec\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\AllSuccessfulLogons.csv -NoTypeInformation 

#. .\PSFunctions\PsExec\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\AdminLogonCreated.csv -NoTypeInformation

#. .\PSFunctions\PsExec\NetworkShareAccessed.ps1
#Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\NetworkShareAccessed.csv -NoTypeInformation

. .\PSFunctions\PsExec\ServiceInstall.ps1
Get-ServiceInstall -Path $System_Path  | Export-Csv -Path Results\PsExeccsv\ServiceInstall.csv -NoTypeInformation
#Remote Execution
	#PsExec
		#source
#. .\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PsExeccsv\ExplicitCreds.csv -NoTypeInformation

############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination
#. .\PSFunctions\ScheduledTasks\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\AllSuccessfulLogons.csv -NoTypeInformation 

#. .\PSFunctions\ScheduledTasks\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\ScheduledTaskscsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskCreated.ps1
Get-ScheduleTaskCreated -Path $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskCreated.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskDeleted.ps1
Get-ScheduleTaskDeleted -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskDeleted.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskEnabled.ps1
Get-ScheduleTaskEnabled -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskEnabled.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskDisabled.ps1
Get-ScheduleTaskDisabled -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskDisabled.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskUpdated.ps1
Get-ScheduleTaskUpdated -Path  $Security_Path | Export-Csv -Path Results\ScheduledTaskscsv\ScheduleTaskUpdated.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\CreatingTaskSchedulerTask .ps1
Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\CreatingTaskSchedulerTask.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\UpdatingTaskSchedulerTask.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\DeletingTaskSchedulerTask .ps1
Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\DeletingTaskSchedulerTask.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\ExecutingTaskSchedulerTask.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\CompletingTaskSchedulerTask.ps1
Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path Results\ScheduledTaskscsv\CompletingTaskSchedulerTask.csv -NoTypeInformation
#Remote Execution
	#Scheduled Tasks
		#source
#. .\ScheduledTasks\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\ScheduledTaskscsv\ExplicitCreds.csv -NoTypeInformation

#####################################################################################################################################
#Remote Execution
	#services
		#destination
#. .\PSFunctions\Services\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\Servicescsv\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PSFunctions\Services\ServiceInstalledonSystem.ps1
Get-ServiceInstalledonSystem -Path $Security_Path  | Export-Csv -Path Results\Servicescsv\ServiceInstalledonSystem.csv -NoTypeInformation

. .\PSFunctions\Services\ServiceCrashed.ps1
Get-ServiceCrashed -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceCrashed.csv -NoTypeInformation

. .\PSFunctions\Services\ServiceSentControl.ps1
Get-ServiceSentControl -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceSentControl.csv -NoTypeInformation

. .\PSFunctions\Services\ServiceStartorStop.ps1
Get-ServiceStartorStop -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceStartorStop.csv -NoTypeInformation

. .\PSFunctions\Services\StartTypeChanged.ps1
Get-StartTypeChanged -Path $System_Path  | Export-Csv -Path Results\Servicescsv\StartTypeChanged.csv -NoTypeInformation

#. .\PSFunctions\Services\ServiceInstall.ps1
#Get-ServiceInstall -Path $System_Path  | Export-Csv -Path Results\Servicescsv\ServiceInstall.csv -NoTypeInformation

####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
#. .\PSFunctions\WMI_WMIC\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Results\WMI_WMICcsv\AllSuccessfulLogons.csv -NoTypeInformation 

#. .\PSFunctions\WMI_WMIC\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\WMI_WMICcsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\WMI_WMIC\SystemQueryWMI.ps1
Get-SystemQueryWMI -Path $WinRM_Path  | Export-Csv -Path Results\WMI_WMICcsv\SystemQueryWMI.csv -NoTypeInformation

. .\PSFunctions\WMI_WMIC\TemporaryEventConsumer.ps1
Get-TemporaryEventConsumer -Path $WinRM_Path | Export-Csv -Path Results\WMI_WMICcsv\TemporaryEventConsumer.csv -NoTypeInformation

. .\PSFunctions\WMI_WMIC\PermenantEventConsumer.ps1
Get-PermenantEventConsumer -Path $WinRM_Path   | Export-Csv -Path Results\WMI_WMICcsv\PermenantEventConsumer.csv -NoTypeInformation

#Remote Execution
	#WMI\WMIC
		#source
#. .\WMI\WMIC\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\WMI_WMICcsv\ExplicitCreds.csv -NoTypeInformation
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination

#. .\PSFunctions\PowerShellRemoting\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path Results\PowerShellRemotingcsv\AllSuccessfulLogons.csv -NoTypeInformation 

#. .\PSFunctions\PowerShellRemoting\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\ScriptBlockLogging.ps1
Get-ScriptBlockLogging -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\ScriptBlockLogging.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\ScriptBlockAuditing.ps1
Get-ScriptBlockAuditing -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\ScriptBlockAuditing.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\LateralMovementDetection.ps1
LateralMovementDetection -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\LateralMovementDetection.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\StartPSRemoteSession.ps1
Get-StartPSRemoteSession -Path $WinPowerShell_Path  | Export-Csv -Path Results\PowerShellRemotingcsv\StartPSRemoteSession.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\EndPSRemoteSession.ps1
Get-EndPSRemoteSession -Path $WinPowerShell_Path | Export-Csv -Path Results\PowerShellRemotingcsv\EndPSRemoteSession.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\PipelineExecution.ps1
Get-PipelineExecution -Path $WinPowerShell_Path| Export-Csv -Path Results\PowerShellRemotingcsv\PipelineExecution.csv -NoTypeInformation

#Remote Execution
	#powershell remoting
		#source
#. .\PSFunctions\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation

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
