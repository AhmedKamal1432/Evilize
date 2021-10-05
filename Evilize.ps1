function Evilize  {
    $Method= Read-Host -Prompt "Evilize Event Logs using Logparser Or WinEvent? [Default=Logparser]" 
    IF(($Method -eq "Logparser") -or ($Method -eq "")){
        . .\Logparser.ps1
    }
    elseif (($Method -eq "WinEve")) {
        . .\WinEvent.ps1
    }
}
Evilize
