# Lab 4

# Point-1
function Get-ComputerSystemDetails {
	Write-Output "********** Point 1 **********"
	Get-CimInstance Win32_ComputerSystem | Select-Object Description | Format-List
}

# Point-2
function Get-OperatingSystemDetails {
	Write-Output "********** Point 2 **********"
	Get-CimInstance Win32_OperatingSystem | Select-Object Name,Version | Format-List
}

# Point-3
function Get-ProcessorDetails {
	Write-Output "********** Point 3 **********"
	Get-CimInstance Win32_Processor | Select-Object Description,MaxClockSpeed,NumberOfCores,L2CacheSize,L3CacheSize | Format-List
}

# Point-4
function Get-PhysicalMemDetails {
	Write-Output "********** Point 4 **********"
	$physicalmemories = Get-CimInstance Win32_PhysicalMemory | Select-Object Manufacturer,Description,Capacity,BankLabel,DeviceLocator
	$physicalmemories | Format-Table
	$totalRam = 0
	foreach($physicalMemory in $physicalmemories) {
		$totalRam += $physicalMemory.Capacity
	}
	$total = $totalRam / 1gb
	Write-Output "RAM Size : $total GB"
}

# Point-5
function Get-SystemDiskDetails {
	Write-Output "********** Point 5 **********"
	$diskdrives = Get-CimInstance CIM_DiskDrive
	foreach($disk in $diskdrives) {
		$partitions = $disk | Get-CimAssociatedInstance -ResultClassName CIM_diskpartition
		foreach($partition in $partitions) {
			$logicaldisks = $partition | Get-CimAssociatedInstance -ResultClassName CIM_logicaldisk
			foreach($logicaldisk in $logicaldisks) {
				New-Object -TypeName psobject -Property @{Vendor=$disk.Manufacturer
									  Model=$disk.Model
									  "Logical Disk Size(GB)"=$logicaldisk.Size / 1gb -as [int]
									  "Free Space(GB)"=$logicaldisk.FreeSpace / 1gb -as [int]
									  "Percentage Free(GB)"=( $logicaldisk.FreeSpace / $logicaldisk.Size ) * 100 -as [float]
									}
			}
		}
	}
}

# Point-6
function Get-NetworkAdapterDetails {
	Write-Output "********** Point 6 **********"
	Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | Select-Object Description,Index,IPAddress,IPSubnet,DNSDomain,DNSServerSearchOrder | Format-Table
}

# Point-7
function Get-VideoControllerDetails {
	Write-Output "********** Point 7 **********"
	$tempObject = Get-CimInstance Win32_VideoController | Select-Object Caption,Description,CurrentHorizontalResolution,CurrentVerticalResolution
	$HorizontalResolution = $tempObject.CurrentHorizontalResolution
	$VerticalResolution = $tempObject.CurrentVerticalResolution
	$result = "$HorizontalResolution x $VerticalResolution"
	New-Object -Typename psobject -Property @{Vendor=$tempObject.Caption
						  Description=$tempObject.Description
						  "Current Screen Resolution is"=$result
						}
}

# Calling each function from here and in some case formatting as well.
Get-ComputerSystemDetails
Get-OperatingSystemDetails
Get-ProcessorDetails
Get-PhysicalMemDetails
$result = Get-SystemDiskDetails
$result | Format-Table
Get-NetworkAdapterDetails
$result = Get-VideoControllerDetails
$result | Format-List