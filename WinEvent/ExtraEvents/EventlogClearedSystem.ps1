function Get-EventlogClearedSystem {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    
    $events = Get-WinEvent -FilterHashtable @{Id=104; LogName=$Path} -ErrorAction SilentlyContinue
    
    foreach ($event in $events) {
        $props = $event.Properties
        
        [PSCustomObject]@{
            TimeCreated = $event.TimeCreated
            Username = if ($props.Count -gt 0) { $props[0].Value } else { $null }
            Domain = if ($props.Count -gt 1) { $props[1].Value } else { $null }
            Channel = if ($props.Count -gt 2) { $props[2].Value } else { $null }
        }
    }
}
