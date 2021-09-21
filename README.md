# Evilize
## Remote Access
### Remote Desktop 
#### Destination
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| AllSuccessfulLogons | Security.evtx | 4624 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP|
| RDPreconnected | Security.evtx | 4778 | Time created, Logon username, Account domain, Source IP, Source system name, Logon ID |
| RDPDisconnected | Security.evtx | 4779 | Time created, Logon username, Account domain, Source IP, Source system name, Logon ID |
| RDPConnectionAttempts | Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx | 131 | Time created, Destination host name, Transport layer protocol, Client IP |
| RDPSuccessfulConnections | Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx | 98 | Time created, Destination host name, User ID |
| UserAuthSucceeded | Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational | 1149 | Time created, Logon username, Source IP |
| RDPSessionLogonSuccessed | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx | 21 | Time created, Logon username, Source IP, Session ID |
| RDPShellStartNotificationReceived | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx | 22 | Time created, Logon username, Source IP, Session ID|
| RDPShellSessionReconnectedSucceeded | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx | 25 | Time created, Logon username, Source IP, Session ID |
| RDPbeginSession | Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx | 41 | Time created, Logon username |
#### Source
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| ExplicitCreds | Security.evtx | 4648 | Time created, Logon ID, Logon username, Account domain, Alternate username, Alternate domain, Destination host name, Destination IP, Destination port, Destination info, Process name |
| RDPConnnectingtoServer | Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx | 1024 | Time created, Destination hostname, Destination IP |
| RDPConnnectionInitiated | Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx | 1102 | Time created, Destination hostname, Destination IP |

### Map Network Shares (net.exe)
#### Destination
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
AllSuccessfulLogons (Security.evtx, event id= 4624)\
parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP

AdminLogonCreated(Security.evtx, event id =4672)\
parsed values: Time created, Login ID, Logon username, Account domain

ComputerToValidate(Security.evtx, event id= 4776)\
parsed values: Time created, Logon username, Source workstation

KerberosAuthRequest(Security.evtx, event id =4768)\
parsed values: Time created, Logon username, Source workstation

KerberosServiceRequest( Security.evtx, event id=4769)\
parsed values: Time created, Destination hostname, Logon username, Source IP

NetworkShareAccessed (Security.evtx, event id =5140)\
parsed values: Time created, Logon ID, Logon username, account domain, Security ID, Source port, Source IP, Share name

AuditingofSharedfiles(Security.evtx, event id=5145)\
parsed values: Time created, Share name, Relative target, Source IP, Accesses

#### Source
ExplicitCreds (Security.evtx, event id =4648)\
parsed values: Time created, Logon ID, Logon username, Account domain, Alternate username, Alternate domain, Destination host name, Destination IP, Destination port, Destination info, Process name

FailedLogintoDestination (Microsoft-WindowsSmbClient%4Security.evtx , event id=31001)\
TODO

## Remote Execution
### PsExec
#### Destination
AllSuccessfulLogons (Security.evtx, event id= 4624)\
parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP

AdminLogonCreated(Security.evtx, event id =4672)\
parsed values: Time created, Login ID, Logon username, Account domain

NetworkShareAccessed (Security.evtx, event id =5140)\
parsed values: Time created, Logon ID, Logon username, account domain, Security ID, Source port, Source IP, Share name

ServiceInstall (System.evtx, event id =7045)\
parsed values: Time created, Service name, Service file name, Service type, Service start type

#### Source
ExplicitCreds (Security.evtx, event id =4648)\
parsed values: Time created, Logon ID, Logon username, Account domain, Alternate username, Alternate domain, Destination host name, Destination IP, Destination port, Destination info, Process name

### Scheduled Tasks
#### Destination
AllSuccessfulLogons (Security.evtx, event id= 4624)\
parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP 

AdminLogonCreated(Security.evtx, event id =4672)\
parsed values: Time created, Login ID, Logon username, Account domain

ScheduleTaskCreated (Security.evtx, event id= 4698)\
parsed values: Time created, Logon username, Task name, Task content

ScheduleTaskDeleted (Security.evtx, event id= 4699)\
parsed values: Time created, Logon username, Task name, Task content

ScheduleTaskEnabled (Security.evtx, event id= 4700)\
parsed values: Time created, Logon username, Task name, Task content

ScheduleTaskDisabled (Security.evtx, event id= 4701)\
parsed values: Time created, Logon username, Task name, Task content

ScheduleTaskUpdated (Security.evtx, event id= 4702)\
parsed values: Time created, Logon username, Task name, Task content

CreatingTaskSchedulerTask (Microsoft-Windows-TaskScheduler%4Maintenance.evtx, event id= 106)\
parsed values: Time created, Task name, Logon username

UpdatingTaskSchedulerTask (Microsoft-Windows-TaskScheduler%4Maintenance.evtx, event id 140)\
parsed values: Time created, Task name, Logon username

DeletingTaskSchedulerTask (Microsoft-Windows-TaskScheduler%4Maintenance.evtx, event id =141 )\
parsed values: Time created, Task name, Logon username, Instance

ExecutingTaskSchedulerTask (Microsoft-Windows-TaskScheduler%4Maintenance.evtx, event id 200)\
parsed values: Time created, Task name, Logon username, Task action, Instance

CompletingTaskSchedulerTask (Microsoft-Windows-TaskScheduler%4Maintenance.evtx, event id= 201)\
parsed values: Time created, Task name, Logon username,Task action, Instance
#### Source
ExplicitCreds (Security.evtx, event id =4648)\
parsed values: Time created, Logon ID, Logon username, Account domain, Alternate username, Alternate domain, Destination host name, Destination IP, Destination port, Destination info, Process name

### Services
#### Destination
AllSuccessfulLogons (Security.evtx, event id= 4624)\
parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP 

AdminLogonCreated(Security.evtx, event id =4672)\
parsed values: Time created, Login ID, Logon username, Account domain

ServiceCrashed (System.evtx, event id=7034)\
parsed values :Time created, Service name, Times

ServiceSentControl (System.evtx, event id=7035)\
parsed values :Time created, Service name, Request sent

ServiceStartorStop (System.evtx, event id=7036)\
parsed values :Time created, Service name, State

StartTypeChanged (System.evtx, event id =7040)\
parsed values: Time created, Service name, Changed from, Changed to

ServiceInstall (System.evtx, event id =7045)\
parsed values: Time created, Service name, Service file name, Service type, Service start type

### WMI/WMIC
#### Destination 
AllSuccessfulLogons (Security.evtx, event id= 4624)\
parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP 

AdminLogonCreated(Security.evtx, event id =4672)\
parsed values: Time created, Login ID, Logon username, Account domain

SystemQueryWMI (Microsoft-Windows-WMI-Activity%4Operational.evtx, event id =5857)\
parsed values: Time created, dll path

TemporaryEventConsumer (Microsoft-Windows-WMI-Activity%4Operational.evtx, event id=5860)\
parsed values: Time created,namespace, query

PermenantEventConsumer (Microsoft-Windows-WMI-Activity%4Operational.evtx, event id=5861)\
parsed values: Time created,name space, query)
 
#### Source
ExplicitCreds (Security.evtx, event id =4648)\
parsed values: Time created, Logon ID, Logon username, Account domain, Alternate username, Alternate domain, Destination host name, Destination IP, Destination port, Destination info, Process name

### PowerShell Remoting
#### Destination
AllSuccessfulLogons (Security.evtx, event id= 4624)\
parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP 

AdminLogonCreated(Security.evtx, event id =4672)\
parsed values: Time created, Login ID, Logon username, Account domain

ScriptBlockLogging( Microsoft-Windows-PowerShell%4Operational.evtx, event id =4103)\







