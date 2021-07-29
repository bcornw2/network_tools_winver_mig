$servers = get-Content "~/temp/servers.txt"

$results = @()
foreach($server in $servers)
{
   ## $result = "" | Select ServerName
   ## $results = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ReleaseId

   $output = Get-WmiObject Win32_OperatingSystem -ComputerName $server | Select Caption,Version,BuildNumber ##Select-String -Pattern "H2"
   
   $out = $server + " - " + $output -replace "10240", "1507" -replace "10586", "1511" -replace "14393", "1607" `
                  -replace "15063", "1703" -replace "16299", "1709" -replace "17134", "1803" `
                  -replace "17763", "1809" -replace "18362", "1903" -replace "18363", "1909" `
                  -replace "19041", "2004" -replace "19042", "20H2" -replace "19043", "21H2" `
                  -replace "Caption", "OS: " -replace "BuildNumber=", "ReleaseID = "

   write-host $out
   $results += $out
   
}

Write-Host $results
Write-Host "\n"

$results | Out-File -FilePath "~/temp/OSVers.txt" 
