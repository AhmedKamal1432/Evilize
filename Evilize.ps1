[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, Position=0, HelpMessage="Please enter the path of event logs files")]
    [string] $Logs_Path,
    [Parameter(Mandatory=$false, Position=1, HelpMessage="parse the logs by WinEvent cmdlet not LogParser")]
    [switch] $winevent,
    [Parameter(Mandatory=$false, Position=2, HelpMessage="parse security logs which may takes time")]
    [switch] $security,
    [Parameter(Mandatory=$false, Position=3, HelpMessage="Parse source event IDs")]
    [switch] $Source_Events,
    [Parameter(Mandatory=$false, Position=4, HelpMessage="Parse source event IDs")]
    [switch] $all_logs

)
function Evilize  {
   if ($winevent) {
       . .\WinEvent\WinEvent.ps1
    }
    else{
        . .\LogParser\Logparser.ps1
    }
}
Evilize
