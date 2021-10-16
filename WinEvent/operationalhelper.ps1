function print_logo {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Method
    )
    Write-host "
     ______           _     __    _            
    / ____/ _   __   (_)   / /   (_) ____  ___ 
   / __/   | | / /  / /   / /   / / /_  / / _ \
  / /___   | |/ /  / /   / /   / /   / /_/  __/
 /_____/   |___/  /_/   /_/   /_/   /___/\___/ " -ForegroundColor Red 
 if(($Method -eq 'Logparser' )-or($Method -eq $null)){
        Write-Host "
_    ____ ____ ___  ____ ____ ____ ____ ____ 
|    |  | | __ |__] |__| |__/ [__  |___ |__/ 
|___ |__| |__] |    |  | |  \ ___] |___ |  \ "-ForegroundColor green }
 else{
     Write-Host "
_ _ _ _ _  _ ____ _  _ ____ _  _ ___ 
| | | | |\ | |___ |  | |___ |\ |  |  
|_|_| | | \| |___  \/  |___ | \|  | " -ForegroundColor green 
 }
}
#=====logo print 


function get_input{
	$Logs_Path = Read-Host -Prompt "Please, Enter Events logs path"  
	$Destination_Path= $Logs_Path
	$NoSecurity = Read-Host -Prompt "Do you want to parse the security event log? yes\no [Default is no]"
	if($NoSecurity -eq ""){
			$NoSecurity="no"
		}
	$LogsPathTest=Test-Path -Path "$Logs_Path"
	$DestPathTest=Test-Path -Path "$Destination_Path"
	if((($LogsPathTest -eq $true) -and ($DestPathTest -eq $true)) -ne $true ){
				Write-Host "Error: Invalid Paths, Please Enter a valid path"
				exit
			}
	return $Logs_Path, $Destination_Path, $NoSecurity
}
    ##Validating Paths
function validate_paths{
	 param(
		[Parameter(Mandatory=$true)][String] $Security_Path,
		[Parameter(Mandatory=$true)][String] $System_Path,
		[Parameter(Mandatory=$true)][String] $RDPCORETS_Path,
		[Parameter(Mandatory=$true)][String] $WMI_Path,
		[Parameter(Mandatory=$true)][String] $PowerShellOperational_Path,
		[Parameter(Mandatory=$true)][String] $WinRM_Path,
		[Parameter(Mandatory=$true)][String] $TaskScheduler_Path,
		[Parameter(Mandatory=$true)][String] $TerminalServices_Path,
		[Parameter(Mandatory=$true)][String] $RemoteConnection_Path
    )
	
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
	
	return $Valid_Security_Path, $Valid_System_Path, $Valid_RDPCORETS_Path, $Valid_WMI_Path, $Valid_PowerShellOperational_Path,
	$Valid_WinRM_Path, $Valid_TaskScheduler_Path, $Valid_TerminalServices_Path, $Valid_RemoteConnection_Path, $Valid_RemoteConnection_Path
}
function get_logs_paths{
	param(
        [Parameter(Mandatory=$true)][String] $Logs_Path
	)
	$Securityevt_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evt"
	$Security_Path= Join-Path -Path $Logs_Path -ChildPath "Security.evtx"
	$Systemevt_Path= Join-Path -Path $Logs_Path -ChildPath "System.evt"
	$System_Path= Join-Path -Path $Logs_Path -ChildPath "System.evtx"
	$RDPCORETS_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
	$RDPCORETSevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
	$WMI_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evtx"
	$WMIevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
	$PowerShellOperational_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evtx"
	$PowerShellOperationalevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
	$WinPowerShell_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evtx"
	$WinPowerShellevt_Path= Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
	$WinRM_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evtx"
	$WinRMevt_Path= Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
	$TaskScheduler_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evtx"
	$TaskSchedulerevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Maintenance.evt"
	$TerminalServices_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
	$TerminalServiceevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
	$RemoteConnection_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"
	$RemoteConnectionevt_Path=Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evt"
	return $Securityevt_Path, $Security_Path, $Systemevt_Path, $System_Path, $RDPCORETS_Path, $RDPCORETSevt_Path, $WMI_Path, $WMIevt_Path,
	$PowerShellOperational_Path, $PowerShellOperationalevt_Path, $WinPowerShell_Path, $WinPowerShellevt_Path, $WinRM_Path, $WinRMevt_Path, 
	$TaskScheduler_Path, $TaskSchedulerevt_Path, $TerminalServices_Path,$TerminalServiceevt_Path, $RemoteConnection_Path, $RemoteConnectionevt_Path
}
## Convert evt to evtx
function Evt2Evtx {
    param (
        [Parameter(Mandatory=$true)]
        [string]$EvtPath,
        [Parameter(Mandatory=$true)]
        [string]$EvtxPath
    )
    if (((Test-Path -Path $EvtPath) -eq $true) -and ((Test-Path -Path $EvtxPath) -eq $false)) {
        wevtutil epl $EvtPath $EvtxPath /lf:true    
    }
    else {
        return
    }   
}
function convertEVT2EVTX{
	param(
        [Parameter(Mandatory=$true)][String] $Securityevt_Path,
		[Parameter(Mandatory=$true)][String] $Security_Path,
		[Parameter(Mandatory=$true)][String] $Systemevt_Path,
		[Parameter(Mandatory=$true)][String] $System_Path,
		[Parameter(Mandatory=$true)][String] $WMIevt_Path,
		[Parameter(Mandatory=$true)][String] $WMI_Path,
		[Parameter(Mandatory=$true)][String] $WinPowerShell_Path,
		[Parameter(Mandatory=$true)][String] $WinPowerShellevt_Path,
		[Parameter(Mandatory=$true)][String] $WinRMevt_Path,
		[Parameter(Mandatory=$true)][String] $WinRM_Path,
		[Parameter(Mandatory=$true)][String] $TaskSchedulerevt_Path,
		[Parameter(Mandatory=$true)][String] $TaskScheduler_Path,
		[Parameter(Mandatory=$true)][String] $TerminalServiceevt_Path,
		[Parameter(Mandatory=$true)][String] $TerminalServices_Path,
		[Parameter(Mandatory=$true)][String] $RemoteConnection_Path,
		[Parameter(Mandatory=$true)][String] $RemoteConnectionevt_Path,
		[Parameter(Mandatory=$true)][String] $PowerShellOperationalevt_Path,
		[Parameter(Mandatory=$true)][String] $PowerShellOperational_Path
		)
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
}
##Create Results Directory
function create_results_directory{
	param (
        [Parameter(Mandatory=$true)][string]$Destination_Path
		)
	$Destination_Path= Join-Path -Path $Destination_Path -ChildPath "Results"
	#check if it's already exist
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
	return $RemoteDesktop_Path, $MapNetworkShares_Path, $PsExec_Path, $ScheduledTasks_Path, $Services_Path, $WMIOut_Path, $PowerShellRemoting_Path
}

function Functioncall{
 param(
		[scriptblock]$FunctionToCall,
        [Parameter(Mandatory=$true)] [String] $Log_Path,
		[Parameter(Mandatory=$true)] [String] $NoSecurity,
		[Parameter(Mandatory=$true)] [String] $export_path,
		[Parameter(Mandatory=$true)] [String] $Eventid,
		[Parameter(Mandatory=$true)] [String] $SANSCategory,
		[Parameter(Mandatory=$true)] [String] $eventname,
		[Parameter(Mandatory=$true)] [String] $ResultsArray
		)
$x= $FunctionToCall.Invoke($Log_Path,$NoSecurity)
$x| Export-Csv -Path $export_path -NoTypeInformation 
$hash= New-Object PSObject -property @{EventID=$Eventid;SANSCateogry=$SANSCategory; Event= $eventname; NumberOfOccurences=$x.count}
$ResultsArray+=$hash
}
function Print_Seprator  {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $Name
    )
    Write-Host "**********************************************"  -ForegroundColor yellow 
    Write-Host  "              $Name                  "  -ForegroundColor yellow 
    Write-Host  "**********************************************"  -ForegroundColor yellow 
    
}