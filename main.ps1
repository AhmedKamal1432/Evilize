mkdir RemoteDesktop
mkdir MapNetworkShares
mkdir PsExec
mkdir ScheduledTasks
mkdir WMI_WMIC
mkdir Services
mkdir PowerShellRemoting
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
. .\RemoteDesktop\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path RemoteDesktop\AllSuccessfulLogons.csv -NoTypeInformation 

. .\RemoteDesktop\RDPreconnected.ps1
Get-RDPreconnected -Path $Security_Path  | Export-Csv -Path RemoteDesktop\RDPreconnected.csv -NoTypeInformation 

. .\RemoteDesktop\RDPDisconnected.ps1
Get-RDPDisconnected -Path $Security_Path  | Export-Csv -Path RemoteDesktop\RDPDisconnected.csv -NoTypeInformation

. .\RemoteDesktop\RDPConnectionAttempts.ps1
Get-RDPConnectionAttempts -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktop\RDPConnectionAttempts.csv -NoTypeInformation

. .\RemoteDesktop\RDPSuccessfulConnections.ps1
Get-RDPSuccessfulConnections -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktop\RDPSuccessfulConnections.csv -NoTypeInformation

. .\RemoteDesktop\UserAuthSucceeded.ps1
Get-UserAuthSucceeded -Path $RemoteConnection_Path | Export-Csv -Path RemoteDesktop\UserAuthSucceeded.csv -NoTypeInformation

. .\RemoteDesktop\RDPSessionLogonSucceed.ps1
Get-RDPSessionLogonSucceed -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktop\RDPSessionLogonSucceed.csv -NoTypeInformation

. .\RemoteDesktop\RDPShellStartNotificationReceived.ps1
Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktop\RDPShellStartNotificationReceived.csv -NoTypeInformation

. .\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktop\RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation

. .\RDPbeginSession.ps1
Get-RDPbeginSession -Path $TerminalServices_Path  | Export-Csv -Path RemoteDesktop\RDPbeginSession.csv -NoTypeInformation

# Remote Access
	#Remote desktop
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path RemoteDesktop\ExplicitCreds.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPConnectingtoServer.ps1
#Get-RDPConnectingtoServer -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktop\RDPConnectingtoServer.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopRDPConnectionInitiated.ps1
#Get-RDPConnectionInitiated  -Path $RDPCORETS_Path  | Export-Csv -Path RemoteDesktop\RDPConnectionInitiated.csv -NoTypeInformation
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
. .\MapNetworkShares\NetworkLogons.ps1
Get-NetworkLogons -Path $Security_Path  | Export-Csv -Path MapNetworkShares\NetworkLogons.csv -NoTypeInformation

. .\MapNetworkShares\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path MapNetworkShares\AdminLogonCreated.csv -NoTypeInformation

. .\MapNetworkShares\ComputerToValidate.ps1
Get-ComputerToValidate -Path $Security_Path  | Export-Csv -Path MapNetworkShares\ComputerToValidate.csv -NoTypeInformation

. .\MapNetworkShares\KerberosAuthRequest.ps1
Get-KerberosAuthRequest -Path $Security_Path  | Export-Csv -Path MapNetworkShares\KerberosAuthRequest.csv -NoTypeInformation

. .\MapNetworkShares\KerberosServiceRequest.ps1
Get-KerberosServiceRequest -Path $Security_Path  | Export-Csv -Path MapNetworkShares\KerberosServiceRequest.csv -NoTypeInformation

. .\MapNetworkShares\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path MapNetworkShares\NetworkShareAccessed.csv -NoTypeInformation

. .\MapNetworkShares\AuditingofSharedfiles.ps1
Get-AuditingofSharedfiles -Path $Security_Path  | Export-Csv -Path MapNetworkShares\AuditingofSharedfiles.csv -NoTypeInformation
# Remote Access 
	#Map Network Shares
		# source
#. .\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path MapNetworkShares\ExplicitCreds.csv -NoTypeInformation

#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination
. .\PsExec\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path PsExec\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PsExec\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path PsExec\AdminLogonCreated.csv -NoTypeInformation

. .\PsExec\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path PsExec\NetworkShareAccessed.csv -NoTypeInformation

. .\PsExec\ServiceInstall.ps1
Get-ServiceInstall -Path $System_Path  | Export-Csv -Path PsExec\ServiceInstall.csv -NoTypeInformation
#Remote Execution
	#PsExec
		#source
#. .\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path PsExec\ExplicitCreds.csv -NoTypeInformation

############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination
. .\ScheduledTasks\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path ScheduledTasks\AllSuccessfulLogons.csv -NoTypeInformation 

. .\ScheduledTasks\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path ScheduledTasks\AdminLogonCreated.csv -NoTypeInformation

. .\ScheduledTasks\ScheduleTaskCreated.ps1
Get-ScheduleTaskCreated -Path $Security_Path | Export-Csv -Path ScheduledTasks\ScheduleTaskCreated.csv -NoTypeInformation

. .\ScheduledTasks\ScheduleTaskDeleted.ps1
Get-ScheduleTaskDeleted -Path  $Security_Path | Export-Csv -Path ScheduledTasks\ScheduleTaskDeleted.csv -NoTypeInformation

. .\ScheduledTasks\ScheduleTaskEnabled.ps1
Get-ScheduleTaskEnabled -Path  $Security_Path | Export-Csv -Path ScheduledTasks\ScheduleTaskEnabled.csv -NoTypeInformation

. .\ScheduledTasks\ScheduleTaskDisabled.ps1
Get-ScheduleTaskDisabled -Path  $Security_Path | Export-Csv -Path ScheduledTasks\ScheduleTaskDisabled.csv -NoTypeInformation

. .\ScheduledTasks\ScheduleTaskUpdated.ps1
Get-ScheduleTaskUpdated -Path  $Security_Path | Export-Csv -Path ScheduledTasks\ScheduleTaskUpdated.csv -NoTypeInformation

. .\ScheduledTasks\CreatingTaskSchedulerTask .ps1
Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTasks\CreatingTaskSchedulerTask .csv -NoTypeInformation

. .\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTasks\UpdatingTaskSchedulerTask.csv -NoTypeInformation

. .\ScheduledTasks\DeletingTaskSchedulerTask .ps1
Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTasks\DeletingTaskSchedulerTask .csv -NoTypeInformation

. .\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTasks\ExecutingTaskSchedulerTask.csv -NoTypeInformation

. .\ScheduledTasks\CompletingTaskSchedulerTask.ps1
Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path ScheduledTasks\CompletingTaskSchedulerTask.csv -NoTypeInformation
#Remote Execution
	#Scheduled Tasks
		#source
#. .\ScheduledTasks\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path ScheduledTasks\ExplicitCreds.csv -NoTypeInformation

#####################################################################################################################################
#Remote Execution
	#services
		#destination
. .\Services\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path Services\AllSuccessfulLogons.csv -NoTypeInformation 

. .\Services\ServiceInstalledonSystem.ps1
Get-ServiceInstalledonSystem -Path $Security_Path  | Export-Csv -Path Services\ServiceInstalledonSystem.csv -NoTypeInformation

. .\Services\ServiceCrashed.ps1
Get-ServiceCrashed-Path $System_Path  | Export-Csv -Path Services\ServiceCrashed.csv -NoTypeInformation

. .\Services\ServiceSentControl.ps1
Get-ServiceSentControl -Path $System_Path  | Export-Csv -Path Services\ServiceSentControl.csv -NoTypeInformation

. .\Services\ServiceStartorStop.ps1
Get-ServiceStartorStop-Path $System_Path  | Export-Csv -Path Services\ServiceStartorStop.csv -NoTypeInformation

. .\Services\StartTypeChanged.ps1
Get-StartTypeChanged -Path $System_Path  | Export-Csv -Path Services\StartTypeChanged.csv -NoTypeInformation

. .\Services\ServiceInstall.ps1
Get-ServiceInstall -Path $System_Path  | Export-Csv -Path Services\ServiceInstall.csv -NoTypeInformation

####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
. .\WMI_WMIC\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path WMI_WMIC\AllSuccessfulLogons.csv -NoTypeInformation 

. .\WMI_WMICAdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path WMI_WMIC\AdminLogonCreated.csv -NoTypeInformation

. .\WMI_WMIC\SystemQueryWMI.ps1
Get-SystemQueryWMI -Path $WinRM_Path  | Export-Csv -Path WMI_WMIC\SystemQueryWMI.csv -NoTypeInformation

. .\WMI_WMIC\TemporaryEventConsumer.ps1
Get-TemporaryEventConsumer -Path $WinRM_Path | Export-Csv -Path WMI_WMIC\TemporaryEventConsumer.csv -NoTypeInformation

. .\WMI_WMIC\PermenantEventConsumer.ps1
Get-PermenantEventConsumer -Path $WinRM_Path   | Export-Csv -Path WMI_WMIC\PermenantEventConsumer.csv -NoTypeInformation

#Remote Execution
	#WMI\WMIC
		#source
#. .\WMI\WMIC\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path WMI_WMIC\ExplicitCreds.csv -NoTypeInformation
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination

. .\PowerShellRemoting\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path PowerShellRemoting\AllSuccessfulLogons.csv -NoTypeInformation 

. .\PowerShellRemoting\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path PowerShellRemoting\AdminLogonCreated.csv -NoTypeInformation

. .\PowerShellRemoting\ScriptBlockLogging.ps1
Get-ScriptBlockLogging -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\ScriptBlockLogging.csv -NoTypeInformation

. .\PowerShellRemoting\ScriptBlockAuditing.ps1
Get-ScriptBlockAuditing -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\ScriptBlockAuditing.csv -NoTypeInformation

. .\PowerShellRemoting\LateralMovementDetection.ps1
LateralMovementDetection -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\LateralMovementDetection.csv -NoTypeInformation

. .\PowerShellRemoting\StartPSRemoteSession.ps1
Get-StartPSRemoteSession -Path $WinPowerShell_Path  | Export-Csv -Path PowerShellRemoting\StartPSRemoteSession.csv -NoTypeInformation

. .\PowerShellRemoting\EndPSRemoteSession.ps1
Get-EndPSRemoteSession -Path $WinPowerShell_Path | Export-Csv -Path PowerShellRemoting\EndPSRemoteSession.csv -NoTypeInformation

. .\PowerShellRemoting\PipelineExecution.ps1
Get-PipelineExecution -Path $WinPowerShell_Path| Export-Csv -Path PowerShellRemoting\PipelineExecution.csv -NoTypeInformation

#Remote Execution
	#powershell remoting
		#source
#. .\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation

#. .\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PowerShellRemoting\ClosingWSManSession.ps1
#Get-ClosingWSManSession -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManSession.csv -NoTypeInformation

#. .\PowerShellRemoting\ClosingWSManCommand .ps1
#Get-ClosingWSManCommand  -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManCommand .csv -NoTypeInformation

#. .\PowerShellRemoting\ClosingWSManShell.ps1
#Get-ClosingWSManShell -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManShell.csv -NoTypeInformation

#. .\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
#Get-ClosingWSManSessionSucceeded -Path $WinRM_Path  | Export-Csv -Path PowerShellRemoting\ClosingWSManSessionSucceeded.csv -NoTypeInformation

#. .\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\RDPreconnected.csv -NoTypeInformation

#. .\PowerShellRemoting\CreatingRunspaceObject.ps1
#Get-CreatingRunspaceObject -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\CreatingRunspaceObject.csv -NoTypeInformation

#. .\PowerShellRemoting\CreatingRunspacePoolObject.ps1
#Get-CreatingRunspacePoolObject -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\CreatingRunspacePoolObject.csv -NoTypeInformation

#. .\PowerShellRemoting\RunspaceState.ps1
#Get-RunspaceState -Path $PowerShellOperational_Path  | Export-Csv -Path PowerShellRemoting\RunspaceState.csv -NoTypeInformation
