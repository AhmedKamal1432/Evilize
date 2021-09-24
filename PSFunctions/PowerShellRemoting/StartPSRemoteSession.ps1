function Get-StartPSRemoteSession {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
	
$A= Get-WinEvent -FilterHashtable @{Id=400 ;Path = $Path } -ErrorAction SilentlyContinue
$global:EndPSRemoteSessioncount=0
$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name Details -value $_.properties[2].value
	$Logon| Add-Member -MemberType NoteProperty -name EventID -value $_.Id
	
	$global:StartPSRemoteSessioncount++
    $Logon
 }}
 "Number of StartPSRemoteSession events:"+ $StartPSRemoteSessioncount
