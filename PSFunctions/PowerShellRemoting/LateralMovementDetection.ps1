function Get-LateralMovementDetection {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
	
$A= Get-WinEvent -FilterHashtable @{Id=53504 ;Path = $Path } -ErrorAction SilentlyContinue
$global:LateralMovementDetectioncount=0
$A | ForEach-Object -process{
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name AppDomain -value $_.properties[1].value
	$Logon| Add-Member -MemberType NoteProperty -name EventID -value $_.Id
	$global:LateralMovementDetectioncount++
    $Logon
 }}
 "Number of LateralMovementDetection events:"+ $LateralMovementDetectioncount
