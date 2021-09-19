# Evilize
## Remote Access
### Remote Desktop 
#### Destination
RDPLogons (Security.evtx, event id= 4624, Logon Type =10)\
parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP

RDPreconnected (Security.evtx, event id= 4778)\ 
parsed values: Time created, Logon username, Account domain, Source IP, Source system name, Logon ID

RDPDisconnected (Security.evtx, event id= 4779)\
parsed values: Time created, Logon username, Account domain, Source IP, Source system name, Logon ID

RDPConnectionAttempts (Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx, event id =131)\
parsed values: Time created, Destination host name, Transport layer protocol, Client IP

RDPSuccessfulConnections (Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx, event id =98)\
parsed values: Time created, Destination host name, User ID

UserAuthSucceeded (Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational, event id =1149)\
parsed values: Time created, Logon username, Source IP

RDPSessionLogonSuccessed (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id=21)\
parsed values: Time created, Logon username, Source IP

RDPShellStartNotificationReceived (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id =22)\
parsed values: Time created, Logon username, Source IP

RDPShellSessionReconnectedSucceeded (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id=25)\
parsed values: Time created, Logon username, Source IP

RDPbeginSession (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id =41)\
parsed values: Time created, Logon username
#### Source
ExplicitCreds (Security.evtx, event id =4648)\
parsed values: Time created, Logon ID, Logon username, Account domain, Alternate username, Alternate domain, Destination host name, Destination IP, Destination port, Destination info, Process name

RDPConnnectingtoServer (Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx, event id = 1024)\
parsed values: Time created, Destination hostname, Destination IP

RDPConnnectionInitiated (Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx, event id =1102)\
parsed values: Time created, Destination hostname, Destination IP
### Map Network Shares (net.exe)
#### Destination
NetworkLogons (Security.evtx event id= 4624, Logon Type =3)\
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

NetworkLogons (Security.evtx event id= 4624, Logon Type =3)\
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




