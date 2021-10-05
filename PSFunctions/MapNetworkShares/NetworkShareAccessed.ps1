function Get-NetworkShareAccessed {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=5140; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
       
    # Account, Domain, ID
    $_.Message.split([Environment]::NewLine)| Select-String -Pattern "Subject:" -Context 0,10 |ForEach-Object {
        $account_name = $_.Context.PostContext|Select-String -Pattern "(Account Name:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
        $account_domain = $_.Context.PostContext|Select-String -Pattern "(Account Domain:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
     	$login_ID = $_.Context.PostContext|Select-String -Pattern "(Logon ID:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
        $security_ID = $_.Context.PostContext|Select-String -Pattern "(Security ID:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
    
	} 
	 
	$object_type = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Object Type:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    $share_name = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Share Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	$source_port = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Source Port:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    $source_address = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Source Address:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name LogonID -value $Login_ID
    $Logon | Add-Member -MemberType NoteProperty -name LogonUsername -value $account_name
    $Logon | Add-Member -MemberType NoteProperty -name AccountDomain -value $account_domain
    $Logon | Add-Member -MemberType NoteProperty -name SecurityId -value $security_ID
    $Logon | Add-Member -MemberType NoteProperty -name SourcePort -value $source_port
	$Logon | Add-Member -MemberType NoteProperty -name SourceIP -value $source_address
    $Logon | Add-Member -MemberType NoteProperty -name ShareName -value $share_name
	$Logon | Add-Member -MemberType NoteProperty -name ObjectType -value $object_type
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id
 
    $Logon

} }

