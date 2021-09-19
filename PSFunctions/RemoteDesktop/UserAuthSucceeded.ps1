function Get-UserAuthSucceeded{
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=1149; Path = $Path }
$global:UserAuthSucceededcount=0
$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
	
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name LogonUserName -value $_.properties[0]
	$Logon | Add-Member -MemberType NoteProperty -name SourceIP -value $_.properties[2]
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

   
    $global:UserAuthSucceededcount++
    $Logon
} }
"Number of UserAuthSucceeded events:"+ $UserAuthSucceededcount
 