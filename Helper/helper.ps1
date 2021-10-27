#Event Logs Paths
$global:Securityevt_Path = ""
$global:Security_Path = ""
$global:Systemevt_Path = ""
$global:System_Path = ""
$global:RDPCORETS_Path = ""
$global:RDPCORETSevt_Path = ""
$global:WMI_Path = ""
$global:WMIevt_Path = ""
$global:PowerShellOperational_Path = ""
$global:PowerShellOperationalevt_Path = ""
$global:WinPowerShell_Path = ""
$global:WinPowerShellevt_Path = ""
$global:WinRM_Path = ""
$global:WinRMevt_Path = ""
$global:TaskScheduler_Path = ""
$global:TaskSchedulerevt_Path = ""
$global:TerminalServices_Path = ""
$global:TerminalServicesRDP_Path=""
$global:TerminalServicesRDPevt_Path=""
$global:TerminalServiceevt_Path = ""
$global:RemoteConnection_Path = ""
$global:RemoteConnectionevt_Path = ""

## Testing if the log file exist ? 
$global:Valid_Security_Path= ""
$global:Valid_System_Path= ""
$global:Valid_RDPCORETS_Path= ""
$global:Valid_WMI_Path= ""
$global:Valid_PowerShellOperational_Path=""
$global:Valid_WinPowerShell_Path= ""
$global:Valid_WinRM_Path= ""
$global:Valid_TaskScheduler_Path= ""
$global:Valid_TerminalServices_Path= ""
$global:Valid_RemoteConnection_Path= ""
$global:Valid_TerminalServicesRDP_Path=""



$global:Destination_Path=""
$global:RemoteDesktop_Path=""
$global:MapNetworkShares_Path=""
$global:PsExec_Path=""
$global:ScheduledTasks_Path=""
$global:Services_Path=""
$global:WMIOut_Path=""
$global:PowerShellRemoting_Path=""
$global:ExtraEvents_Path=""
$global:SourceEvents_Path_Path=""

#array to store results
$global:ResultsArray= @()

function print_logo {
    param (
        [Parameter(Mandatory = $false)]
        [string]
        $Method
    )
    Write-host "
     ______           _     __    _            
    / ____/ _   __   (_)   / /   (_) ____  ___ 
   / __/   | | / /  / /   / /   / / /_  / / _ \
  / /___   | |/ /  / /   / /   / /   / /_/  __/
 /_____/   |___/  /_/   /_/   /_/   /___/\___/ " -ForegroundColor Red 
    if (($Method -eq 'Logparser' ) -or ($Method -eq '')) {
        Write-Host "
    _    ____ ____ ___  ____ ____ ____ ____ ____ 
    |    |  | | __ |__] |__| |__/ [__  |___ |__/ 
    |___ |__| |__] |    |  | |  \ ___] |___ |  \ "-ForegroundColor green 
    }
    else {
        Write-Host "
    _ _ _ _ _  _ ____ _  _ ____ _  _ ___ 
    | | | | |\ | |___ |  | |___ |\ |  |  
    |_|_| | | \| |___  \/  |___ | \|  | " -ForegroundColor green
    }
}

function Print_Seprator {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]
        $Name
    )

    Write-Host ""  -ForegroundColor yellow 
    Write-Host ""  -ForegroundColor yellow 
    Write-Host "**********************************************"  -ForegroundColor yellow 
    Write-Host  "              $Name                  "  -ForegroundColor yellow 
    Write-Host  "**********************************************"  -ForegroundColor yellow 
}

function check_logs_path {
    param(
        [string] $Logs_Path
    )

    if (Test-Path -Path "$Logs_Path") {
        return $true
    }
    else{
        Write-Host "Error: Invalid Paths, Please Enter a valid path"
        return $false
    }
}

## Convert evt to evtx
function Evt2Evtx {
    param (
        [Parameter(Mandatory = $true)]
        [string]$EvtPath,
        [Parameter(Mandatory = $true)]
        [string]$EvtxPath
    )
    if (((Test-Path -Path $EvtPath) -eq $true) -and ((Test-Path -Path $EvtxPath) -eq $false)) {
        wevtutil epl $EvtPath $EvtxPath /lf:true    
    }
    else {
        return
    }   
}
function evt_conversion {
    param(
        [string] $Logs_Path
    )
    $global:Security_Path = Join-Path -Path $Logs_Path -ChildPath "Security.evtx"
    $Securityevt_Path = Join-Path -Path $Logs_Path -ChildPath "Security.evt"
    $global:System_Path = Join-Path -Path $Logs_Path -ChildPath "System.evtx"
    $Systemevt_Path = Join-Path -Path $Logs_Path -ChildPath "System.evt"
    $global:RDPCORETS_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evtx"
    $RDPCORETSevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-RemoteDesktopServices-RdpCoreTS%4Operational.evt"
    $global:WMI_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evtx"
    $WMIevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WMI-Activity%4Operational.evt"
    $global:PowerShellOperational_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evtx"
    $PowerShellOperationalevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-PowerShell%4Operational.evt"
    $global:WinPowerShell_Path = Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evtx"
    $WinPowerShellevt_Path = Join-Path -Path $Logs_Path -ChildPath "Windows PowerShell.evt"
    $global:WinRM_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evtx"
    $WinRMevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-WinRM%4Operational.evt"
    $global:TaskScheduler_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evtx"
    $TaskSchedulerevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TaskScheduler%4Operational.evt"
    $global:TerminalServices_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evtx"
    $TerminalServiceevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-LocalSessionManager%4Operational.evt"
    $global:RemoteConnection_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evtx"
    $RemoteConnectionevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RemoteConnectionManager%4Operational.evt"
    $global:TerminalServicesRDP_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RDPClient%4Operational.evtx"
    $TerminalServicesRDPevt_Path = Join-Path -Path $Logs_Path -ChildPath "Microsoft-Windows-TerminalServices-RDPClient%4Operational.evt"
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
    Evt2Evtx $TerminalServicesRDPevt_Path $TerminalServicesRDP_Path
}

function check_individual_logs {
    $global:Valid_Security_Path= Test-Path -Path $Security_Path
    $global:Valid_System_Path= Test-Path -Path $System_Path
    $global:Valid_RDPCORETS_Path= Test-Path -Path $RDPCORETS_Path
    $global:Valid_WMI_Path= Test-Path -Path $WMI_Path
    $global:Valid_PowerShellOperational_Path=Test-Path -Path $PowerShellOperational_Path
    $global:Valid_WinPowerShell_Path= Test-Path -Path $WinPowerShell_Path
    $global:Valid_WinRM_Path= Test-Path -Path $WinRM_Path
    $global:Valid_TaskScheduler_Path= Test-Path -Path $TaskScheduler_Path
    $global:Valid_TerminalServices_Path= Test-Path -Path $TerminalServices_Path
    $global:Valid_RemoteConnection_Path= Test-Path -Path $RemoteConnection_Path
    $global:Valid_TerminalServicesRDP_Path= Test-Path -Path $TerminalServicesRDP_Path
}
function csv_output_directories {
    param(
        [string] $Logs_Path
    )
    ##Create Results Directory
    $global:Destination_Path = Join-Path -Path $Logs_Path -ChildPath "Results"
    if ((Test-Path -Path "$Destination_Path") -eq $false) {
        New-Item -Path $Destination_Path -ItemType Directory    
    }

    $global:RemoteDesktop_Path = Join-Path -Path $Destination_Path -ChildPath "RemoteDesktop"
    if ((Test-Path -Path "$RemoteDesktop_Path") -eq $false) {
        New-Item -Path $RemoteDesktop_Path -ItemType Directory    
    }

    $global:MapNetworkShares_Path = Join-Path -Path $Destination_Path -ChildPath "MapNetworkShares"
    if ((Test-Path -Path "$MapNetworkShares_Path") -eq $false) {
        New-Item -Path $MapNetworkShares_Path -ItemType Directory    
    }

    $global:PsExec_Path = Join-Path -Path $Destination_Path -ChildPath "PsExec"
    if ((Test-Path -Path "$PsExec_Path") -eq $false) {
        New-Item -Path $PsExec_Path -ItemType Directory    
    }

    $global:ScheduledTasks_Path = Join-Path -Path $Destination_Path -ChildPath "ScheduledTasks"
    if ((Test-Path -Path "$ScheduledTasks_Path") -eq $false) {
        New-Item -Path $ScheduledTasks_Path -ItemType Directory    
    }

    $global:Services_Path = Join-Path -Path $Destination_Path -ChildPath "Services"
    if ((Test-Path -Path "$Services_Path") -eq $false) {
        New-Item -Path $Services_Path -ItemType Directory    
    }

    $global:WMIOut_Path = Join-Path -Path $Destination_Path -ChildPath "WMI"
    if ((Test-Path -Path "$WMIOut_Path") -eq $false) {
        New-Item -Path $WMIOut_Path -ItemType Directory    
    }

    $global:PowerShellRemoting_Path = Join-Path -Path $Destination_Path -ChildPath "PowerShellRemoting"
    #Check if PowerShellRemoting already exist
    if ((Test-Path -Path "$PowerShellRemoting_Path") -eq $false) {
        New-Item -Path $PowerShellRemoting_Path -ItemType Directory    
    }

    $global:ExtraEvents_Path = Join-Path -Path $Destination_Path -ChildPath "ExtraEvents"
    #Check if PowerShellRemoting already exist
    if ((Test-Path -Path "$ExtraEvents_Path") -eq $false) {
        New-Item -Path $ExtraEvents_Path -ItemType Directory    
    }

}

function GetStats {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    $Valid=Test-Path -Path "$FilePath"
    if($Valid -eq $true){
        #(Import-Csv $FilePath).count
        $NumRows=LogParser.exe -i:csv -stats:OFF "Select Count (*) from '$FilePath'" | Out-String
        [int]($NumRows.Substring([int](29))).Trim()
} 
    else {
        Return 0
    }
}


function __merge_csvs {
    param (
        [Parameter(Mandatory=$true)]
        [string]$csvs_path,
        [Parameter(Mandatory=$true)]
        [string]$xlsx_name
        )

        $csvs = Get-ChildItem -Path $csvs_path\* -Include *.csv
        $excelFileName = $Destination_Path + "\" + $xlsx_name
        Remove-Item $excelFileName -ErrorAction Ignore
        Write-Host "Creating: $excelFileName" -ForegroundColor Green

        foreach ($csv in $csvs) {
            $worksheetName = $csv.Name.Replace(".csv","")
            Import-Csv -Path $csv.FullName| Export-Excel -Path $excelFileName -WorkSheetname $worksheetName
        }
}

function merge_csvs {

    if (Get-Module -ListAvailable -Name ImportExcel) {
        Write-Host "Module exists"
    }
    else {
        Write-Host "Module does not exist"
        Install-Module ImportExcel -scope CurrentUser -Force
    }
    __merge_csvs $RemoteDesktop_Path "RemoteDesktop.xlsx"
    __merge_csvs $MapNetworkShares_Path "MapNetworkShares.xlsx"
    __merge_csvs $PsExec_Path "PsExec.xlsx"
    __merge_csvs $ScheduledTasks_Path "ScheduledTasks.xlsx"
    __merge_csvs $Services_Path "Services.xlsx"
    __merge_csvs $WMIOut_Path "WMI.xlsx"
    __merge_csvs $ExtraEvents_Path "ExtraEvents.xlsx"
}
