# Evilize
## Remote Acces
### Remote Desktop 
RDPLogons (Security.evtx, event id= 4624, Logon Type =10) parsed values: Time created, Logon username, Account domain, Logon ID, Logon type, Authentication package, Source workstation, Process name, Source IP

RDPreconnected (Security.evtx, event id= 4778) parsed values: Time created, Logon username, Account domain, Source IP, Source system name, Logon ID
RDPDisconnected (Security.evtx, event id= 4779) parsed values: Time created, Logon username, Account domain, Source IP, Source system name, Logon ID
RDPConnectionAttempts (Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx, event id =131) parsed values: Time created, Destination host name, Transport layer protocol, Client IP
RDPSuccessfulConnections (Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx, event id =98) parsed values: Time created, Destination host name, User ID
UserAuthSucceeded (Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational, event id =1149) parsed values: Time created, Logon username, Source IP
RDPSessionLogonSuccessed (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id=21) parsed values: Time created, Logon username, Source IP
RDPShellStartNotificationReceived (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id =22) parsed values: Time created, Logon username, Source IP
RDPShellSessionReconnectedSucceeded (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id=25) parsed values: Time created, Logon username, Source IP
RDPbeginSession (Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx, event id =41) parsed values: Time created, Logon username
