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

### Map Network Shares (net.exe)
#### Destination
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
|AllSuccessfulLogons | Security.evtx | 4624 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP |
| AdminLogonCreated | Security.evtx | 4672 | Time created, Login ID, Logon username, Account domain |
| ComputerToValidate | Security.evtx | 4776 | Time created, Logon username, Source workstation |
| KerberosAuthRequest | Security.evtx | 4768 | Time created, Logon username, Source workstation |
| KerberosServiceRequest | Security.evtx | 4769 | Time created, Destination hostname, Logon username, Source IP |
| NetworkShareAccessed | Security.evtx | 5140 | Time created, Logon ID, Logon username, account domain, Security ID, Source port, Source IP, Share name |
| AuditingofSharedfiles | Security.evtx | 5145 | Time created, Share name, Relative target, Source IP, Accesses |

## Remote Execution
### PsExec
#### Destination
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| AllSuccessfulLogons | Security.evtx | 4624 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP |
| AdminLogonCreated | Security.evtx | 4672 | Time created, Login ID, Logon username, Account domain |
| NetworkShareAccessed | Security.evtx | 5140 | Time created, Logon ID, Logon username, account domain, Security ID, Source port, Source IP, Share name |
| ServiceInstall | System.evtx | 7045 | Time created, Service name, Service file name, Service type, Service start type |

### Scheduled Tasks
#### Destination
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| AllSuccessfulLogons | Security.evtx | 4624 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP | 
| AdminLogonCreated | Security.evtx | 4672 | Time created, Login ID, Logon username, Account domain |
| ScheduleTaskCreated | Security.evtx | 4698| Time created, Logon username, Task name, Task content |
| ScheduleTaskDeleted | Security.evtx | 4699 | Time created, Logon username, Task name, Task content |
| ScheduleTaskEnabled | Security.evtx | 4700 | Time created, Logon username, Task name, Task content |
| ScheduleTaskDisabled | Security.evtx | 4701 | Time created, Logon username, Task name, Task content |
| ScheduleTaskUpdated | Security.evtx | 4702 | Time created, Logon username, Task name, Task content |
| CreatingTaskSchedulerTask | Microsoft-Windows-TaskScheduler%4Maintenance.evtx | 106 | Time created, Task name, Logon username |
| UpdatingTaskSchedulerTask | Microsoft-Windows-TaskScheduler%4Maintenance.evtx | 140 | Time created, Task name, Logon username |
| DeletingTaskSchedulerTask | Microsoft-Windows-TaskScheduler%4Maintenance.evtx | 141 | Time created, Task name, Logon username, Instance |
| ExecutingTaskSchedulerTask | Microsoft-Windows-TaskScheduler%4Maintenance.evtx | 200 | Time created, Task name, Logon username, Task action, Instance |
| CompletingTaskSchedulerTask | Microsoft-Windows-TaskScheduler%4Maintenance.evtx | 201 | Time created, Task name, Logon username,Task action, Instance |

### Services
#### Destination
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| AllSuccessfulLogons | Security.evtx | 4624 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP 
| AdminLogonCreated | Security.evtx | 4672 | Time created, Login ID, Logon username, Account domain |
| ServiceInstalledonSystem | Security.evtx | 4697 | Time created, Service name, Service Type, Service Start type, Service Account, Service File name, Event ID | 
| ServiceCrashed | System.evtx | 7034 | Time created, Service name, Times |
| ServiceSentControl | System.evtx | 7035 | Time created, Service name, Request sent |
| ServiceStartorStop | System.evtx | 7036 | Time created, Service name, State |
| StartTypeChanged | System.evtx | 7040 | Time created, Service name, Changed from, Changed to |
| ServiceInstall | System.evtx | 7045 | Time created, Service name, Service file name, Service type, Service start type |

### WMI/WMIC
#### Destination 
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| AllSuccessfulLogons | Security.evtx |  4624 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP |
| AdminLogonCreated | Security.evtx | 4672 | Time created, Login ID, Logon username, Account domain |
| SystemQueryWMI | Microsoft-Windows-WMI-Activity%4Operational.evtx | 5857 | Time created, dll path |
| TemporaryEventConsumer | Microsoft-Windows-WMI-Activity%4Operational.evtx | 5860 | Time created,namespace, query |
| PermenantEventConsumer | Microsoft-Windows-WMI-Activity%4Operational.evtx | 5861 | Time created,name space, query |

### PowerShell Remoting
#### Destination
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| AllSuccessfulLogons | Security.evtx | 4624 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP |
| AdminLogonCreated | Security.evtx | 4672 | Time created, Login ID, Logon username, Account domain |
| ScriptBlockLogging | Microsoft-Windows-PowerShell%4Operational.evtx | 4103 | Time created, Command invoced |
| ScriptBlockAuditing | Microsoft-Windows-PowerShell%4Operational.evtx |4104 | Time created, Command invoced |
| LateralMovementDetection | Microsoft-Windows-PowerShell%4Operational.evtx | 53504 | Time created, App domain |
| StartPSRemoteSession | Windows PowerShell.evtx | 400 | Time created, Details |
| EndPSRemoteSession | Windows PowerShell.evtx | 403 | Time created, Details |
| PipelineExecution | Windows PowerShell.evtx | 800 | Time created, Command line, Context information, Details |
| SessionCreated | Microsoft-Windows-WinRM%4Operational.evtx | 91 | Time created, ResourceURL |
| AuthRecorded | Microsoft-Windows-WinRM%4Operational.evtx | 168 | Time created, message |

### Extra Events
| Event Name | Event Log | ID |Parsed values |
| --- | --- | -- | -- |
| UnsuccessfulLogons | Security.evtx | 4625 | Time created, Logon username, Account domain, Logon ID, Logon type, Authentication Package, Source Workstation, Process name, Source IP |
| EventlogCleared | Security.evtx | 1102 | Time created, Security ID, Account Name, Account Domain, Logon ID |  
| SystemLogCleared | System.evtx | 104 | Time created, Username, Domain, Channel |







