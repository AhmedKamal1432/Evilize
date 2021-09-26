function Get-ScheduleTaskDeleted {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A= Get-WinEvent -FilterHashtable @{ Id=4699; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
       	
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name LogonUsername -value $_.properties[1].value
    $Logon | Add-Member -MemberType NoteProperty -name TaskName -value $_.properties[4].value
	 $Logon | Add-Member -MemberType NoteProperty -name TaskContent -value $_.properties[5].value
	
	$Logon

} }

