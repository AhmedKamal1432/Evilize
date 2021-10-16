function Get-StartTypeChanged   {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=7040; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
       
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name ServiceName-value $_.properties[0].value
    $Logon | Add-Member -MemberType NoteProperty -name ChangedFrom -value $_.properties[1].value
	$Logon | Add-Member -MemberType NoteProperty -name ChangedTo -value $_.properties[2].value
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

	
    $Logon

} }

