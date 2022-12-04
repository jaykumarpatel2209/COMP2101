# Lab-3

Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | Select-Object Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | Format-Table