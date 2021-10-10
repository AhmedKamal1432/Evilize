#Dot-sourcing to Operational Helper and helper  files
. .\Helper\helper.ps1
function LogparserCalls {
    <#
    #====RemoteDesktop============
    Print_Seprator "RemoteDesktop"
    Write-Host "Parsing Successsful Logons"
    AllSuccessfulLogons $security

    Write-Host "Parsing RDP Sessions Began"
    RDPbeginSession

    Write-Host "Parsing RDP Connections Attempts"
    RDPConnectionsAttempts

    Write-Host "Parsing RDP Connections Established"
    UserAuthSucceeded

    Write-Host "Parsing RDP Local Successful Logons 1"
    RDPSessionLogonSucceeded

    Write-Host "Parsing RDP Local Successful Logons 2"
    RDPShellStartNotificationReceived

    Write-Host "Parsing RDP Successful TCP Connections"
    RDPSuccessfulConnections

    Write-Host "RDP Successful Shell Sessions Reconnected"
    RDPShellSessionReconnectedSucceeded $security

    Write-Host "Parsing RDP Sessions Reconnected"
    RDPreconnected $security

    Write-Host "Parsing RDP Sessions Disconnected"
    RDPDisconnected $security


    #=====MapNetworkShare===============
    Print_Seprator "MapNetworkShare"
    Write-Host "Parsing Network Share Object Accessed"
    NetworkShareAccessed $security

    Write-Host "Parsing Network Share Object Checked"
    AuditingofSharedfiles $security

    Write-Host "Parsing Admin Logons Created"
    AdminLogonCreated $security

    Write-Host "Parsing Domain Controller attempts to validate accounts' credentials"
    ComputerToValidate $security

    Write-Host "Parsing Kerberos Authentications Requested"
    KerberosAuthRequest $security

    Write-Host "Parsing Kerberos Services Requested"
    KerberosServiceRequest $security


    #=======PsExec==========
    Print_Seprator "Powershell Execution"
    Write-Host "Parsing Installed Services [System Log]"
    ServiceInstall

    #=====ScheduledTasks============ 
    Print_Seprator "ScheduledTasks"
    Write-Host "Parsing Scheduled Tasks Created [Security Log]"
    ScheduleTaskCreated $security

    Write-Host "Parsing Scheduled Tasks Deleted [Security Log]"
    ScheduleTaskDeleted $security

    Write-Host "Parsing Scheduled Tasks Enabled [Security Log]"
    ScheduleTaskEnabled $security

    Write-Host "Parsing Scheduled Tasks Disabled [Security Log]"
    ScheduleTaskDisabled $security

    Write-Host "Parsing Scheduled Tasks Updated [Security Log]"
    ScheduleTaskUpdated $security

    Write-Host "Parsing Scheduled Tasks Created [Task Scheduler Log]"
    CreatingTaskSchedulerTask 

    Write-Host "Parsing Scheduled Tasks Deleted [Task Scheduler Log]"
    DeletingTaskSchedulerTask 

    Write-Host "Parsing Scheduled Tasks Executed [Task Scheduler Log]"
    ExecutingTaskSchedulerTask

    Write-Host "Parsing Scheduled Tasks Completed [Task Scheduler Log]"
    CompletingTaskSchedulerTask

    Write-Host "Parsing Scheduled Tasks Updated [Task Scheduler Log]"
    UpdatingTaskSchedulerTask

    #======WMI ==================
    Print_Seprator "WMI/WMIC"
    Write-Host "Parsing WMI Operations Started"
    SystemQueryWMI

    Write-Host "Parsing WMI Operations Temporary Ess Started"
    TemporaryEventConsumer

    Write-Host "Parsing WMI Operations To Consumer Binding"
    PermenantEventConsumer

    #=======Services========
    Print_Seprator "Services"
    Write-Host "Parsing Installed Services [Security Log]"
    ServiceInstalledonSystem $security

    Write-Host "Parsing Services Crashed Unexpectedely"
    ServiceCrashed

    Write-Host "Parsing Services Status"
    ServiceStartorStop

    Write-Host "Parsing Services Requested Start Stop Controls"
    ServiceSentControl

    Write-Host "Parsing Services Start Type Changed"
    StartTypeChanged

    #======PowerShellRemoting 
    Print_Seprator "PowerShellRemoting"
    Write-Host "Parsing PowerShell Module Logging"
    ScriptBlockLogging

    Write-Host "Parsing PowerShell Script Blocking Logging"
    ScriptBlockAuditing	

    Write-Host "Parsing PowerShell Authneticating User"
    LateralMovementDetection

    Write-Host "Parsing PowerShell Partial Code"
    PipelineExecution

    Write-Host "Parsing Session Created"
    SessionCreated

    Write-Host "Parsing WinRM Authenticating User "
    AuthRecorded

    Write-Host "Parsing Server Remote Hosts Started"
    StartPSRemoteSession
#>
    Write-Host "Parsing Server Remote Host Ended"
    EndPSRemoteSession
    #=======ExtraEvents
    Print_Seprator "Extra Events"
    Write-Host "Parsing UnSuccesssful Logons"
    UnsuccessfulLogons $security

    Write-Host "Parsing CLeared Event Logs"
    EventlogClearedSecurity $security
    Write-Host "Parsing CLeared Event Logs"
    EventlogClearedSystem
    #===== SourceEvents
    Write-Host "Parsing Explicit credentials used"
    ExplicitCreds $security $Source_Events

    Write-Host "Parsing RDP ActiveX Controls"
    RDPActiveXControls $Source_Events 

    Write-Host "Parsing RDP Multitransport Connections"
    RDPAMultitransportCon $Source_Events

    Write-Host "Parsing WSMan Sessions Created"
    WSManSessions $Source_Events

    Write-Host "Parsing Powershell Sessions Created"
    PSSessionsCreated $Source_Events
    
    Write-Host "Parsing Powershell Sessions Closed"
    PSSessionsClosed $Source_Events
}

Function main {
    print_logo
    if (check_logs_path $Logs_Path) {
        
        evt_conversion $Logs_Path
        csv_output_directories $Logs_Path
        check_individual_logs
        $NoSecurity = "no"
        if ($security) {
            $NoSecurity = "yes"
        }
        LogparserCalls
    }
    
}
main
$ResultsArray | Out-GridView
