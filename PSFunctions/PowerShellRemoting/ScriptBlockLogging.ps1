function Get-ScriptBlockLogging {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
	
$A= Get-WinEvent -FilterHashtable @{Id=4103 ;Path = $Path } -ErrorAction SilentlyContinue
$global:ScriptBlockLoggingcount=0
$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name CommandsInvoced -value $_.properties[2].value
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id
	$global:ScriptBlockLoggingcount++
    $Logon
 }}
 "Number of ScriptBlockLogging events:"+ $ScriptBlockLoggingcount
