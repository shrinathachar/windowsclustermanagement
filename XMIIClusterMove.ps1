
$Ans = Read-Host 'Be Carefull.This will do the cluster resource failover on all the xMII nodes. Do you really want to proceed ?  Answer Yes or NO '

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

if ( $sessions.Count -ne 0  ) { remove-pssession -Session $sessions }



$Servers = get-content D:\shrinath\XMIIserversPrimary.txt

# create powershell session on each of the clusternode from the cluster. 

Write-host " Creating Powershell Remote sessions"

foreach ($server in $servers)
{

$sessions = $sessions + (New-PSSession $server)

}

Write-host " Starting Cluster Resource Move "

Invoke-Command -Session $sessions { get-cluster | get-clustergroup | move-clustergroup }
Write-host " Move Completed "

# remove-pssession -Session $sessions
