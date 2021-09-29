$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path"  
$Destination_Path=$Logs_Path
$NoSecurity = Read-Host -Prompt "Optimize Runtime if security log is too big, Is it ? (yes/no)"  
#Dot-sourcing to the helper script
. .\Helper\helper.ps1
# calling function inside the script itself 

#====RemoteDesktop
Function main{

Write-Host "Parsing Successsful Logons"
SuccessfulLogons $NoSecurity
Write-Host "Parsing RDP Sessions Began"
RDPBegainSession
Write-Host "Parsing RDP Connections Attempts"
RDPConnectionsAttempts
Write-Host "Parsing RDP Connections Established"
RDPConnectionEstablished
Write-Host "Parsing RDP Local Successful Logons 1"
RDPLocalSuccessfulLogon1
Write-Host "Parsing RDP Local Successful Logons 2"
RDPLocalSuccessfulLogon2
Write-Host "Parsing RDP Successful TCP Connections"
RDPSuccessfulTCPConnections
Write-Host "Parsing RDP Sessions Reconnected"
RDPReconnected $NoSecurity
Write-Host "Parsing RDP Sessions Disconnected"
RDPDisconnected $NoSecurity
#=====MapNetworkShare
Write-Host "Parsing Network Share Object Accessed"
NetworkShareAccessed $NoSecurity
Write-Host "Parsing Network Share Object Checked"
NetworkShareChecked $NoSecurity
Write-Host "Parsing Admin Logons Created"
AdminLogonCreated $NoSecurity
Write-Host "Parsing Domain Controller attempts to validate accounts' credentials"
ComputerToValidate $NoSecurity
Write-Host "Parsing Kerberos Authentications Requested"
KerberosAuthenticationRequested $NoSecurity
Write-Host "Parsing Kerberos Services Requested"
KerberosServiceRequested $NoSecurity
#=======PsExec
Write-Host "Parsing Installed Services [System Log]"
SystemInstalledServices

#=====ScheduledTasks 
Write-Host "Parsing Scheduled Tasks Created [Security Log]"
ScheduledTaskCreatedSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Deleted [Security Log]"
ScheduledTaskDeletedSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Enabled [Security Log]"
ScheduledTaskEnabledSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Disabled [Security Log]"
ScheduledTaskDisabledSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Updated [Security Log]"
ScheduledTaskUpdatedSec $NoSecurity
Write-Host "Parsing Scheduled Tasks Created [Task Scheduler Log]"
ScheduledTasksCreatedTS 
Write-Host "Parsing Scheduled Tasks Deleted [Task Scheduler Log]"
ScheduledTasksDeletedTS 
Write-Host "Parsing Scheduled Tasks Executed [Task Scheduler Log]"
ScheduledTasksExecutedTS
Write-Host "Parsing Scheduled Tasks Completed [Task Scheduler Log]"
ScheduledTasksCompletedTS
Write-Host "Parsing Scheduled Tasks Updated [Task Scheduler Log]"
ScheduledTasksUpdatedTS

#======WMI 
Write-Host "Parsing WMI Operations Started"
WMIOperationStarted
Write-Host "Parsing WMI Operations Temporary Ess Started"
WMIOperationTemporaryEssStarted
Write-Host "Parsing WMI Operations To Consumer Binding"
WMIOperationESStoConsumerBinding


#=====Services
Write-Host "Parsing Installed Services [Security Log]"
InstalledServices $NoSecurity
Write-Host "Parsing Services Crashed Unexpectedely"
ServiceCrashedUnexpect
Write-Host "Parsing Services Status"
ServicesStatus
Write-Host "Parsing Services Requested Start Stop Controls"
ServiceSentStartStopControl
Write-Host "Parsing Services Start Type Changed"
ServiceStartTypeChanged

#======PowerShellRemoting 
Write-Host "Parsing PowerShell Module Logging"
PSModuleLogging
Write-Host "Parsing PowerShell Script Blocking Logging"
PSScriptBlockLogging
Write-Host "Parsing PowerShell Authneticating User"
PSAuthneticatingUser
Write-Host "Parsing PowerShell Partial Code"
PSPartialCode
Write-Host "Parsing Session Created"
SessionCreated
Write-Host "Parsing WinRM Authenticating User "
WinRMAuthneticatingUser
Write-Host "Parsing Server Remote Hosts Started"
ServerRemoteHostStarted
Write-Host "Parsing Server Remote Host Ended"
ServerRemoteHostEnded
}
main
$ResultsArray| Out-GridView
