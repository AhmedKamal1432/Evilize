function Get-ExplicitCreds {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )

$A = Get-WinEvent -FilterHashtable @{ Id=4648; Path = $Path } -ErrorAction SilentlyContinue
$A | ForEach-Object -process{
       
    # Account, Domain, ID
    $_.Message.split([Environment]::NewLine)| Select-String -Pattern "Subject:" -Context 0,10 |ForEach-Object {
        $account_name = $_.Context.PostContext|Select-String -Pattern "(Account Name:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
        $account_domain = $_.Context.PostContext|Select-String -Pattern "(Account Domain:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
        $login_ID = $_.Context.PostContext|Select-String -Pattern "(Logon ID:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
    } 
	 $_.Message.split([Environment]::NewLine)| Select-String -Pattern "Account Whose Credentials Were Used:" -Context 0,10 |ForEach-Object {
	  $alternate_user = $_.Context.PostContext|Select-String -Pattern "(Account Name:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
	  $alternate_domain = $_.Context.PostContext|Select-String -Pattern "(Account Domain:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
	}
    $Process_name = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Process Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	$destination_name = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Target Server Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    $Network_address = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Network Address:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	$destination_port = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Port:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	$destination_info = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Additional Information:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name LogonID -value $Login_ID
    $Logon | Add-Member -MemberType NoteProperty -name LogonUserName -value $account_name
    $Logon | Add-Member -MemberType NoteProperty -name AccountDomain -value $account_domain
    $Logon | Add-Member -MemberType NoteProperty -name AlternateUserName -value $_.properties[5].value
	$Logon | Add-Member -MemberType NoteProperty -name AlternateDomain -value $_.properties[6].value
    $Logon | Add-Member -MemberType NoteProperty -name DestinationHostName -value $destination_name
	$Logon | Add-Member -MemberType NoteProperty -name DestinationIP -value $Network_address
	$Logon | Add-Member -MemberType NoteProperty -name DestinationPort -value $destination_port
	$Logon | Add-Member -MemberType NoteProperty -name DestinationInfo -value $destination_info
    $Logon | Add-Member -MemberType NoteProperty -name ProcessName -value $Process_name

 
    $Logon

} }

