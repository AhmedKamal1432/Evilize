function Get-UpdatingTaskSchedulerTask {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=140; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{


    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name TaskName -value $_.properties[0].value
	$Logon | Add-Member -MemberType NoteProperty -name LogonUsername -value $_.properties[1].value
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id
    	

    $Logon
}
}

