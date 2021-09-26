function Get-RDPSuccessfulConnections{
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=98; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
	
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name DestinationHostname -value $_.MachineName
	$Logon | Add-Member -MemberType NoteProperty -name UserId -value $_.UserId
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

   

    $Logon
} }

 
