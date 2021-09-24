function Get-KerberosServiceRequest {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=4769; Path = $Path } -ErrorAction SilentlyContinue
$global:KerberosServiceRequestcount=0
$A | ForEach-Object -process{
       
    $account_name = $_.Context.PostContext|Select-String -Pattern "(Account Name:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
    $service_name = $_.Context.PostContext|Select-String -Pattern "(Service Name:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
    $Client_address = $_.Context.PostContext|Select-String -Pattern "(Client Address:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}

    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name DestinationHostName -value $service_name
    $Logon | Add-Member -MemberType NoteProperty -name LogonUserName -value $account_name
    $Logon | Add-Member -MemberType NoteProperty -name SourceIP -value $Client_address
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

    $global:KerberosServiceRequestcount++
    $Logon

}}
"Number of KerberosServiceRequest  events:"+ $KerberosServiceRequestcount
