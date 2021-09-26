function Get-RDPShellSessionReconnectedSucceeded{
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )

    $outItems = New-Object System.Collections.Generic.List[System.Object]
    $A = Get-WinEvent -FilterHashtable @{ Id=25; Path = $Path } -ErrorAction SilentlyContinue
	
    $A | ForEach-Object -process{
        $service = New-Object psobject
        $service | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
		$service | Add-Member -MemberType NoteProperty -name EventID -value $_.Id
         foreach($line in $_.message.Split([Environment]::NewLine)){
             if($line -Match ":"){
                $property, $data =$line.split(":")
                $data = $data -join ":"
                switch($property){
                    "User" { $service| Add-Member -MemberType NoteProperty -name "LogonUserName" -value $data ; break}
                    "Source Network Address" {$service| Add-Member -MemberType NoteProperty -name "SourceIP" -value $data; break}
                    "Session ID" {$service| Add-Member -MemberType NoteProperty -name "SessionID" -value $data; break}
                }
             }
         }
		
         $outItems.Add($service)
        }
		
    $outItems.ToArray()
}

