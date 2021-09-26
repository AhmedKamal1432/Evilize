function Get-ServiceInstalledonSystem {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=4697; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
       
    # Account, Domain, ID
	$_.Message.split([Environment]::NewLine)| Select-String -Pattern "Service Information:" -Context 0,10 |ForEach-Object {
    $service_type =  $_.Context.PostContext|Select-String -Pattern "(Service Type:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
    $service_start_type =  $_.Context.PostContext|Select-String -Pattern "(Service Start Type:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
    $service_account =  $_.Context.PostContext|Select-String -Pattern "(Service Account:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
	$service_name = $_.Context.PostContext|Select-String -Pattern "(Service Name:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
	}
    $service_file_name =$_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Service File Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name ServiceName-value $service_name
    $Logon | Add-Member -MemberType NoteProperty -name ServiceType -value $service_type
    $Logon | Add-Member -MemberType NoteProperty -name ServiceStartType-value $service_start_type
    $Logon | Add-Member -MemberType NoteProperty -name ServiceAccount -value $service_account
	$Logon | Add-Member -MemberType NoteProperty -name ServiceFileName -value $service_file_name
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

	
    $Logon

} }

