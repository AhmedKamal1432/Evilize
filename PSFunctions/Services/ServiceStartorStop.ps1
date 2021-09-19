function Get-ServiceStartorStop  {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=7036; Path = $Path }
$global:ServiceStartorStopcount=0
$A | ForEach-Object -process{
       
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name ServiceName-value $_.properties[0].value
    $Logon | Add-Member -MemberType NoteProperty -name State -value $_.properties[1].value
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

	$global:ServiceStartorStopcount++
    $Logon

} 
"Number of ServiceStartorStop  events:"+ $ServiceStartorStopcount