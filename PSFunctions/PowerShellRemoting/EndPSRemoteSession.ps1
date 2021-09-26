function Get-EndPSRemoteSession {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
	
$A= Get-WinEvent -FilterHashtable @{Id=403 ;Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name Details -value $_.properties[2].value
	$Logon| Add-Member -MemberType NoteProperty -name EventID -value $_.Id
	
    $Logon
 }}
