function Get-EventlogCleared {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    $events = Get-WinEvent -FilterHashtable @{ Id=1102; LogName = $Path } -ErrorAction SilentlyContinue

    foreach ($event in $events) {
        $obj = [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            LogName = $Path
            EventID = $event.Id
            DestinationHostname = if ($event.Properties.Count -gt 0) { $event.Properties[0].Value } else { $null }
            DestinationIP = if ($event.Properties.Count -gt 1) { $event.Properties[1].Value } else { $null }
        }
        $obj
    }
}
