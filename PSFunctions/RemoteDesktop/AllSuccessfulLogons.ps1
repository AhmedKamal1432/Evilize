function Get-AllSuccessfulLogons {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=4624; Path = $Path } -ErrorAction SilentlyContinue
$global:SuccessfullLogoncount = 0
$A | ForEach-Object -process{

    # Logon Type
    $logon_type = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Logon Type:).*([0-9]+)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	
       
    # Account, Domain, ID
    $_.Message.split([Environment]::NewLine)| Select-String -Pattern "New Logon:" -Context 0,10 |ForEach-Object {
        $account_name = $_.Context.PostContext|Select-String -Pattern "(Account Name:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
        $account_domain = $_.Context.PostContext|Select-String -Pattern "(Account Domain:)\t*(\w+)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
		$login_ID = $_.Context.PostContext|Select-String -Pattern "(Logon ID:)\t*(.*)" | ForEach-Object {$_.Matches[0].Groups[2].Value}
	}
	$Process_name = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Process Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    $IP = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Source Network Address:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    $Workstation = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Workstation Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	$auth_package= $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Authentication Package:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}

    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
	$Logon | Add-Member -MemberType NoteProperty -name LogonUsername -value $_.properties[5].value
	$Logon | Add-Member -MemberType NoteProperty -name AccountDomain -value $account_domain
	$Logon | Add-Member -MemberType NoteProperty -name LogonID -value $_.properties[7].value
    $Logon | Add-Member -MemberType NoteProperty -name LogonType -value $logon_type
	$Logon | Add-Member -MemberType NoteProperty -name AuthPackage -value $auth_package
	$Logon | Add-Member -MemberType NoteProperty -name SourceWorkstation -value $Workstation
	$Logon | Add-Member -MemberType NoteProperty -name ProcessName -value $Process_name
    $Logon | Add-Member -MemberType NoteProperty -name SourceIP -value $IP
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id
    
	

    $global:SuccessfullLogoncount++
    $Logon
}
}
"Successfull Logons: " + $SuccessfullLogoncount 
