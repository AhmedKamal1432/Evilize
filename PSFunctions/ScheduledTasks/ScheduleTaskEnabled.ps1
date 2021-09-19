function Get-ScheduleTaskEnabled {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A= Get-WinEvent -FilterHashtable @{ Id=4700; Path = $Path }
$global:ScheduleTaskEnabledcount=0
$A | ForEach-Object -process{
       	
	
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name LogonUsername -value $_.properties[1].value
    $Logon | Add-Member -MemberType NoteProperty -name TaskName -value $_.properties[4].value
    $Logon | Add-Member -MemberType NoteProperty -name TaskContent -value $_.properties[5].value
	$global:ScheduleTaskEnabledcount++
	$Logon

} }
"Number of ScheduleTaskEnabled events:"+ $ScheduleTaskEnabledcount