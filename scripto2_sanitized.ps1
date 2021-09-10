##AD Group Membership Report Checker
##Please ensure you are connected to VPN, or on the M.C. Dean network before beginning. 

##test connection
Write-Host "Which AD Group to Audit?"
Write-Host "1.) Systems / AD Administrators"
Write-Host "2.) Database Administrators"
Write-Host "3.) Network Administrators"
Write-Host "4.) Network Monitoring"
Write-Host "5.) Application Administrators"
Write-Host "6.) Application Developers"
Write-Host "7.) Local Admins"
Write-host "8.) Full Internet Access"
Write-host "9.) Remote Desktop Users"
write-Host "0.) All Groups - RDP, ABR, Internet Full"
$input = Read-Host "Which AD group would you like to report on?"


    $groupNames

switch($input) {
    "1" {$groupName="group1"; $fileName="Systems_AD_Administrators"}
    "2" {$groupName="group2"; $fileName="Database_Administrators"}
    "3" {$groupName="group3"; $fileName="Network_Administrators"}
    "4" {$groupName="group4"; $fileName="Network_Monitoring"}
    "5" {$groupName="group5"; $fileName="Application_Administrators"}
    "6" {$groupName=""; $fileName="Application_Administrators"}
    "7" {$groupName="group6"; $fileName="local_admins $groupName"}
    "8" {$groupName="group7"; $fileName="Full_Internet_Access"}
    "9" {$groupName="group8"; $filename="Remote_Desktop_users"}
    "0" {$groupNames="groupA", "groupB", "groupC", "groupD", "groupE", "groupF", "groupG", "groupH", "groupI"}
    }

    
    # ===========================================

    foreach ($groupName in $groupNames){

        get-adgroupmember -identity $groupName -recursive | Where-Object { $_.ObjectClass -eq 'user' } -ErrorAction SilentlyContinue| Get-AdUser `
    -Properties samaccountname, name, mail, EmployeeNumber, Department, Office, Title, Manager |Select SAMAccountName, Name, Title, Department, `
    Office, @{name='ManagerName';expression={(Get-ADUser -Identity $_.manager | Select-Object -ExpandProperty `
    name)}},@{name='ManagerEmailAddress';expression={(Get-ADUser -Identity $_.manager -Properties emailaddress `
    | Select-Object -ExpandProperty emailaddress)}} | Export-CSV -Path "C:\Users\Benjamin Cornwell\temp\$groupName.csv" 
    
        $users = Get-ADGroupMember -Identity $groupName
        $count = $users.count
        Write-Host "User count for group: " -NoNewLine
        Write-Host $groupName -ForegroundColor Yellow -NoNewLine
        Write-Host ": $count" -ForegroundColor White
        #if($input -eq "0"){
          #  write-host "All user counts saved to self-named .csv files in C:\Users\Benjamin Cornwell\temp\" -ForegroundColor Cyan   
      #  }
        }

        #Moniter Lizerd, or Monitor Lizord for cryptoAPI name.. written in python, probably, if there is no native java or C++ library.