function Get-RDPConnectingtoServer {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=1024; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name DestinationHostname -value $_.properties[0].value
	$Logon | Add-Member -MemberType NoteProperty -name DestinationIP -value $_.properties[1].value


    $Logon

}} 

 
 