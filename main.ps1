#Dot-sourcing to the helper script
. .\Helper\helper.ps1
# calling function inside the script itself 
#====RemoteDesktop
SuccessfulLogons
RDPBegainSession
RDPConnectionsAttempts
RDPConnectionEstablished
RDPLocalSuccessfulLogon1
RDPLocalSuccessfulLogon2
RDPSuccessfulTCPConnections
RDPReconnected
RDPDisconnected
#=====MapNetworkShare 
NetworkShareAccessed
NetworkShareChecked
AdminLogonCreated
ComputerToValidate
KerberosAuthenticationRequested
KerberosServiceRequested
#=======PsExec
SystemInstalledServices

#=====ScheduledTasks 
ScheduledTaskCreatedSec
ScheduledTaskDeletedSec
ScheduledTaskEnabledSec
ScheduledTaskDisabledSec
ScheduledTaskUpdatedSec
ScheduledTasksCreatedTS
ScheduledTasksDeletedTS
ScheduledTasksExecutedTS
ScheduledTasksCompletedTS
ScheduledTasksUpdatedTS

#======WMI 
WMIOperationStarted
WMIOperationTemporaryEssStarted
WMIOperationESStoConsumerBinding


#=====Services
InstalledServices
ServiceCrashedUnexpect
ServicesStatus
ServiceSentStartStopControl
ServiceStartTypeChanged

#======PowerShellRemoting 
PSModuleLogging
PSScriptBlockLogging
PSAuthneticatingUser
SessionCreated
WinRMAuthneticatingUser
ServerRemoteHostStarted
ServerRemoteHostEnded
PSPartialCode



