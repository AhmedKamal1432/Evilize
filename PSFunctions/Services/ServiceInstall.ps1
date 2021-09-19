function Get-ServiceInstall {
    param(
        [Parameter(Mandatory=$true)]
        [String] $Path,
        [Parameter(Mandatory=$false)]
        [String] $LogID = "200"
    )

    $outItems = New-Object System.Collections.Generic.List[System.Object]
    $A = Get-WinEvent -FilterHashtable @{ Id=7045; Path = $Path }
	$global:ServiceInstallcount=0
    $A | ForEach-Object -process{
        $service = New-Object psobject
        $service | Add-Member -MemberType NoteProperty -name TimeCreated -value $_.TimeCreated
		$service | Add-Member -MemberType NoteProperty -name EventID -value $_.Id

         foreach($line in $_.message.Split([Environment]::NewLine)){
             if($line -Match ":"){
                $property, $data =$line.split(":")
                $data = $data -join ":"
                switch($property){
                    "Service Name" { $service| Add-Member -MemberType NoteProperty -name "ServiceName" -value $data ; break}
                    "Service File Name" {$service| Add-Member -MemberType NoteProperty -name "ServiceFileName" -value $data; break}
                    "Service Type" {$service| Add-Member -MemberType NoteProperty -name "ServiceType" -value $data; break}
                    "Service Start Type" {$service| Add-Member -MemberType NoteProperty -name "ServiceStartType" -value $data; break}
                }
             }
         }
         $outItems.Add($service)
		 $global:ServiceInstallcount++
        }
		
    $outItems.ToArray()
}
"Number of ServiceInstall events:"+ $ServiceInstallcount