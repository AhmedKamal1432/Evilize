function Get-SessionCreated {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=91; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{


    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name ResourceURL -value $_.properties[0].value
	

   
    $Logon
} }