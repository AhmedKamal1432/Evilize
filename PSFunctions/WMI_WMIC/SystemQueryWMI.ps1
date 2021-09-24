function Get-SystemQueryWMI {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=5857; Path = $Path} -ErrorAction SilentlyContinue
$global:SystemQueryWMIcount=0
$A | ForEach-Object -process{
       
  	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name  DllPath -value $_.properties[4].value
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

	$global:SystemQueryWMIcount++
    $Logon

} }
"Number of SystemQueryWMI  events:"+ $SystemQueryWMIcount
