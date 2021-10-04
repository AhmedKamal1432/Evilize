# Evilize

An incident response framework in Powershell that parses Windows Event Logs and exports valuable events IDs' values into CSV file.

## Functionality

It uses Logpraser , which is  a powerful tool that provides universal query access to text-based data such as log files, XML files and CSV files, to parse windows event IDs. It focuses only on the important event IDs according to [SANS Poster](https://share.ialab.dsu.edu/CRRC/Incident%20Response/Supplementary%20Material/SANS_Poster_2018_Hunt_Evil_FINAL.pdf). 

## َResults Mapping

| Event ID   | Output File Name                     | Parsed Values                                                |
| ---------- | ------------------------------------ | ------------------------------------------------------------ |
| 4624       | SuccessfulLogons.csv                 | TimeGenerated, EventID, Username, Domain, LogonType, AuthPackage, Workstation, ProcessName, SourceIP |
| 4625       | UnSuccessfulLogons.csv               | TimeGenerated, EventID, Username, Domain, LogonType, AuthPackage, Workstation, ProcessName, ProcessPath, SourceIP, SourcePort |
| 4672       | AdminLogonCreated.csv                | TimeGenerated, EventID, Username, Domain, LogonID            |
| 4697       | InstalledServices.csv                | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, ServiceName, ServiceFileName, ServiceType, ServiceStartType |
| 4698       | ScheduledTaskCreatedSec.csv          | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, TaskName, TaskContent |
| 4699       | ScheduledTaskDeletedSec.csv          | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, TaskName, TaskContent |
| 4700       | ScheduledTaskEnabledSec.csv          | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, TaskName, TaskContent |
| 4701       | ScheduledTaskDisabledSec.csv         | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, TaskName, TaskContent |
| 4702       | ScheduledTaskUpdatedSec.csv          | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, TaskName, TaskContent |
| 4768       | KerberosAuthenticationRequested.csv  | TimeGenerated, EventID, AccountName, AccountDomain, SourceIP, SourcePort |
| 4769       | KerberosServiceRequested.csv         | TimeGenerated, EventID, AccountName, AccountDomain, ServiceName, SourceIP, SourcePort |
| 4776       | ComputerToValidate.csv               | TimeGenerated, EventID, AccountName, AccountDomain           |
| 4778       | RDPReconnected.csv                   | TimeGenerated, EventID, Username, Domain, Workstation, SourceIP |
| 4779       | RDPDisconnected.csv                  | TimeGenerated, EventID, Username, Domain, Workstation, SourceIP |
| 5140       | NetworkShareAccessed.csv             | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, SourceIP, SourcePort, ShareName |
| 5145       | NetworkShareChecked.csv              | TimeGenerated, EventID, AccountName, AccountDomain, LogonID, ObjectType, SourceIP, SourcePort, ShareName, SharePath, Accessess, AccessesCheckResult |
| 7034       | ServiceCrashedUnexpect.csv           | TimeGenerated, EventID, ServiceName, Times                   |
| 7036       | ServicesStatus.csv                   | TimeGenerated, EventID, ServiceName, State                   |
| 7035       | ServiceSentStartStopControl.csv      | TimeGenerated, EventID, ServiceName, RequestSent             |
| 7040       | ServiceStartTypeChanged.csv          | TimeGenerated, EventID, ServiceName, ChangedFrom, ChangedTo  |
| 7045       | SystemInstalledServices.csv          | TimeGenerated, EventID, ServiceName, ImagePath, ServiceType, StartType, AccountName, |
| 5857       | WMIOperationStarted.csv              | TimeGenerated, EventID, ProviderName, Code, ProcessID, ProviderPath |
| 5860       | WMIOperationTemporaryEssStarted.csv  | TimeGenerated, EventID, NameSpace, Query, User, ProcessID, ClientMachine |
| 5861       | WMIOperationESStoConsumerBinding.csv | TimeGenerated, EventID, NameSapace, ESS, Consumer, PossibleCause |
| *** 4103** | PSModuleLogging.csv                  | TimeGenerated, EventID, ContextINFO, Payload                 |
| *** 4104** | PSScriptBlockLogging.csv             | TimeGenerated, EventID, MessageNumber, TotalMessages, ScriptBlockText, ScriptBlockID, ScriptPath |
| 53504      | PSAuthneticatingUser.csv             | TimeGenerated, EventID, Process, AppDomain                   |
| 91         | SessionCreated.csv                   | TimeGenerated, EventID, ResourceUrl                          |
| *** 168**  | WinRMAuthneticatingUser.csv          | TimeGenerated, EventID, Message                              |
| *** 400**  | ServerRemoteHostStarted.csv          | TimeGenerated, EventID, HostApplication                      |
| *** 403**  | ServerRemoteHostEnded.csv            | TimeGenerated, EventID, HostApplication                      |
| *** 800**  | PSPartialCode.csv                    | TimeGenerated, EventID, HostApplication                      |
| 106        | ScheduledTasksCreatedTS.csv          | TimeGenerated, EventID, TaskName, User                       |
| 140        | ScheduledTasksUpdatedTS.csv          | TimeGenerated, EventID, TaskName, User                       |
| 141        | ScheduledTasksDeletedTS.csv          | TimeGenerated, EventID, TaskName, User                       |
| 200        | ScheduledTasksExecutedTS.csv         | TimeGenerated, EventID,  TaskName, TaskAction, Instance      |
| 201        | ScheduledTasksCompletedTS.csv        | TimeGenerated, EventID, TaskName, TaskAction, Instance       |
| 21         | RDPLocalSuccessfulLogon1.csv         | TimeGenerated, EventID, User, SessionID, SourceIP            |
| 22         | RDPLocalSuccessfulLogon2.csv         | TimeGenerated, EventID, User, SessionID, SourceIP            |
| 25         | RDPLocalSuccessfulReconnection.csv   | TimeGenerated, EventID, User, SessionID, SourceIP            |
| 41         | RDPBegainSession.csv                 | TimeGenerated, EventID, User, SessionID                      |
| 1149       | RDPConnectionEstablished.csv         | TimeGenerated, EventID, User, Domain, SourceIP               |
| 131        | RDPConnectionsAttempts .csv          | TimeGenerated, EventID, ConnectionType, CLientIP             |
| 98         | RDPSuccessfulTCPConnections.csv      | TimeGenerated, EventID                                       |



The following Event IDs will be revised again since the output values is not formatted well:

`[4103, 4104 ,168, 400, 403, 800]`

- 168 => Need a sample of this event to know its content in order to parse its values

  ## Usage

  1. Download and Install [Logparser](https://www.microsoft.com/en-us/download/details.aspx?id=24659).
  2. Add Log parser path to your machine environment variables [[Guide](https://www.architectryan.com/2018/03/17/add-to-the-path-on-windows-10/)]
  3. Clone this repository
  4. Run the main file using Windows PowerShell `.\main.ps1`
  5. Enter the Event logs' path you want to parse
     1. If it's in the system partition you need to run with root privileges
  6. Enter the Destination of the results

