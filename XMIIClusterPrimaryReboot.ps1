
$Ans = Read-Host 'Be Carefull.By running this script, You are rebooting all the xMII Primary Cluster Nodes. Do you really want to proceed ?  Answer Yes or NO '

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





$Servers = get-content D:\shrinath\XMIIserversPrimary.txt


# create powershell session on each of the clusternode from the cluster. 

foreach ($server in $servers)
{

$sessions = $sessions + (New-PSSession $server)

}

Write-host " Rebooting Servers"

Invoke-Command -Session $sessions { restart-computer -Force }

Write-host " Reboot Completed "

remove-pssession -Session $sessions
