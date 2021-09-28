$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path" 
$securityparam= Read-Host -Prompt "Do you want to parse the security event log? yes\no"
$Destination_Path= Join-Path -Path $Logs_Path -ChildPath "Results"
if ((Test-Path -Path "$Destination_Path")-eq $false) {
    New-Item -Path $Destination_Path -ItemType Directory    
} 
$RemoteDesktop_Path=Join-Path -Path $Destination_Path -ChildPath "RemoteDesktop"
#Check if Remote Desktop already exist
if ((Test-Path -Path "$RemoteDesktop_Path")-eq $false) {
    New-Item -Path $RemoteDesktop_Path -ItemType Directory    
}
$MapNetworkShares_Path=Join-Path -Path $Destination_Path -ChildPath "MapNetworkShares"
#Check if MapNetworkShares already exist
if ((Test-Path -Path "$MapNetworkShares_Path")-eq $false) {
    New-Item -Path $MapNetworkShares_Path -ItemType Directory    
}
$PsExec_Path=Join-Path -Path $Destination_Path -ChildPath "PsExec"
#Check if PsExec already exist
if ((Test-Path -Path "$PsExec_Path")-eq $false) {
    New-Item -Path $PsExec_Path -ItemType Directory    
}
$ScheduledTasks_Path=Join-Path -Path $Destination_Path -ChildPath "ScheduledTasks"
#Check if ScheduledTasks already exist
if ((Test-Path -Path "$ScheduledTasks_Path")-eq $false) {
    New-Item -Path $ScheduledTasks_Path -ItemType Directory    
}
$Services_Path=Join-Path -Path $Destination_Path -ChildPath "Services"
#Check if Services already exist
if ((Test-Path -Path "$Services_Path")-eq $false) {
    New-Item -Path $Services_Path -ItemType Directory    
}
$WMIOut_Path=Join-Path -Path $Destination_Path -ChildPath "WMI"
#Check if WMI already exist
if ((Test-Path -Path "$WMIOut_Path")-eq $false) {
    New-Item -Path $WMIOut_Path -ItemType Directory    
}
$PowerShellRemoting_Path=Join-Path -Path $Destination_Path -ChildPath "PowerShellRemoting"
#Check if PowerShellRemoting already exist
if ((Test-Path -Path "$PowerShellRemoting_Path")-eq $false) {
    New-Item -Path $PowerShellRemoting_Path -ItemType Directory    
}

$Security_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evtx"
$System_Path= Join-Path -Path $Logs_Path -ChildPath "System.evtx"
$RDPCORETS_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
$WMI_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evtx"
$PowerShellOperational_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evtx"
$WinPowerShell_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evtx"
$WinRM_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evtx"
$TaskScheduler_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evtx"
$TerminalServices_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
$RemoteConnection_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"
## Convert evt to evtx
$Securityevt_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evt"
$Systemevt_Path= Join-Path -Path $Logs_Path -ChildPath "System.evt"
$RDPCORETSevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
$WMIevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
$PowerShellOperationalevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
$WinPowerShellevt_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
$WinRMevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
$TaskSchedulerevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evt"
$TerminalServiceevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
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

##Validating Paths
$LogsPathTest=Test-Path -Path "$Logs_Path"
## Testing if the log file exist ? 
$Valid_Security_Path= Test-Path -Path $Security_Path
$Valid_System_Path= Test-Path -Path $System_Path
$Valid_RDPCORETS_Path= Test-Path -Path $RDPCORETS_Path
$Valid_WMI_Path= Test-Path -Path $WMI_Path
$Valid_PowerShellOperational_Path=Test-Path -Path $PowerShellOperational_Path
$Valid_WinPowerShell_Path= Test-Path -Path $WinPowerShell_Path
$Valid_WinRM_Path= Test-Path -Path $WinRM_Path
$Valid_TaskScheduler_Path= Test-Path -Path $TaskScheduler_Path
$Valid_TerminalServices_Path= Test-Path -Path $TerminalServices_Path
$Valid_RemoteConnection_Path= Test-Path -Path $RemoteConnection_Path

$ResultsArray=@()
# Remote Access
	#Remote desktop
		#destination#
if ($securityparam -eq "yes") {
 if ($Valid_Security_Path -eq $true) {
. .\PSFunctions\RemoteDesktop\AllSuccessfulLogons.ps1
Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $RemoteDesktop_Path\AllSuccessfulLogons.csv -NoTypeInformation 
write-host  "Number of AllSuccessfulLogons:" , (Import-Csv $RemoteDesktop_Path\AllSuccessfulLogons.csv).count
$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="RemoteDesktop"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\\AllSuccessfulLogons.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\RemoteDesktop\RDPreconnected.ps1
Get-RDPreconnected -Path $Security_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPreconnected.csv -NoTypeInformation 
write-host  "Number of RDPreconnected  events:" , (Import-Csv $RemoteDesktop_Path\RDPreconnected.csv).count
$hash= New-Object PSObject -property @{EventID="4778"; SANSCateogry="RemoteDesktop"; Event="RDP sessions reconnected"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPreconnected.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\RemoteDesktop\RDPDisconnected.ps1
Get-RDPDisconnected -Path $Security_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPDisconnected.csv -NoTypeInformation
write-host  "Number of RDPDisconnected  events:" , (Import-Csv $RemoteDesktop_Path\RDPDisconnected.csv).count
$hash= New-Object PSObject -property @{EventID="4779"; SANSCateogry="RemoteDesktop"; Event="RDP sessions disconnected"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPDisconnected.csv).count}
$ResultsArray+=$hash
	}
 else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red
        
 }
}

if ($Valid_RDPCORETS_Path -eq $true) {
. .\PSFunctions\RemoteDesktop\RDPConnectionAttempts.ps1
Get-RDPConnectionAttempts -Path $RDPCORETS_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPConnectionAttempts.csv -NoTypeInformation
write-host  "Number of RDPConnectionAttempts  events:" , (Import-Csv $RemoteDesktop_Path\RDPConnectionAttempts.csv).count
$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="RemoteDesktop"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPConnectionAttempts.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\RemoteDesktop\RDPSuccessfulConnections.ps1
Get-RDPSuccessfulConnections -Path $RDPCORETS_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPSuccessfulConnections.csv -NoTypeInformation
write-host  "Number of RDPSuccessfulConnections  events:" , (Import-Csv $RemoteDesktop_Path\RDPSuccessfulConnections.csv).count
$hash= New-Object PSObject -property @{EventID="98";SANSCateogry="RemoteDesktop"; Event="RDP Successful Connections"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPSuccessfulConnections.csv).count}
$ResultsArray+=$hash
}
else{ write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
          }

if ($Valid_RemoteConnection_Path -eq $true) {
. .\PSFunctions\RemoteDesktop\UserAuthSucceeded.ps1
Get-UserAuthSucceeded -Path $RemoteConnection_Path | Export-Csv -Path $RemoteDesktop_Path\UserAuthSucceeded.csv -NoTypeInformation 
write-host  "Number of UserAuthSucceeded  events:" , (Import-Csv $RemoteDesktop_Path\UserAuthSucceeded.csv).count
$hash= New-Object PSObject -property @{EventID="1149";SANSCateogry="RemoteDesktop"; Event="User authentication succeeded"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\UserAuthSucceeded.csv).count}
$ResultsArray+=$hash
}
else { write-host "Error: Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational event log is not found" -ForegroundColor Red
          }

if ($Valid_TerminalServices_Path -eq $true) {
. .\PSFunctions\RemoteDesktop\RDPSessionLogonSucceed.ps1
Get-RDPSessionLogonSucceed -Path $TerminalServices_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPSessionLogonSucceed.csv -NoTypeInformation
write-host  "Number of RDPSessionLogonSucceed  events:" , (Import-Csv $RemoteDesktop_Path\RDPSessionLogonSucceed.csv).count
$hash= New-Object PSObject -property @{EventID="21";SANSCateogry="RemoteDesktop"; Event="RDP Session Logon suceeded"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPSessionLogonSucceed.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\RemoteDesktop\RDPShellStartNotificationReceived.ps1
Get-RDPShellStartNotificationReceived -Path $TerminalServices_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPShellStartNotificationReceived.csv -NoTypeInformation
write-host  "Number of RDPShellStartNotificationReceived  events:" , (Import-Csv $RemoteDesktop_Path\RDPShellStartNotificationReceived.csv).count
$hash= New-Object PSObject -property @{EventID="21";SANSCateogry="RemoteDesktop"; Event="RDP Shell Start Notification recieved"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPShellStartNotificationReceived.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\RemoteDesktop\RDPShellSessionReconnectedSucceeded.ps1
Get-RDPShellSessionReconnectedSucceeded -Path $TerminalServices_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPShellSessionReconnectedSucceeded.csv -NoTypeInformation
write-host  "Number of RDPShellSessionReconnectedSucceeded  events:" , (Import-Csv $RemoteDesktop_Path\RDPShellSessionReconnectedSucceeded.csv).count
$hash= New-Object PSObject -property @{EventID="25";SANSCateogry="RemoteDesktop"; Event="RDP Shell Session reconnection succeeded"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPShellSessionReconnectedSucceeded.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\RemoteDesktop\RDPbeginSession.ps1
Get-RDPbeginSession -Path $TerminalServices_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPbeginSession.csv -NoTypeInformation
write-host  "Number of RDPbeginSession  events:" , (Import-Csv $RemoteDesktop_Path\RDPbeginSession.csv).count
$hash= New-Object PSObject -property @{EventID="41";SANSCateogry="RemoteDesktop"; Event="RDP Begin Session"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPbeginSession.csv).count}
$ResultsArray+=$hash
}
else { write-host "Error: Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational event log is not found" -ForegroundColor Red
         }

# Remote Access
	#Remote desktop
		#source
if ($securityparam -eq "yes") {
 if ($Valid_Security_Path -eq $true) {
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $RemoteDesktop_Path\ExplicitCreds.csv -NoTypeInformation
#write-host  "Number of ExplicitCreds  events:" , (Import-Csv $RemoteDesktop_Path\ExplicitCreds.csv).count
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="RemoteDesktop"; Event="Exolicit Credentials"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash
	}
 else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red  
 }
}

if ($Valid_RDPCORETS_Path -eq $true) {
#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectingtoServer.ps1
#Get-RDPConnectingtoServer -Path $RDPCORETS_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPConnectingtoServer.csv -NoTypeInformation
#write-host  "Number of RDPConnectingtoServer  events:" , (Import-Csv $RemoteDesktop_Path\RDPConnectingtoServer.csv).count
#$hash= New-Object PSObject -property @{EventID="1024";SANSCateogry="RemoteDesktop"; Event="RDP Connecting to Server"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPConnectingtoServer.csv).count}
#$ResultsArray+=$hash

#. D:\EJUST\Internships\TMinternship\evilize_project\RemoteDesktopcsv\RDPConnectionInitiated.ps1
#Get-RDPConnectionInitiated  -Path $RDPCORETS_Path  | Export-Csv -Path $RemoteDesktop_Path\RDPConnectionInitiated.csv -NoTypeInformation
#write-host  "Number of RDPConnectionInitiated  events:" , (Import-Csv $RemoteDesktop_Path\RDPConnectionInitiated.csv).count
#$hash= New-Object PSObject -property @{EventID="1102";SANSCateogry="RemoteDesktop"; Event="RDP Connection Initiated"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\RDPConnectionInitiated.csv).count}
#$ResultsArray+=$hash
}
else{ write-host "Error: Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational event log is not found" -ForegroundColor Red
        }
#################################################################################################################################################3

#Remote Access	
	# Map Network Shares 
		#destination
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#. .\PSFunctions\MapNetworkShares\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\AllSuccessfulLogons.csv -NoTypeInformation
#write-host  "Number of AllSuccessfulLogons  events:" , ((Get-Content Results\MapNetworkSharescsv\AllSuccessfulLogons.csv).Length -1)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="MapNetworkShares"; Event="Succesful Logons"; NumberOfOccurences=(Import-Csv $RemoteDesktop_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash 

. .\PSFunctions\MapNetworkShares\AdminLogonCreated.ps1
Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\AdminLogonCreated.csv -NoTypeInformation
write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $MapNetworkShares_Path\AdminLogonCreated.csv).count)
$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="MapNetworkShares"; Event="Admin Logon created"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\AdminLogonCreated.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\MapNetworkShares\ComputerToValidate.ps1
Get-ComputerToValidate -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\ComputerToValidate.csv -NoTypeInformation
write-host  "Number of ComputerToValidate  events:" , ((Import-Csv $MapNetworkShares_Path\ComputerToValidate.csv).count)
$hash= New-Object PSObject -property @{EventID="4776";SANSCateogry="MapNetworkShares"; Event="Computer to validate"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\ComputerToValidate.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\MapNetworkShares\KerberosAuthRequest.ps1
Get-KerberosAuthRequest -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\KerberosAuthRequest.csv -NoTypeInformation
write-host  "Number of KerberosAuthRequest  events:" , ((Import-Csv $MapNetworkShares_Path\KerberosAuthRequest.csv).count)
$hash= New-Object PSObject -property @{EventID="4768";SANSCateogry="MapNetworkShares"; Event="Kerberos Authentication Request"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\KerberosAuthRequest.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\MapNetworkShares\KerberosServiceRequest.ps1
Get-KerberosServiceRequest -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\KerberosServiceRequest.csv -NoTypeInformation
write-host  "Number of KerberosServiceRequest  events:" , ((Import-Csv $MapNetworkShares_Path\KerberosServiceRequest.csv).count)
$hash= New-Object PSObject -property @{EventID="4769";SANSCateogry="MapNetworkShares"; Event="Kerberos Service Request"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\KerberosServiceRequest.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\MapNetworkShares\NetworkShareAccessed.ps1
Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\NetworkShareAccessed.csv -NoTypeInformation
write-host  "Number of NetworkShareAccessed  events:" , ((Import-Csv $MapNetworkShares_Path\NetworkShareAccessed.csv).count)
$hash= New-Object PSObject -property @{EventID="5140";SANSCateogry="MapNetworkShares"; Event="Network Share Accessed"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\NetworkShareAccessed.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\MapNetworkShares\AuditingofSharedfiles.ps1
Get-AuditingofSharedfiles -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\AuditingofSharedfiles.csv -NoTypeInformation
write-host  "Number of AuditingofSharedfiles  events:" , ((Import-Csv $MapNetworkShares_Path\AuditingofSharedfiles.csv).count)
$hash= New-Object PSObject -property @{EventID="5145";SANSCateogry="MapNetworkShares"; Event="Auditing of Shared Files"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\AuditingofSharedfiles.csv).count}
$ResultsArray+=$hash

# Remote Access 
	#Map Network Shares
		# source
#. .\MapNetworkShares\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $MapNetworkShares_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="MapNetworkShares"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $MapNetworkShares_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash
#FailedLogintoDestination TODO

#######################################################################################################################

#Remote Execution
	#PsExec
		#Destination

#. .\PSFunctions\PsExec\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $PsExec_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $PsExec_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="PSExec"; Event="Successful Logons"; NumberOfOccurences=(Import-Csv $PsExec_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PsExec\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $PsExec_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $PsExec_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="PSExec"; Event="Admin Logon created"; NumberOfOccurences=(Import-Csv $PsExec_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PsExec\NetworkShareAccessed.ps1
#Get-NetworkShareAccessed -Path $Security_Path  | Export-Csv -Path $PsExec_Path\NetworkShareAccessed.csv -NoTypeInformation
#write-host  "Number of NetworkShareAccessed  events:" , ((Import-Csv $PsExec_Path\NetworkShareAccessed.csv).count)
#$hash= New-Object PSObject -property @{EventID="5140";SANSCateogry="PSExec"; Event="Network Share Accessed"; NumberOfOccurences=(Import-Csv $PsExec_Path\NetworkShareAccessed.csv).count}
#$ResultsArray+=$hash
	}
	 else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}
if ($Valid_System_Path -eq $true) {
. .\PSFunctions\PsExec\ServiceInstall.ps1
Get-ServiceInstall -Path $System_Path  | Export-Csv -Path $PsExec_Path\ServiceInstall.csv -NoTypeInformation
write-host  "Number of ServiceInstall  events:" , ((Import-Csv $PsExec_Path\ServiceInstall.csv).count)
$hash= New-Object PSObject -property @{EventID="7045";SANSCateogry="PSExec"; Event="Installed Service"; NumberOfOccurences=(Import-Csv $PsExec_Path\ServiceInstall.csv).count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: System event log is not found" -ForegroundColor Red   
}

#Remote Execution
	#PsExec
		#source
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#. .\PsExec\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $PsExec_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="PSExec"; Event="Exolicit Credentials"; NumberOfOccurences=(Import-Csv $PsExec_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash

############################################################################################################################

#Remote Execution
	#Scheduled Tasks
		#Destination

#. .\PSFunctions\ScheduledTasks\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path $ScheduledTasks_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $ScheduledTasks_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="ScheduledTasks"; Event="Successful Logons"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\ScheduledTasks\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $ScheduledTasks_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $ScheduledTasks_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="ScheduledTasks"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\ScheduleTaskCreated.ps1
Get-ScheduleTaskCreated -Path $Security_Path | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskCreated.csv -NoTypeInformation
write-host  "Number of ScheduleTaskCreated  events:" , ((Import-Csv $ScheduledTasks_Path\ScheduleTaskCreated.csv).count)
$hash= New-Object PSObject -property @{EventID="4698";SANSCateogry="ScheduledTasks"; Event="Schedule Task Created"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ScheduleTaskCreated.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\ScheduleTaskDeleted.ps1
Get-ScheduleTaskDeleted -Path  $Security_Path | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskDeleted.csv -NoTypeInformation
write-host  "Number of ScheduleTaskDeleted  events:" , ((Import-Csv $ScheduledTasks_Path\ScheduleTaskDeleted.csv).count)
$hash= New-Object PSObject -property @{EventID="4699";SANSCateogry="ScheduledTasks"; Event="Schedule Task Deleted"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ScheduleTaskDeleted.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\ScheduleTaskEnabled.ps1
Get-ScheduleTaskEnabled -Path  $Security_Path | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskEnabled.csv -NoTypeInformation
write-host  "Number of ScheduleTaskEnabled  events:" , ((Import-Csv $ScheduledTasks_Path\ScheduleTaskEnabled.csv).count)
$hash= New-Object PSObject -property @{EventID="4700";SANSCateogry="ScheduledTasks"; Event="Schedule Task Enabled"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ScheduleTaskEnabled.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\ScheduleTaskDisabled.ps1
Get-ScheduleTaskDisabled -Path  $Security_Path | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskDisabled.csv -NoTypeInformation
write-host  "Number of ScheduleTaskDisabled  events:" , ((Import-Csv $ScheduledTasks_Path\ScheduleTaskDisabled.csv).count)
$hash= New-Object PSObject -property @{EventID="4701";SANSCateogry="ScheduledTasks"; Event="Schedule Task Disabled"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ScheduleTaskDisabled.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\ScheduleTaskUpdated.ps1
Get-ScheduleTaskUpdated -Path  $Security_Path | Export-Csv -Path $ScheduledTasks_Path\ScheduleTaskUpdated.csv -NoTypeInformation
write-host  "Number of ScheduleTaskUpdated  events:" , ((Import-Csv $ScheduledTasks_Path\ScheduleTaskUpdated.csv).count)
$hash= New-Object PSObject -property @{EventID="4702";SANSCateogry="ScheduledTasks"; Event="Schedule Task Updated"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ScheduleTaskUpdated.csv).count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
}
}
if ($Valid_TaskScheduler_Path -eq $true) {
. .\PSFunctions\ScheduledTasks\CreatingTaskSchedulerTask .ps1
Get-CreatingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path $ScheduledTasks_Path\CreatingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of CreatingTaskSchedulerTask  events:" , ((Import-Csv $ScheduledTasks_Path\CreatingTaskSchedulerTask.csv).count)
$hash= New-Object PSObject -property @{EventID="106";SANSCateogry="ScheduledTasks"; Event="Creating TaskScheduler Task"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\CreatingTaskSchedulerTask.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\UpdatingTaskSchedulerTask.ps1
Get-UpdatingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path $ScheduledTasks_Path\UpdatingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of UpdatingTaskSchedulerTask  events:" , ((Import-Csv $ScheduledTasks_Path\UpdatingTaskSchedulerTask.csv).count)
$hash= New-Object PSObject -property @{EventID="140";SANSCateogry="ScheduledTasks"; Event="Updating TaskScheduler Task"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\UpdatingTaskSchedulerTask.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\DeletingTaskSchedulerTask .ps1
Get-DeletingTaskSchedulerTask  -Path  $TaskScheduler_Path | Export-Csv -Path $ScheduledTasks_Path\DeletingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of DeletingTaskSchedulerTask  events:" , ((Import-Csv $ScheduledTasks_Path\DeletingTaskSchedulerTask.csv).count)
$hash= New-Object PSObject -property @{EventID="141";SANSCateogry="ScheduledTasks"; Event="Deleting TaskScheduler Task"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\DeletingTaskSchedulerTask.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\ExecutingTaskSchedulerTask.ps1
Get-ExecutingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path $ScheduledTasks_Path\ExecutingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of ExecutingTaskSchedulerTask  events:" , ((Import-Csv $ScheduledTasks_Path\ExecutingTaskSchedulerTask.csv).count)
$hash= New-Object PSObject -property @{EventID="200";SANSCateogry="ScheduledTasks"; Event="Executing TaskScheduler Task"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ExecutingTaskSchedulerTask.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\ScheduledTasks\CompletingTaskSchedulerTask.ps1
Get-CompletingTaskSchedulerTask -Path  $TaskScheduler_Path | Export-Csv -Path $ScheduledTasks_Path\CompletingTaskSchedulerTask.csv -NoTypeInformation
write-host  "Number of CompletingTaskSchedulerTask  events:" , ((Import-Csv $ScheduledTasks_Path\CompletingTaskSchedulerTask.csv).count)
$hash= New-Object PSObject -property @{EventID="201";SANSCateogry="ScheduledTasks"; Event="Completing TaskScheduler Task"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\CompletingTaskSchedulerTask.csv).count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Microsoft-Windows-TaskScheduler%4Maintenance event log is not found" -ForegroundColor Red   
}
#Remote Execution
	#Scheduled Tasks
		#source
#. .\ScheduledTasks\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
	if ($Valid_Security_Path -eq $true) {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $ScheduledTasks_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="ScheduledTasks"; Event="Explicit credentials"; NumberOfOccurences=(Import-Csv $ScheduledTasks_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash

#####################################################################################################################################
#Remote Execution
	#services
		#destination

#. .\PSFunctions\Services\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $Services_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $Services_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="Services"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $Services_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

. .\PSFunctions\Services\ServiceInstalledonSystem.ps1
Get-ServiceInstalledonSystem -Path $Security_Path  | Export-Csv -Path $Services_Path\ServiceInstalledonSystem.csv -NoTypeInformation
write-host  "Number of ServiceInstalledonSystem  events:" , ((Import-Csv $Services_Path\ServiceInstalledonSystem.csv).count)
$hash= New-Object PSObject -property @{EventID="4697";SANSCateogry="Services"; Event="Service Installed on System"; NumberOfOccurences=(Import-Csv $Services_Path\ServiceInstalledonSystem.csv).count}
$ResultsArray+=$hash
	}
	else{ 
  write-host "Error: Security event log is not found" -ForegroundColor Red   
	}
}

if ($Valid_System_Path -eq $true) {
. .\PSFunctions\Services\ServiceCrashed.ps1
Get-ServiceCrashed -Path $System_Path  | Export-Csv -Path $Services_Path\ServiceCrashed.csv -NoTypeInformation
write-host  "Number of ServiceCrashed  events:" , ((Import-Csv $Services_Path\ServiceCrashed.csv).count)
$hash= New-Object PSObject -property @{EventID="7034";SANSCateogry="Services"; Event="Service Crashed"; NumberOfOccurences=(Import-Csv $Services_Path\ServiceCrashed.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\Services\ServiceSentControl.ps1
Get-ServiceSentControl -Path $System_Path  | Export-Csv -Path $Services_Path\ServiceSentControl.csv -NoTypeInformation
write-host  "Number of ServiceSentControl  events:" , ((Import-Csv $Services_Path\ServiceSentControl.csv).count)
$hash= New-Object PSObject -property @{EventID="7035";SANSCateogry="Services"; Event="Service Sent Control"; NumberOfOccurences=(Import-Csv $Services_Path\ServiceSentControl.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\Services\ServiceStartorStop.ps1
Get-ServiceStartorStop -Path $System_Path  | Export-Csv -Path $Services_Path\ServiceStartorStop.csv -NoTypeInformation
write-host  "Number of ServiceStartorStop  events:" , ((Import-Csv $Services_Path\ServiceStartorStop.csv).count)
$hash= New-Object PSObject -property @{EventID="7036";SANSCateogry="Services"; Event="Service Start or Stop"; NumberOfOccurences=(Import-Csv $Services_Path\ServiceStartorStop.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\Services\StartTypeChanged.ps1
Get-StartTypeChanged -Path $System_Path  | Export-Csv -Path $Services_Path\StartTypeChanged.csv -NoTypeInformation
write-host  "Number of StartTypeChanged  events:" , ((Import-Csv $Services_Path\StartTypeChanged.csv).count)
$hash= New-Object PSObject -property @{EventID="7040";SANSCateogry="Services"; Event="Start Type Changed"; NumberOfOccurences=(Import-Csv $Services_Path\StartTypeChanged.csv).count}
$ResultsArray+=$hash

#. .\PSFunctions\Services\ServiceInstall.ps1
#Get-ServiceInstall -Path $System_Path  | Export-Csv -Path $Services_Path\ServiceInstall.csv -NoTypeInformation
#write-host  "Number of ServiceInstall  events:" , ((Import-Csv $Services_Path\ServiceInstall.csv).count)
#$hash= New-Object PSObject -property @{EventID="7045";SANSCateogry="Services"; Event="Service Install"; NumberOfOccurences=(Import-Csv $Services_Path\ServiceInstall.csv).count}
#$ResultsArray+=$hash
}
else{ 
  write-host "Error: System event log is not found" -ForegroundColor Red   
	}
####################################################################################################################################
#Remote Execution
	#WMI\WMIC
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\WMI_WMIC\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $WMIOut_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="WMI\WMIC"; Event="All Successful Logons"; NumberOfOccurences=(Import-Csv $WMIOut_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\WMI_WMIC\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $WMIOut_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="WMI\WMIC"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $WMIOut_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash
}

if ($Valid_WinRM_Path -eq $true) {
. .\PSFunctions\WMI_WMIC\SystemQueryWMI.ps1
Get-SystemQueryWMI -Path $WinRM_Path  | Export-Csv -Path $WMIOut_Path\SystemQueryWMI.csv -NoTypeInformation
write-host  "Number of SystemQueryWMI  events:" , ((Import-Csv $WMIOut_Path\SystemQueryWMI.csv).count)
$hash= New-Object PSObject -property @{EventID="5857";SANSCateogry="WMI\WMIC"; Event="System Query WMI"; NumberOfOccurences=(Import-Csv $WMIOut_Path\SystemQueryWMI.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\WMI_WMIC\TemporaryEventConsumer.ps1
Get-TemporaryEventConsumer -Path $WinRM_Path | Export-Csv -Path $WMIOut_Path\TemporaryEventConsumer.csv -NoTypeInformation
write-host  "Number of TemporaryEventConsumer  events:" , ((Import-Csv $WMIOut_Path\TemporaryEventConsumer.csv).count)
$hash= New-Object PSObject -property @{EventID="5860";SANSCateogry="WMI\WMIC"; Event="Temporary Event Consumer"; NumberOfOccurences=(Import-Csv $WMIOut_Path\TemporaryEventConsumer.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\WMI_WMIC\PermenantEventConsumer.ps1
Get-PermenantEventConsumer -Path $WinRM_Path   | Export-Csv -Path $WMIOut_Path\PermenantEventConsumer.csv -NoTypeInformation
write-host  "Number of PermenantEventConsumer  events:" , ((Import-Csv $WMIOut_Path\PermenantEventConsumer.csv).count)
$hash= New-Object PSObject -property @{EventID="5861";SANSCateogry="WMI\WMIC"; Event="Permenant Event Consumer"; NumberOfOccurences=(Import-Csv $WMIOut_Path\PermenantEventConsumer.csv).count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Microsoft-Windows-WinRM%4Operational event log is not found" -ForegroundColor Red   
	}
#Remote Execution
	#WMI\WMIC
		#source
#. .\WMI\WMIC\ExplicitCreds.ps1
if ($securityparam -eq "yes") {
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path $WMIOut_Path\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="4648";SANSCateogry="WMI\WMIC"; Event="Explicit Credentials"; NumberOfOccurences=(Import-Csv $WMIOut_Path\ExplicitCreds.csv).count}
#$ResultsArray+=$hash
}
####################################################################################################################################3

#Remote Execution
	#powershell remoting
		#destination
if ($securityparam -eq "yes") {
#. .\PSFunctions\PowerShellRemoting\AllSuccessfulLogons.ps1
#Get-AllSuccessfulLogons -Path $Security_Path | Export-Csv -Path $PowerShellRemoting_Path\AllSuccessfulLogons.csv -NoTypeInformation 
#write-host  "Number of AllSuccessfulLogons  events:" , ((Import-Csv $PowerShellRemoting_Path\AllSuccessfulLogons.csv).count)
#$hash= New-Object PSObject -property @{EventID="4624";SANSCateogry="PowerShellRemoting"; Event="All Successful Logons"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\AllSuccessfulLogons.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\AdminLogonCreated.ps1
#Get-AdminLogonCreated -Path $Security_Path  | Export-Csv -Path $PowerShellRemoting_Path\AdminLogonCreated.csv -NoTypeInformation
#write-host  "Number of AdminLogonCreated  events:" , ((Import-Csv $PowerShellRemoting_Path\AdminLogonCreated.csv).count)
#$hash= New-Object PSObject -property @{EventID="4672";SANSCateogry="PowerShellRemoting"; Event="Admin Logon Created"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\AdminLogonCreated.csv).count}
#$ResultsArray+=$hash
}

if ($Valid_PowerShellOperational_Path -eq $true) {
. .\PSFunctions\PowerShellRemoting\ScriptBlockLogging.ps1
Get-ScriptBlockLogging -Path $PowerShellOperational_Path  | Export-Csv -Path $PowerShellRemoting_Path\ScriptBlockLogging.csv -NoTypeInformation -ErrorAction SilentlyContinue
write-host  "Number of ScriptBlockLogging  events:" , (Import-Csv $PowerShellRemoting_Path\ScriptBlockLogging.csv).count 
$hash= New-Object PSObject -property @{EventID="4103";SANSCateogry="PowerShellRemoting"; Event="Script Block Logging"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\ScriptBlockLogging.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\PowerShellRemoting\ScriptBlockAuditing.ps1
Get-ScriptBlockAuditing -Path $PowerShellOperational_Path  | Export-Csv -Path $PowerShellRemoting_Path\ScriptBlockAuditing.csv -NoTypeInformation
write-host  "Number of ScriptBlockAuditing  events:" , ((Import-Csv $PowerShellRemoting_Path\ScriptBlockAuditing.csv).count)
$hash= New-Object PSObject -property @{EventID="4104";SANSCateogry="PowerShellRemoting"; Event="Script Block Auditing"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\ScriptBlockAuditing.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\PowerShellRemoting\LateralMovementDetection.ps1
Get-LateralMovementDetection -Path $PowerShellOperational_Path  | Export-Csv -Path $PowerShellRemoting_Path\LateralMovementDetection.csv -NoTypeInformation
write-host  "Number of LateralMovementDetection  events:" , ((Import-Csv $PowerShellRemoting_Path\LateralMovementDetection.csv).count)
$hash= New-Object PSObject -property @{EventID="53504";SANSCateogry="PowerShellRemoting"; Event="Lateral Movement Detection"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\LateralMovementDetection.csv).count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Microsoft-Windows-PowerShell%4Operational event log is not found" -ForegroundColor Red   
	}

if ($Valid_WinPowerShell_Path -eq $true) {
. .\PSFunctions\PowerShellRemoting\StartPSRemoteSession.ps1
Get-StartPSRemoteSession -Path $WinPowerShell_Path  | Export-Csv -Path $PowerShellRemoting_Path\StartPSRemoteSession.csv -NoTypeInformation
write-host  "Number of StartPSRemoteSession  events:" , ((Import-Csv $PowerShellRemoting_Path\StartPSRemoteSession.csv).count)
$hash= New-Object PSObject -property @{EventID="400";SANSCateogry="PowerShellRemoting"; Event="Start PSRemote Session"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\StartPSRemoteSession.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\PowerShellRemoting\EndPSRemoteSession.ps1
Get-EndPSRemoteSession -Path $WinPowerShell_Path | Export-Csv -Path $PowerShellRemoting_Path\EndPSRemoteSession.csv -NoTypeInformation
write-host  "Number of EndPSRemoteSession  events:" , ((Import-Csv $PowerShellRemoting_Path\EndPSRemoteSession.csv).Length -1)
$hash= New-Object PSObject -property @{EventID="403";SANSCateogry="PowerShellRemoting"; Event="End PSRemote Session"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\EndPSRemoteSession.csv).count}
$ResultsArray+=$hash

. .\PSFunctions\PowerShellRemoting\PipelineExecution.ps1
Get-PipelineExecution -Path $WinPowerShell_Path| Export-Csv -Path $PowerShellRemoting_Path\PipelineExecution.csv -NoTypeInformation
write-host  "Number of PipelineExecution  events:" , ((Import-Csv $PowerShellRemoting_Path\PipelineExecution.csv).count)
$hash= New-Object PSObject -property @{EventID="800";SANSCateogry="PowerShellRemoting"; Event="Pipeline Execution"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\PipelineExecution.csv).count}
$ResultsArray+=$hash
}
else{ 
  write-host "Error: Windows PowerShell event log is not found" -ForegroundColor Red   
	}
#Remote Execution
	#powershell remoting
		#source
if ($securityparam -eq "yes") {
#. .\PSFunctions\PowerShellRemoting\ExplicitCreds.ps1
#Get-ExplicitCreds -Path $Security_Path  | Export-Csv -Path Results\PowerShellRemoting\ExplicitCreds.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash
}
#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\ClosingWSManSession.ps1
#Get-ClosingWSManSession -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManSession.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\ClosingWSManCommand .ps1
#Get-ClosingWSManCommand  -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManCommand .csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\ClosingWSManShell.ps1
#Get-ClosingWSManShell -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManShell.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\ClosingWSManSessionSucceeded.ps1
#Get-ClosingWSManSessionSucceeded -Path $WinRM_Path  | Export-Csv -Path Results\PowerShellRemoting\ClosingWSManSessionSucceeded.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\RDPreconnected.ps1
#Get-RDPreconnected -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RDPreconnected.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\CreatingRunspaceObject.ps1
#Get-CreatingRunspaceObject -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\CreatingRunspaceObject.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\CreatingRunspacePoolObject.ps1
#Get-CreatingRunspacePoolObject -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\CreatingRunspacePoolObject.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash

#. .\PSFunctions\PowerShellRemoting\RunspaceState.ps1
#Get-RunspaceState -Path $PowerShellOperational_Path  | Export-Csv -Path Results\PowerShellRemoting\RunspaceState.csv -NoTypeInformation
#$hash= New-Object PSObject -property @{EventID="131";SANSCateogry="PowerShellRemoting"; Event="RDP Connection Attempts"; NumberOfOccurences=(Import-Csv $PowerShellRemoting_Path\RDPConnectionAttempts.csv).count}
#$ResultsArray+=$hash
$ResultsArray| Out-GridView
