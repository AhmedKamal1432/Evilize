function Get-RDPreconnected {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=4778; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{

    # Account, Domain, ID
    $_.Message.split([Environment]::NewLine)| Select-String -Pattern "Subject:" -Context 0,10 |ForEach-Object {
        $account_name = $_.Context.PostContext|Select-String -Pattern "(Account Name:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
        $account_domain = $_.Context.PostContext|Select-String -Pattern "(Account Domain:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
        $login_ID = $_.Context.PostContext|Select-String -Pattern "(Logon ID:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
	}
	
	

	$IP = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Client Address:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    $client_name = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Client Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    
    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name LogonUsername -value $account_name
    $Logon | Add-Member -MemberType NoteProperty -name AccountDomain -value $account_domain
    $Logon | Add-Member -MemberType NoteProperty -name SourceIP -value $IP
    $Logon | Add-Member -MemberType NoteProperty -name Sourcesystemname -value $client_name
    $Logon | Add-Member -MemberType NoteProperty -name LogonID -value $login_ID
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id
   
    $Logon
}
}


