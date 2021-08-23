
$Ans = Read-Host 'Now sending Cluster Status Report. Do you really want to proceed ?  Answer Yes or NO '

If ( $Ans -eq "Yes")
{
Write-host " Executing Script"
}
Else
{

Write-host " Good Bye"
Exit

}


$servers = @() # variable holds the list of primary cluster nodes.
$sessions = @() # Variable to store the powershell sessions.
$output = @() # varibale to store the output
$mydata = @()

$Style = "
<style>
    BODY{background-color:#white;}
    TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
    TH{border-width: 1px;padding: 3px;border-style: solid;border-color: black;background-color:#778899}
    TD{border-width: 1px;padding: 3px;border-style: solid;border-color: black;}  
</style>
"

$Servers = get-content D:\shrinath\XMIIserversPrimary.txt

$messageSubject = "xMII Cluster Resource Status Report"

$smtpto = “<shrinath.acharya@in.ibm.com>,<cce_wintel_support@wwpdl.vnet.ibm.com>"


$smtpfrom = “xmiiclusterreport@cokecce.com”

$SmtpServer = “mail.na.cokecce.com”

$message = New-Object System.Net.Mail.MailMessage $smtpfrom, $smtpto
$message.Subject = $messageSubject

$message.IsBodyHTML = $true

if ( $sessions.Count -ne 0  ) { remove-pssession -Session $sessions }

# create powershell session on each of the clusternode from the cluster. 

foreach ($server in $servers)
{

$sessions = $sessions + (New-PSSession $server)

}

# command to get the status of clusrer resource groups 

Invoke-Command -Session $sessions { $output = get-clustergroup }
$mydata = Invoke-Command -Session $sessions { $output} | select cluster,Name,ownernode,state 


#Email Function .

$message.Body = $mydata  | ConvertTo-Html -Head $style -PreContent '<h1><b><I> XMII Cluster Resource Group Status report</I></b></h1>' 

$smtp = New-Object Net.Mail.SmtpClient($smtpServer)

$smtp.Send($message)

# Disconnect all the connected sessions.

remove-pssession -Session $sessions
