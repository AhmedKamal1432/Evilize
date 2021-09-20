# Remote Access
	#Remote desktop
		#destination#
. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path 'logs\Security.evtx'  | Export-Csv -Path AllSuccessfulLogons.csv -NoTypeInformation 

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPreconnected.ps1
Get-RDPreconnected -Path 'logs\Security.evtx'  | Export-Csv -Path RDPreconnected.csv -NoTypeInformation 

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPDisconnected.ps1
Get-RDPDisconnected -Path 'logs\Security.evtx'  | Export-Csv -Path RDPDisconnected.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPConnectionAttempts.ps1
Get-RDPConnectionAttempts -Path 'logs\Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx'  | Export-Csv -Path RDPConnectionAttempts.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPSuccessfulConnections.ps1
Get-RDPSuccessfulConnections -Path 'logs\Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx'  | Export-Csv -Path RDPSuccessfulConnections.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\UserAuthSucceeded.ps1
Get-UserAuthSucceeded -Path 'logs\Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational'  | Export-Csv -Path UserAuthSucceeded.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPSessionLogonSucceed.ps1
Get-RDPSessionLogonSucceed -Path 'logs\Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx'  | Export-Csv -Path RDPSessionLogonSucceed.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPShellStartNotificationReceived.ps1
Get-RDPShellStartNotificationReceived -Path 'logs\Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx'  | Export-Csv -Path RDPShellStartNotificationReceived.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
Get-RDPShellSessionReconnectedSucceeded -Path 'logs\Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx'  | Export-Csv -Path RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPbeginSession.ps1
Get-RDPbeginSession -Path 'logs\Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx'  | Export-Csv -Path RDPbeginSession.csv -NoTypeInformation

# Remote Access
	#Remote desktop
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\ExplicitCreds.ps1
#Get-ExplicitCreds -Path 'logs\Security.evtx'  | Export-Csv -Path ExplicitCreds.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktop\RDPConnectingtoServer.ps1
#Get-RDPConnectingtoServer -Path 'logs\Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx'  | Export-Csv -Path RDPConnectingtoServer.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopRDPConnectionInitiated.ps1
#Get-RDPConnectionInitiated  -Path 'logs\Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx'  | Export-Csv -Path RDPConnectionInitiated.csv -NoTypeInformation
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\NetworkLogons.ps1
Get-NetworkLogons -Path 'logs\Security.evtx'  | Export-Csv -Path NetworkLogons.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path 'logs\Security.evtx'  | Export-Csv -Path AdminLogonCreated.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\ComputerToValidate.ps1
Get-ComputerToValidate -Path 'logs\Security.evtx'  | Export-Csv -Path ComputerToValidate.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\KerberosAuthRequest.ps1
Get-KerberosAuthRequest -Path 'logs\Security.evtx'  | Export-Csv -Path KerberosAuthRequest.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\KerberosServiceRequest.ps1
Get-KerberosServiceRequest -Path 'logs\Security.evtx'  | Export-Csv -Path KerberosServiceRequest.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path 'logs\Security.evtx'  | Export-Csv -Path NetworkShareAccessed.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\AuditingofSharedfiles.ps1
Get-AuditingofSharedfiles -Path 'logs\Security.evtx'  | Export-Csv -Path AuditingofSharedfiles.csv -NoTypeInformation
# Remote Access 
	#Map Network Shares
		# source
#. D:\EJUST\Internships\TMinternship\evilize_project\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path 'logs\Security.evtx'  | Export-Csv -Path ExplicitCreds.csv -NoTypeInformation

#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination
. D:\EJUST\Internships\TMinternship\evilize_project\PsExec\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path 'logs\Security.evtx'  | Export-Csv -Path AllSuccessfulLogons.csv -NoTypeInformation 

. D:\EJUST\Internships\TMinternship\evilize_project\PsExec\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path 'logs\Security.evtx'  | Export-Csv -Path AdminLogonCreated.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PsExec\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path 'logs\Security.evtx'  | Export-Csv -Path NetworkShareAccessed.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PsExec\ServiceInstall.ps1
Get-ServiceInstall -Path 'logs\System.evtx'  | Export-Csv -Path ServiceInstall.csv -NoTypeInformation
#Remote Execution
	#PsExec
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path 'logs\Security.evtx'  | Export-Csv -Path ExplicitCreds.csv -NoTypeInformation

############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination
. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path 'logs\Security.evtx'  | Export-Csv -Path AllSuccessfulLogons.csv -NoTypeInformation 

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path 'logs\Security.evtx'  | Export-Csv -Path AdminLogonCreated.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\ScheduleTaskCreated.ps1
Get-ScheduleTaskCreated -Path 'logs\temp_scheduled_task_4698_4699.evtx' | Export-Csv -Path ScheduleTaskCreated.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\ScheduleTaskDeleted.ps1
Get-ScheduleTaskDeleted -Path  'logs\temp_scheduled_task_4698_4699.evtx' | Export-Csv -Path ScheduleTaskDeleted.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\ScheduleTaskEnabled.ps1
Get-ScheduleTaskEnabled -Path  'logs\security.evtx' | Export-Csv -Path ScheduleTaskEnabled.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\ScheduleTaskDisabled.ps1
Get-ScheduleTaskDisabled -Path  'logs\security.evtx' | Export-Csv -Path ScheduleTaskDisabled.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\ScheduleTaskUpdated.ps1
Get-ScheduleTaskUpdated -Path  'logs\security.evtx' | Export-Csv -Path ScheduleTaskUpdated.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\CreatingTaskSchedulerTask .ps1
Get-CreatingTaskSchedulerTask  -Path  'logs\Microsoft-Windows-TaskScheduler%4Maintenance.evtx' | Export-Csv -Path CreatingTaskSchedulerTask .csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
Get-UpdatingTaskSchedulerTask -Path  'logs\Microsoft-Windows-TaskScheduler%4Maintenance.evtx' | Export-Csv -Path UpdatingTaskSchedulerTask.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\DeletingTaskSchedulerTask .ps1
Get-DeletingTaskSchedulerTask  -Path  'logs\Microsoft-Windows-TaskScheduler%4Maintenance.evtx' | Export-Csv -Path DeletingTaskSchedulerTask .csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
Get-ExecutingTaskSchedulerTask -Path  'logs\Microsoft-Windows-TaskScheduler%4Maintenance.evtx' | Export-Csv -Path ExecutingTaskSchedulerTask.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\CompletingTaskSchedulerTask.ps1
Get-CompletingTaskSchedulerTask -Path  'logs\Microsoft-Windows-TaskScheduler%4Maintenance.evtx' | Export-Csv -Path CompletingTaskSchedulerTask.csv -NoTypeInformation
#Remote Execution
	#Scheduled Tasks
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\ScheduledTasks\ExplicitCreds.ps1
#Get-ExplicitCreds -Path 'logs\Security.evtx'  | Export-Csv -Path ExplicitCreds.csv -NoTypeInformation

#####################################################################################################################################
#Remote Execution
	#services
		#destination
. D:\EJUST\Internships\TMinternship\evilize_project\Services\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path 'logs\Security.evtx'  | Export-Csv -Path AllSuccessfulLogons.csv -NoTypeInformation 

. D:\EJUST\Internships\TMinternship\evilize_project\Services\ServiceInstalledonSystem.ps1
Get-ServiceInstalledonSystem -Path 'logs\Security.evtx'  | Export-Csv -Path ServiceInstalledonSystem.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\Services\ServiceCrashed.ps1
Get-ServiceCrashed-Path 'logs\System.evtx'  | Export-Csv -Path ServiceCrashed.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\Services\ServiceSentControl.ps1
Get-ServiceSentControl -Path 'logs\System.evtx'  | Export-Csv -Path ServiceSentControl.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\Services\ServiceStartorStop.ps1
Get-ServiceStartorStop-Path 'logs\System.evtx'  | Export-Csv -Path ServiceStartorStop.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\Services\StartTypeChanged.ps1
Get-StartTypeChanged -Path 'logs\System.evtx'  | Export-Csv -Path StartTypeChanged.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\Services\ServiceInstall.ps1
Get-ServiceInstall -Path 'logs\System.evtx'  | Export-Csv -Path ServiceInstall.csv -NoTypeInformation

####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
. D:\EJUST\Internships\TMinternship\evilize_project\WMI\WMIC\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path 'logs\Security.evtx'  | Export-Csv -Path AllSuccessfulLogons.csv -NoTypeInformation 

. D:\EJUST\Internships\TMinternship\evilize_project\WMI\WMICAdminLogonCreated.ps1
Get-AdminLogonCreated -Path 'logs\Security.evtx'  | Export-Csv -Path AdminLogonCreated.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\WMI\WMIC\SystemQueryWMI.ps1
Get-SystemQueryWMI -Path 'logs\Microsoft-Windows-WMI-Activity%4Operational.evtx'  | Export-Csv -Path SystemQueryWMI.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\WMI\WMIC\TemporaryEventConsumer.ps1
Get-TemporaryEventConsumer -Path 'logs\Microsoft-Windows-WMI-Activity%4Operational.evtx' | Export-Csv -Path TemporaryEventConsumer.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\WMI\WMIC\PermenantEventConsumer.ps1
Get-PermenantEventConsumer -Path 'logs\Microsoft-Windows-WMI-Activity%4Operational.evtx'   | Export-Csv -Path PermenantEventConsumer.csv -NoTypeInformation

#Remote Execution
	#WMI\WMIC
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\WMI\WMIC\ExplicitCreds.ps1
#Get-ExplicitCreds -Path 'logs\Security.evtx'  | Export-Csv -Path ExplicitCreds.csv -NoTypeInformation
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path 'logs\Security.evtx'  | Export-Csv -Path AllSuccessfulLogons.csv -NoTypeInformation 

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path 'logs\Security.evtx'  | Export-Csv -Path AdminLogonCreated.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\ScriptBlockLogging.ps1
Get-ScriptBlockLogging -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path ScriptBlockLogging.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\ScriptBlockAuditing.ps1
Get-ScriptBlockAuditing -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path ScriptBlockAuditing.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\LateralMovementDetection.ps1
LateralMovementDetection -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path LateralMovementDetection.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\StartPSRemoteSession.ps1
Get-StartPSRemoteSession -Path 'logs\Windows PowerShell.evtx'  | Export-Csv -Path StartPSRemoteSession.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\EndPSRemoteSession.ps1
Get-EndPSRemoteSession -Path 'logs\Windows PowerShell.evtx' | Export-Csv -Path EndPSRemoteSession.csv -NoTypeInformation

. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\PipelineExecution.ps1
Get-PipelineExecution -Path 'logs\Windows PowerShell.evtx'| Export-Csv -Path PipelineExecution.csv -NoTypeInformation

#Remote Execution
	#powershell remoting
		#source
#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path 'logs\Security.evtx'  | Export-Csv -Path ExplicitCreds.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path 'logs\Microsoft-Windows-WinRM%4Operational.evtx'  | Export-Csv -Path RDPreconnected.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\ClosingWSManSession.ps1
#Get-ClosingWSManSession -Path 'logs\Microsoft-Windows-WinRM%4Operational.evtx'  | Export-Csv -Path ClosingWSManSession.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\ClosingWSManCommand .ps1
#Get-ClosingWSManCommand  -Path 'logs\Microsoft-Windows-WinRM%4Operational.evtx'  | Export-Csv -Path ClosingWSManCommand .csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\ClosingWSManShell.ps1
#Get-ClosingWSManShell -Path 'logs\Microsoft-Windows-WinRM%4Operational.evtx'  | Export-Csv -Path ClosingWSManShell.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
#Get-ClosingWSManSessionSucceeded -Path 'logs\Microsoft-Windows-WinRM%4Operational.evtx'  | Export-Csv -Path ClosingWSManSessionSucceeded.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path RDPreconnected.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path RDPreconnected.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\CreatingRunspaceObject.ps1
#Get-CreatingRunspaceObject -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path CreatingRunspaceObject.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\CreatingRunspacePoolObject.ps1
#Get-CreatingRunspacePoolObject -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path CreatingRunspacePoolObject.csv -NoTypeInformation

#. D:\EJUST\Internships\TMinternship\evilize_project\PowerShellRemoting\RunspaceState.ps1
#Get-RunspaceState -Path 'logs\Microsoft-Windows-PowerShell%4Operational.evtx'  | Export-Csv -Path RunspaceState.csv -NoTypeInformation

