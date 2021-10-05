function Get-ScheduleTaskCreated {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A= Get-WinEvent -FilterHashtable @{ Id=4698; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
       	
    $Task_content =  $_.Context.PostContext|Select-String -Pattern "(Task Content:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
	
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name LogonUsername -value $_.properties[1].value
    $Logon | Add-Member -MemberType NoteProperty -name TaskName -value $_.properties[4].value
    $Logon | Add-Member -MemberType NoteProperty -name TaskContent -value $_.properties[5].value
	
	$Logon

} }

