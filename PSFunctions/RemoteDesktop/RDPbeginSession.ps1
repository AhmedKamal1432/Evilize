function Get-RDPbeginSession {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )

    $outItems = New-Object System.Collections.Generic.List[System.Object]
    $A = Get-WinEvent -FilterHashtable @{ Id=41; Path = $Path } -ErrorAction SilentlyContinue
	$global:RDPbeginSessioncount=0
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
                    
                }
             }
         }
         $outItems.Add($service)
		 $global:RDPbeginSessioncount++
        }
    $outItems.ToArray()
}
"Number of RDPbeginSession events:"+ $RDPbeginSessioncount
