#Dot-sourcing to Operational Helper and helper  files
. .\Helper\helper.ps1
function LogparserCalls {
    #====RemoteDesktop============
    Print_Seprator "RemoteDesktop"
    Write-Host "Parsing Successsful Logons"
    AllSuccessfulLogons $NoSecurity

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
    RDPShellSessionReconnectedSucceeded $NoSecurity

    Write-Host "Parsing RDP Sessions Reconnected"
    RDPreconnected $NoSecurity

    Write-Host "Parsing RDP Sessions Disconnected"
    RDPDisconnected $NoSecurity


    #=====MapNetworkShare===============
    Print_Seprator "MapNetworkShare"
    Write-Host "Parsing Network Share Object Accessed"
    NetworkShareAccessed $NoSecurity

    Write-Host "Parsing Network Share Object Checked"
    AuditingofSharedfiles $NoSecurity

    Write-Host "Parsing Admin Logons Created"
    AdminLogonCreated $NoSecurity

    Write-Host "Parsing Domain Controller attempts to validate accounts' credentials"
    ComputerToValidate $NoSecurity

    Write-Host "Parsing Kerberos Authentications Requested"
    KerberosAuthRequest $NoSecurity

    Write-Host "Parsing Kerberos Services Requested"
    KerberosServiceRequest $NoSecurity


    #=======PsExec==========
    Print_Seprator "Powershell Execution"
    Write-Host "Parsing Installed Services [System Log]"
    ServiceInstall

    #=====ScheduledTasks============ 
    Print_Seprator "ScheduledTasks"
    Write-Host "Parsing Scheduled Tasks Created [Security Log]"
    ScheduleTaskCreated $NoSecurity

    Write-Host "Parsing Scheduled Tasks Deleted [Security Log]"
    ScheduleTaskDeleted $NoSecurity

    Write-Host "Parsing Scheduled Tasks Enabled [Security Log]"
    ScheduleTaskEnabled $NoSecurity

    Write-Host "Parsing Scheduled Tasks Disabled [Security Log]"
    ScheduleTaskDisabled $NoSecurity

    Write-Host "Parsing Scheduled Tasks Updated [Security Log]"
    ScheduleTaskUpdated $NoSecurity

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
    ServiceInstalledonSystem $NoSecurity

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

    Write-Host "Parsing Server Remote Host Ended"
    EndPSRemoteSession
    #=======ExtraEvents
    Print_Seprator "Extra Events"
    Write-Host "Parsing UnSuccesssful Logons"
    UnsuccessfulLogons $NoSecurity

    Write-Host "Parsing CLeared Event Logs"
    EventlogClearedSecurity $NoSecurity
    EventlogClearedSystem
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
