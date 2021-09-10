###
##
##
##
##Make user friendly input read-host -read-input - "What is file name", use env. variable for home (~)

$csv = import-CSV -path 'C:\Users\Benjamin Cornwell\temp\vdc_csv.csv'
$reqs = import-CSV -path 'C:\Users\Benjamin Cornwell\temp\AAR_Requests.csv'
Write-Host ""
write-host "please wait..." -ForeGroundColor Yellow
$groupNames = @("group1", "group2", "group3", "group4")
try{
    $membersLA = Get-ADGroupMember -Identity "group1" -Recursive | Get-ADUser -Properties Mail | Select-Object Mail
    Write-Host "ABR Users group populated..."
    $membersFI = Get-ADGroupMember -Identity "group2" -Recursive | Get-ADUser -Properties Mail | Select-Object Mail
    Write-Host "Internet Access group populated..."
    $membersRD = Get-ADGroupMember -Identity "group3" -Recursive | Get-ADUser -Properties Mail | Select-Object Mail
    Write-Host "Remote Desktop Users group populated..."
    $membersWE = Get-ADGroupMember -Identity "group4" -Recursive | Get-ADUser -Properties Mail | Select-Object Mail
    Write-Host "USB write group populated..."
    Write-Host "CHecking users... " -ForegroundColor Yellow
}
catch{ Write-Host "Proceeding..."}
$reqsHash = @{}

foreach($req in $reqs){
    if($req."Access Level" -eq "Local (PC) Administrator"){
        $a = "Local Admin, "
    } else {$a = ""}

    $reqsHash[$req."Created By" -replace "orgname_change\\",""] = $a+$req."Functionality Requested" -replace " – Full","" -Replace ",",", " -Replace "\[\]", ""
    #$reqsHash
}



foreach($item in $csv)
{
    Write-Host "emp:  $($item.Email)"
    $email = $($item.Email) -Replace " ", ""
    
    $email = Get-ADUser -Filter {EmailAddress -eq $email} -Properties EmailAddress | Select -ExpandProperty EmailAddress
    
    $name = Get-ADUser -Filter {EmailAddress -eq $email} -Properties EmailAddress | Select -ExpandProperty Name ##Select -ExpandProperty EmpID
    $name -replace "orgname_change\",""

    if($membersLA -match $email) {
            $item.Local_Admin = "Y"
            $item.Requests = $reqshash[$name]
            Write-Host = "User: $email is in group1 group"
        }else {$item.Local_Admin = ""}
    
    if($membersFI -match $email) {
            $item.Full_Internet = "Y"
            $item.Requests = $reqshash[$name]
            Write-Host = "User: $email is in group2 group"
        }else {$item.Full_Internet = ""}
    
    if($membersRD -match $email) {
            $item.RDP_Users = "Y"
            $item.Requests = $reqshash[$name]
            Write-Host = "User: $email is in group3 group"
        }else {$item.RDP_Users = ""}
    
    if($membersWE -match $email) {
            $item.USB_Write = "Y"
            $item.Requests = $reqshash[$name]
            Write-Host = "User: $email is in group4 group"
        }else {$item.USB_Write = ""}
    


    #Write-Host "RESULT: $item.$group" -ForegroundColor Cyan
    
}
    $csv | Export-CSV -Path "C:\Users\Benjamin Cornwell\temp\results_vdc.csv"
