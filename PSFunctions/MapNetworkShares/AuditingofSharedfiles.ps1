function Get-AuditingofSharedfiles {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )
$A = Get-WinEvent -FilterHashtable @{ Id=5145; Path = $Path } -ErrorAction SilentlyContinue

$A | ForEach-Object -process{
       
    $share_name = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Share Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	$relative_target = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Relative Target Name:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
    $source_address = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Source Address:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}
	$accesses = $_.Message.split([Environment]::NewLine)| Select-String -Pattern "(Accesses:)\t*(.*)" |ForEach-Object {$_.Matches[0].Groups[2].Value}

    $Logon = New-Object psobject
    $Logon | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
    $Logon | Add-Member -MemberType NoteProperty -name ShareName -value $share_name
    $Logon | Add-Member -MemberType NoteProperty -name RealtiveTarget -value $relative_target
    $Logon | Add-Member -MemberType NoteProperty -name SourceIP -value $source_address
    $Logon | Add-Member -MemberType NoteProperty -name Accesses -value $accesses
	$Logon | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

 
    $Logon

}}

