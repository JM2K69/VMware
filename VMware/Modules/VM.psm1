<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.81
	 Created on:   	16/02/2016 12:11
	 Created by:   	Jerome
	 Organization: 	
	 Filename:     	VM.psm1
	-------------------------------------------------------------------------
	 Module Name: VM
	===========================================================================
#>





<#
	.SYNOPSIS
		PS C:\HidrationCM\PowerShell>New-HydraInfraVM -VMName DC01 -Disksize 90GB -Size L.
	
	.DESCRIPTION
		Create Virtual Machine into VMware Workstation for HydrationKit.
	
	.PARAMETER VMName
		Virtual Machine Name :
		DC01 - MDT01 - CM01 - PCA1
	
	.PARAMETER Disksize
		DiskSize = 90GB or 300GB
	
	.PARAMETER Size
		Config for Virtual Machine :
		
		'XS'  = 1vCPU, 512MB
		'S'   = 1vCPU, 768MB
		'M'   = 1vCPU, 1024MB
		'L'   = 2vCPU, 2048MB
		'XL'  = 2vCPU, 4096MB
		'TXL' = 4vCPU, 6144MB
		'XXL' = 4vCPU, 8192MB
		'XXL' = 4vCPU, 16384MB
		

	.PARAMETER Description
		A description of the Description parameter.
	
	.PARAMETER Path
		A description of the Path parameter.
	
	.NOTES
		Additional information about the function.
#>
function New-HydraInfraVM
{
	[CmdletBinding(DefaultParameterSetName = '1',
				   ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	[OutputType([psobject])]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateSet("DC01", "MDT01", "CM01", "PCA1", "PC001","PC002")]
		$VMName,
		[Parameter(Mandatory = $true)]
		[ValidateSet("90GB", "300GB")]
		$Disksize,
		[Parameter(Mandatory = $true)]
		[ValidateSet("M", "L", "XXL",'XXXL')]
		$Size,
		[Parameter(Mandatory = $true)]
		[ValidateSet("Domain Controller", "PC Admin", "SCCM Server", "MDT Server", "PC Client")]
		$Description,
		[Parameter(Mandatory = $true)]
		$Path
	)
	
	if (!(Test-Path -path $Path)){New-Item $Path -Type Directory | Out-Null }
		
	Switch ($VMName)
	{
		"DC01"
		{
			
			
			$path = (new-vmx -Type Server2012 -Firmware Bios -VMXName $VMName -Path $path).path
			$VM = New-VMXScsiDisk -NewDiskSize $Disksize -NewDiskname "$VMName.vmdk" -VMXName $VMName  -Path $path
			$VM = Add-VMXScsiDisk -Controller 0 -LUN 0  -Diskname "$VMName.vmdk" -VMXName $VMName -config "$path`\$VMName.vmx"
			$VM = Set-VMXNetworkAdapter -Adapter 0 -ConnectionType custom -AdapterType e1000e -config  "$path`\$VMName.vmx"
			$VM = Set-VMXVnet -Adapter 0 -Vnet vmnet2  -config "$path`\$VMName.vmx"
			$VM = Set-VMXDisplayName -DisplayName $VMName -config "$path`\$VMName.vmx"
			$VM = Connect-VMXcdromImage -VMXName $VMName -ISOfile C:\HydrationCM\ISO\HydrationCM.iso -config "$path`\$VMName.vmx"
			$VM = Set-VMXAnnotation -VMXName $VMName -config "$path`\$VMName.vmx" -builddate -Line1 $Description -Line2 "EDITIONS ENI"
			$VM = Set-VMXSize -VMXName $VMName -config "$path`\$VMName.vmx" -Size $Size -Path $path
			
			
		}
		"MDT01"
		{
			
			$path = (new-vmx -Type Server2012 -Firmware Bios -VMXName $VMName -Path $path).path
			$VM = New-VMXScsiDisk -NewDiskSize $Disksize -NewDiskname "$VMName.vmdk" -VMXName $VMName  -Path $path
			$VM = Add-VMXScsiDisk -Controller 0 -LUN 0  -Diskname "$VMName.vmdk" -VMXName $VMName -config "$path`\$VMName.vmx"
			$VM = Set-VMXNetworkAdapter -Adapter 0 -ConnectionType custom -AdapterType e1000e -config  "$path`\$VMName.vmx"
			$VM = Set-VMXVnet -Adapter 0 -Vnet vmnet2  -config "$path`\$VMName.vmx"
			$VM = Set-VMXDisplayName -DisplayName $VMName -config "$path`\$VMName.vmx"
			$VM = Connect-VMXcdromImage -VMXName $VMName -ISOfile C:\HydrationCM\ISO\HydrationCM.iso -config "$path`\$VMName.vmx"
			$VM = Set-VMXAnnotation -VMXName $VMName -config "$path`\$VMName.vmx" -builddate -Line1 $Description -Line2 "EDITIONS ENI"
			$VM = Set-VMXSize -VMXName $VMName -config "$path`\$VMName.vmx" -Size $Size -Path $path
		}
		"CM01"
		{
			
			$path = (new-vmx -Type Server2012 -Firmware Bios -VMXName $VMName -Path $path).path
			$VM = New-VMXScsiDisk -NewDiskSize $Disksize -NewDiskname "$VMName.vmdk" -VMXName $VMName  -Path $path
			$VM = Add-VMXScsiDisk -Controller 0 -LUN 0  -Diskname "$VMName.vmdk" -VMXName $VMName -config "$path`\$VMName.vmx"
			$VM = Set-VMXNetworkAdapter -Adapter 0 -ConnectionType custom -AdapterType e1000e -config  "$path`\$VMName.vmx"
			$VM = Set-VMXVnet -Adapter 0 -Vnet vmnet2  -config "$path`\$VMName.vmx"
			$VM = Set-VMXDisplayName -DisplayName $VMName -config "$path`\$VMName.vmx"
			$VM = Connect-VMXcdromImage -VMXName $VMName -ISOfile C:\HydrationCM\ISO\HydrationCM.iso -config "$path`\$VMName.vmx"
			$VM = Set-VMXAnnotation -VMXName $VMName -config "$path`\$VMName.vmx" -builddate -Line1 $Description -Line2 "EDITIONS ENI"
			$VM = Set-VMXSize -VMXName $VMName -config "$path`\$VMName.vmx" -Size $Size -Path $path
		}
		"PCA1"
		{
			
			$path = (new-vmx -Type Server2012 -Firmware Bios -VMXName $VMName -Path $path).path
			$VM = New-VMXScsiDisk -NewDiskSize $Disksize -NewDiskname "$VMName.vmdk" -VMXName $VMName  -Path $path
			$VM = Add-VMXScsiDisk -Controller 0 -LUN 0  -Diskname "$VMName.vmdk" -VMXName $VMName -config "$path`\$VMName.vmx"
			$VM = Set-VMXNetworkAdapter -Adapter 0 -ConnectionType custom -AdapterType e1000e -config  "$path`\$VMName.vmx"
			$VM = Set-VMXVnet -Adapter 0 -Vnet vmnet2  -config "$path`\$VMName.vmx"
			$VM = Set-VMXDisplayName -DisplayName $VMName -config "$path`\$VMName.vmx"
			$VM = Connect-VMXcdromImage -VMXName $VMName -ISOfile C:\HydrationCM\ISO\HydrationCM.iso -config "$path`\$VMName.vmx"
			$VM = Set-VMXAnnotation -VMXName $VMName -config "$path`\$VMName.vmx" -builddate -Line1 $Description -Line2 "EDITIONS ENI"
			$VM = Set-VMXSize -VMXName $VMName -config "$path`\$VMName.vmx" -Size $Size -Path $path
		}
		"PC001"
		{
			
			$path = (new-vmx -Type Server2012 -Firmware Bios -VMXName $VMName -Path $path).path
			$VM = New-VMXScsiDisk -NewDiskSize $Disksize -NewDiskname "$VMName.vmdk" -VMXName $VMName  -Path $path
			$VM = Add-VMXScsiDisk -Controller 0 -LUN 0  -Diskname "$VMName.vmdk" -VMXName $VMName -config "$path`\$VMName.vmx"
			$VM = Set-VMXNetworkAdapter -Adapter 0 -ConnectionType custom -AdapterType e1000e -config  "$path`\$VMName.vmx"
			$VM = Set-VMXVnet -Adapter 0 -Vnet vmnet2  -config "$path`\$VMName.vmx"
			$VM = Set-VMXDisplayName -DisplayName $VMName -config "$path`\$VMName.vmx"
			$VM = Connect-VMXcdromImage -VMXName $VMName -ISOfile C:\HydrationCM\ISO\HydrationCM.iso -config "$path`\$VMName.vmx"
			$VM = Set-VMXAnnotation -VMXName $VMName -config "$path`\$VMName.vmx" -builddate -Line1 $Description -Line2 "EDITIONS ENI"
			$VM = Set-VMXSize -VMXName $VMName -config "$path`\$VMName.vmx" -Size $Size -Path $path
		}
		"PC002"
		{
			
			$path = (new-vmx -Type Server2012 -Firmware Bios -VMXName $VMName -Path $path).path
			$VM = New-VMXScsiDisk -NewDiskSize $Disksize -NewDiskname "$VMName.vmdk" -VMXName $VMName -Path $path
			$VM = Add-VMXScsiDisk -Controller 0 -LUN 0 -Diskname "$VMName.vmdk" -VMXName $VMName -config "$path`\$VMName.vmx"
			$VM = Set-VMXNetworkAdapter -Adapter 0 -ConnectionType custom -AdapterType e1000e -config "$path`\$VMName.vmx"
			$VM = Set-VMXVnet -Adapter 0 -Vnet vmnet2 -config "$path`\$VMName.vmx"
			$VM = Set-VMXDisplayName -DisplayName $VMName -config "$path`\$VMName.vmx"
			$VM = Connect-VMXcdromImage -VMXName $VMName -ISOfile C:\HydrationCM\ISO\HydrationCM.iso -config "$path`\$VMName.vmx"
			$VM = Set-VMXAnnotation -VMXName $VMName -config "$path`\$VMName.vmx" -builddate -Line1 $Description -Line2 "EDITIONS ENI"
			$VM = Set-VMXSize -VMXName $VMName -config "$path`\$VMName.vmx" -Size $Size -Path $path
		}
		
	} #end switch
	Write-Host "Virtual Machine $VMName is now available in $Path"
}




<#
	.SYNOPSIS
		This function create Blank Virtual Machine for VMware Workstation
		PS C:\HidrationCM\PowerShell>New-HydraBlankVM -Prefix PC -Disksize 90GB -Number 2 -Size L
	
	.DESCRIPTION
		A detailed description of the New-Hidra_Blank_VM function.
	
	.PARAMETER Prefix
		Prefix Parameter is the prefix for the Virtual Machine Name.
	
	.PARAMETER Disksize
		DiskSize = 90GB or 300GB
	
	.PARAMETER Number
		Number of created Virtual Machine.
	
	.PARAMETER Size
		Config for Virtual Machine :
		
		'XS'  = 1vCPU, 512MB
		'S'   = 1vCPU, 768MB
		'M'   = 1vCPU, 1024MB
		'L'   = 2vCPU, 2048MB
		'XL'  = 2vCPU, 4096MB
		'TXL' = 4vCPU, 6144MB
		'XXL' = 4vCPU, 8192MB
		'XXXL' = 4vCPU, 16384MB
			
	.PARAMETER Path
		A description of the Path parameter.
	
	.EXAMPLE
		New-Hidra_Blank_VM -Prefix VM -Disksize 90GB -Number 5 -Size XL
		Create 5 Blank Virtual Machine with 2vCPU and 4Go Ram with 90GB disk
	
	.EXAMPLE
		New-Hidra_Blank_VM -Prefix VM -Disksize 300GB -Number 2 -Size M
		Create 2 Blank Virtual Machine with 1vCPU and 1Go Ram with 300GB disk
	
	.NOTES
		Additional information about the function.
#>
function New-HydraBlankVM
{
	[CmdletBinding(DefaultParameterSetName = '1',
				   ConfirmImpact = 'Medium',
				   SupportsShouldProcess = $true)]
	[OutputType([psobject])]
	param
	(
		[ValidateSet("VM")]
		$Prefix,
		[Parameter(Mandatory = $true)]
		[ValidateSet("90GB", "300GB")]
		$Disksize,
		[Parameter(Mandatory = $true)]
		[int]
		$Number,
		[Parameter(Mandatory = $true)]
		[ValidateSet("XS", "S", "M", "L", "XL", "TXL", "XXL","XXXL")]
		$Size,
		[Parameter(Mandatory = $true)]
		$Path
	)
	
	if (!(Test-Path -path $Path)) { New-Item $Path -Type Directory | Out-Null }
	
	Switch ($Prefix)
	{
		
		"VM"
		{
			
			1..$Number | % {
				$VMName = $Prefix + "{0:00}" -f $_
				$path1 = (new-vmx -Type Server2012 -Firmware Bios -VMXName $VMName -Path $path).path
				$VM = New-VMXScsiDisk -NewDiskSize $Disksize -NewDiskname "$VMName.vmdk" -VMXName $VMName  -Path $path1
				$VM = Add-VMXScsiDisk -Controller 0 -LUN 0  -Diskname "$VMName.vmdk" -VMXName $VMName -config "$path1`\$VMName.vmx"
				$VM = Set-VMXNetworkAdapter -Adapter 0 -ConnectionType custom -AdapterType e1000e -config  "$path1`\$VMName.vmx"
				$VM = Set-VMXVnet -Adapter 0 -Vnet vmnet2  -config "$path1`\$VMName.vmx"
				$VM = Set-VMXDisplayName -DisplayName $VMName -config "$path1`\$VMName.vmx"
				$VM = Connect-VMXcdromImage -VMXName $VMName -ISOfile C:\HydrationCM\ISO\HydrationCM.iso -config "$path1`\$VMName.vmx"
				$VM = Set-VMXAnnotation -VMXName $VMName -config "$path1`\$TargetVM.vmx" -builddate -Line1 "Blank Virtual Machine" -Line2 "EDITIONS ENI"
				$VM = Set-VMXSize -VMXName $VMName -config "$path1`\$VMName.vmx" -Size $Size -Path $path1
				
				Write-Host "Blank Virtual Machine $VMName is now available in $Path1"
			}
		}
		
	} #end switch
}

Export-ModuleMember New-HydraInfraVM
Export-ModuleMember New-HydraBlankVM




