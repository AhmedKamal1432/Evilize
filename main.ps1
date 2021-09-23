mkdir RemoteDesktopcsv
mkdir MapNetworkSharescsv
mkdir PsExeccsv
mkdir ScheduledTaskscsv
mkdir WMI_WMICcsv
mkdir Servicescsv
mkdir PowerShellRemotingcsv
$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path"  

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
# Remote Access
	#Remote desktop
		#destination#
. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path RemoteDesktopcsv\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PSFunctions\RemoteDesktop\RDPreconnected.ps1
Get-RDPreconnected -Path $Security_Path  | Export-Csv -Path RemoteDesktopcsv\RDPreconnected.csv -NoTypeInformation 

. .\PSFunctions\RemoteDesktop\RDPDisconnected.ps1
Get-RDPDisconnected -Path $Security_Path  | Export-Csv -Path RemoteDesktopcsv\RDPDisconnected.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPConnectionAttempts.ps1
Get-RDPConnectionAttempts -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktopcsv\RDPConnectionAttempts.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPSuccessfulConnections.ps1
Get-RDPSuccessfulConnections -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktopcsv\RDPSuccessfulConnections.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\UserAuthSucceeded.ps1
Get-UserAuthSucceeded -Path $RemoteConnection_Path | Export-Csv -Path RemoteDesktopcsv\UserAuthSucceeded.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPSessionLogonSucceed.ps1
Get-RDPSessionLogonSucceed -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktopcsv\RDPSessionLogonSucceed.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPShellStartNotificationReceived.ps1
Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktopcsv\RDPShellStartNotificationReceived.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktopcsv\RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation

. .\PSFunctions\RemoteDesktop\RDPbeginSession.ps1
Get-RDPbeginSession -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktopcsv\RDPbeginSession.csv -NoTypeInformation

# Remote Access
	#Remote desktop
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path RemoteDesktop\ExplicitCreds.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectingtoServer.ps1
#Get-RDPConnectingtoServer -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktop\RDPConnectingtoServer.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectionInitiated.ps1
#Get-RDPConnectionInitiated  -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktop\RDPConnectionInitiated.csv -NoTypeInformation
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
#. .\PSFunctions\MapNetworkShares\NetworkLogons.ps1
#Get-NetworkLogons -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\NetworkLogons.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\ComputerToValidate.ps1
Get-ComputerToValidate -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\ComputerToValidate.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\KerberosAuthRequest.ps1
Get-KerberosAuthRequest -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\KerberosAuthRequest.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\KerberosServiceRequest.ps1
Get-KerberosServiceRequest -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\KerberosServiceRequest.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\NetworkShareAccessed.csv -NoTypeInformation

. .\PSFunctions\MapNetworkShares\AuditingofSharedfiles.ps1
Get-AuditingofSharedfiles -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\AuditingofSharedfiles.csv -NoTypeInformation
# Remote Access 
	#Map Network Shares
		# source
#. .\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path MapNetworkSharescsv\ExplicitCreds.csv -NoTypeInformation

#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination
#. .\PSFunctions\PsExec\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path PsExeccsv\AllSuccessfulLogons.csv -NoTypeInformation 

#. .\PSFunctions\PsExec\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path PsExeccsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\PsExec\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path PsExeccsv\NetworkShareAccessed.csv -NoTypeInformation

. .\PSFunctions\PsExec\ServiceInstall.ps1
Get-ServiceInstall -Path $System_Path  | Export-Csv -Path PsExeccsv\ServiceInstall.csv -NoTypeInformation
#Remote Execution
	#PsExec
		#source
#. .\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path PsExeccsv\ExplicitCreds.csv -NoTypeInformation

############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination
#. .\PSFunctions\ScheduledTasks\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path ScheduledTaskscsv\AllSuccessfulLogons.csv -NoTypeInformation 

#. .\PSFunctions\ScheduledTasks\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path ScheduledTaskscsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskCreated.ps1
Get-ScheduleTaskCreated -Path $Security_Path | Export-Csv -Path ScheduledTaskscsv\ScheduleTaskCreated.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskDeleted.ps1
Get-ScheduleTaskDeleted -Path  $Security_Path | Export-Csv -Path ScheduledTaskscsv\ScheduleTaskDeleted.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskEnabled.ps1
Get-ScheduleTaskEnabled -Path  $Security_Path | Export-Csv -Path ScheduledTaskscsv\ScheduleTaskEnabled.csv -NoTypeInformation

. .\ScheduledTasks\ScheduleTaskDisabled.ps1
Get-ScheduleTaskDisabled -Path  $Security_Path | Export-Csv -Path ScheduledTaskscsv\ScheduleTaskDisabled.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ScheduleTaskUpdated.ps1
Get-ScheduleTaskUpdated -Path  $Security_Path | Export-Csv -Path ScheduledTaskscsv\ScheduleTaskUpdated.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\CreatingTaskSchedulerTask .ps1
Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTaskscsv\CreatingTaskSchedulerTask .csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTaskscsv\UpdatingTaskSchedulerTask.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\DeletingTaskSchedulerTask .ps1
Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTaskscsv\DeletingTaskSchedulerTask .csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTaskscsv\ExecutingTaskSchedulerTask.csv -NoTypeInformation

. .\PSFunctions\ScheduledTasks\CompletingTaskSchedulerTask.ps1
Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTaskscsv\CompletingTaskSchedulerTask.csv -NoTypeInformation
#Remote Execution
	#Scheduled Tasks
		#source
#. .\ScheduledTasks\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path ScheduledTaskscsv\ExplicitCreds.csv -NoTypeInformation

#####################################################################################################################################
#Remote Execution
	#services
		#destination
#. .\PSFunctions\Services\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Servicescsv\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PSFunctions\Services\ServiceInstalledonSystem.ps1
Get-ServiceInstalledonSystem -Path $Security_Path  | Export-Csv -Path Servicescsv\ServiceInstalledonSystem.csv -NoTypeInformation

. .\PSFunctions\Services\ServiceCrashed.ps1
Get-ServiceCrashed-Path $System_Path  | Export-Csv -Path Servicescsv\ServiceCrashed.csv -NoTypeInformation

. .\PSFunctions\Services\ServiceSentControl.ps1
Get-ServiceSentControl -Path $System_Path  | Export-Csv -Path Servicescsv\ServiceSentControl.csv -NoTypeInformation

. .\PSFunctions\Services\ServiceStartorStop.ps1
Get-ServiceStartorStop-Path $System_Path  | Export-Csv -Path Servicescsv\ServiceStartorStop.csv -NoTypeInformation

. .\PSFunctions\Services\StartTypeChanged.ps1
Get-StartTypeChanged -Path $System_Path  | Export-Csv -Path Servicescsv\StartTypeChanged.csv -NoTypeInformation

#. .\PSFunctions\Services\ServiceInstall.ps1
#Get-ServiceInstall -Path $System_Path  | Export-Csv -Path Servicescsv\ServiceInstall.csv -NoTypeInformation

####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
#. .\PSFunctions\WMI_WMIC\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path WMI_WMICcsv\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PSFunctions\WMI_WMICAdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path WMI_WMICcsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\WMI_WMIC\SystemQueryWMI.ps1
Get-SystemQueryWMI -Path $WinRM_Path  | Export-Csv -Path WMI_WMICcsv\SystemQueryWMI.csv -NoTypeInformation

. .\PSFunctions\WMI_WMIC\TemporaryEventConsumer.ps1
Get-TemporaryEventConsumer -Path $WinRM_Path | Export-Csv -Path WMI_WMICcsv\TemporaryEventConsumer.csv -NoTypeInformation

. .\PSFunctions\WMI_WMIC\PermenantEventConsumer.ps1
Get-PermenantEventConsumer -Path $WinRM_Path   | Export-Csv -Path WMI_WMICcsv\PermenantEventConsumer.csv -NoTypeInformation

#Remote Execution
	#WMI\WMIC
		#source
#. .\WMI\WMIC\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path WMI_WMICcsv\ExplicitCreds.csv -NoTypeInformation
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination

#. .\PSFunctions\PowerShellRemoting\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path PowerShellRemotingcsv\AllSuccessfulLogons.csv -NoTypeInformation 

#. .\PSFunctions\PowerShellRemoting\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path PowerShellRemotingcsv\AdminLogonCreated.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\ScriptBlockLogging.ps1
Get-ScriptBlockLogging -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemotingcsv\ScriptBlockLogging.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\ScriptBlockAuditing.ps1
Get-ScriptBlockAuditing -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemotingcsv\ScriptBlockAuditing.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\LateralMovementDetection.ps1
LateralMovementDetection -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemotingcsv\LateralMovementDetection.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\StartPSRemoteSession.ps1
Get-StartPSRemoteSession -Path $WinPowerShell_Path  | Export-Csv -Path PowerShellRemotingcsv\StartPSRemoteSession.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\EndPSRemoteSession.ps1
Get-EndPSRemoteSession -Path $WinPowerShell_Path | Export-Csv -Path PowerShellRemotingcsv\EndPSRemoteSession.csv -NoTypeInformation

. .\PSFunctions\PowerShellRemoting\PipelineExecution.ps1
Get-PipelineExecution -Path $WinPowerShell_Path| Export-Csv -Path PowerShellRemotingcsv\PipelineExecution.csv -NoTypeInformation

#Remote Execution
	#powershell remoting
		#source
#. .\PSFunctions\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManSession.ps1
#Get-ClosingWSManSession -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManSession.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManCommand .ps1
#Get-ClosingWSManCommand  -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManCommand .csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManShell.ps1
#Get-ClosingWSManShell -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManShell.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
#Get-ClosingWSManSessionSucceeded -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManSessionSucceeded.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\CreatingRunspaceObject.ps1
#Get-CreatingRunspaceObject -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\CreatingRunspaceObject.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\CreatingRunspacePoolObject.ps1
#Get-CreatingRunspacePoolObject -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\CreatingRunspacePoolObject.csv -NoTypeInformation

#. .\PSFunctions\PowerShellRemoting\RunspaceState.ps1
#Get-RunspaceState -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\RunspaceState.csv -NoTypeInformation
