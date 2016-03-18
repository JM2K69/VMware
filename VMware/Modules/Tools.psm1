<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.99
	 Created on:   	06/02/2016 20:55
	 Created by:   	Jerome Bezet-Torres
	 Organization: 	
	 Filename:     	Tools.psm1
	-------------------------------------------------------------------------
	 Module Name: Tools
	===========================================================================
#>
function Receive-ToolsBitsFile
{
	param ([string]$DownLoadUrl,
		[string]$destination)
	$ReturnCode = $True
	if (!(Test-Path $Destination))
	{
		Try
		{
			if (!(Test-Path (Split-Path $destination)))
			{
				New-Item -ItemType Directory -Path (Split-Path $destination) -Force
			}
			Write-verbose "Starting Download of $DownLoadUrl"
			Start-BitsTransfer -Source $DownLoadUrl -Destination $destination -DisplayName "Getting $destination" -Priority Foreground -Description "From $DownLoadUrl..." -ErrorVariable err
			If ($err) { Throw "" }
			
		}
		Catch
		{
			$ReturnCode = $False
			Write-Verbose " - An error occurred downloading `'$FileName`'"
			Write-Error $_
		}
	}
	else
	{
		Write-Verbose "No download needed, file exists"
	}
	return $ReturnCode
}

function Receive-ADK10
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('ADK10_RTM', 'ADK10_1511')]
		$ADK,
		[ValidateSet('C:\HydrationCM\Source\Downloads')][String]$Destination,
		[String]$Product_Dir = "ADK10",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$ADK10_RTM = "http://download.microsoft.com/download/8/1/9/8197FEB9-FABE-48FD-A537-7D8709586715/adk/adksetup.exe"
	$ADK10_1511 = "http://download.microsoft.com/download/3/8/B/38BBCA6A-ADC9-4245-BCD8-DAA136F63C8B/adk/adksetup.exe"
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $ADK"
	Switch ($ADK)
	{
		"ADK10_RTM"
		{
			$ADK_BASEVER = $ADK
			$ADK_BASEDir = Join-Path $Product_Dir $ADK_BASEVER
			if (!(Test-Path "$ADK_BASEVER\ADK10_RTM\adksetup.exe"))
			{
				foreach ($url in ($ADK10_RTM))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $ADK_BASEDir"
					if (!(test-path  "$ADK_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download $ADK" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$ADK_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$ADK_BASEDir\$FileName"
					}
				}
				If ($DownloadContent.ispresent)
				{
					Write-Host "Download $ADK Installation"
					$FileName = Split-Path -Leaf $ADK10_RTM
					Show-BalloonTip -Text "Download Full $ADK" -Icon Info -Timeout 10 -Title "Downloading..."
					Start-Process "$ADK_BASEDir\$FileName" -ArgumentList "/quiet /Layout $ADK_BASEDir" -Wait
				}
			}
			
		}
		"ADK10_1511"
		{
			$ADK_BASEVER = $ADK
			$ADK_BASEDir = Join-Path $Product_Dir $ADK_BASEVER
			if (!(Test-Path "$ADK_BASEVER\ADK10_1511\adksetup.exe"))
			{
				foreach ($url in ($ADK10_1511))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $ADK_BASEDir"
					if (!(test-path  "$ADK_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download $ADK" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$ADK_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$ADK_BASEDir\$FileName"
					}
				}
				If ($DownloadContent.ispresent)
				{
					Write-Verbose "Download $ADK Installation"
					$FileName = Split-Path -Leaf $ADK10_1511
					Show-BalloonTip -Text "Download Full $ADK" -Icon Info -Timeout 10 -Title "Downloading..."
					Start-Process "$ADK_BASEDir\$FileName" -ArgumentList "/quiet /Layout $ADK_BASEDir" -Wait
				}
			}
			
		}
		
	} #end switch
	Show-BalloonTip -Text "$ADK is now available in $ADK_BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
	
}

function Receive-MDTFiles
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('MDT2013U1', 'MDT2013U2')]
		$MDTVersions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "MDTFiles",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$MDT2013U1_F1 = "https://download.microsoft.com/download/0/D/E/0DE81822-D03F-4075-93B6-DDEAA0E095F7/MicrosoftDeploymentToolkit2013_x64.msi"
	$MDT2013U1_F2 = "https://download.microsoft.com/download/0/D/E/0DE81822-D03F-4075-93B6-DDEAA0E095F7/MicrosoftDeploymentToolkit2013_x86.msi"
	$MDT2013U2_F1 = "https://download.microsoft.com/download/3/0/1/3012B93D-C445-44A9-8BFB-F28EB937B060/MicrosoftDeploymentToolkit2013_x64.msi"
	$MDT2013U2_F2 = "https://download.microsoft.com/download/3/0/1/3012B93D-C445-44A9-8BFB-F28EB937B060/MicrosoftDeploymentToolkit2013_x86.msi"
		
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $MDTVersions"
	Switch ($MDTVersions)
	{
		"MDT2013U1"
		{
			$MDT_BASEVER = $MDTVersions
			$MDT_BASEDir = Join-Path $Product_Dir $MDT_BASEVER
			if (!(Test-Path "$MDT_BASEVER\2013U1\MicrosoftDeploymentToolkit2013_x64.msi"))
			{
				foreach ($url in ($MDT2013U1_F1, $MDT2013U1_F2))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $MDT_BASEDir"
					if (!(test-path  "$MDT_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download $MDTVersions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$MDT_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$MDT_BASEDir\$FileName"
					}
				}
			}
			
		}
		"MDT2013U2"
		{
			$MDT_BASEVER = $MDTVersions
			$MDT_BASEDir = Join-Path $Product_Dir $MDT_BASEVER
			if (!(Test-Path "$MDT_BASEVER\2013U1\MicrosoftDeploymentToolkit2013_x64.msi"))
			{
				foreach ($url in ($MDT2013U2_F1, $MDT2013U2_F2))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $MDT_BASEDir"
					if (!(test-path  "$MDT_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download $MDTVersions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$MDT_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$MDT_BASEDir\$FileName"
					}
				}
				
			}
			
		}
		
	} #end switch
	Show-BalloonTip -Text "$MDTVersions is now available in $MDT_BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
	
}

function Receive-SQL
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('2014SP1')]
		$SQLVersions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "SQLSERVER",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$SQLFile = "http://care.dlservice.microsoft.com/dl/download/2/F/8/2F8F7165-BB21-4D1E-B5D8-3BD3CE73C77D/SQLServer2014SP1-FullSlipstream-x64-ENU.iso"
	
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $SQLFile"
	Switch ($SQLVersions)
	{
		"2014SP1"
		{
			$SQL_BASEVER = $SQLVersions
			$SQL_BASEDir = Join-Path $Product_Dir $SQL_BASEVER
			if (!(Test-Path "$MDT_BASEVER\2014SP1\SQLServer2014SP1-FullSlipstream-x64-ENU.iso"))
			{
				foreach ($url in ($SQLFile))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $SQL_BASEDir"
					if (!(test-path  "$SQL_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download SQL $SQLVersions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$SQL_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$SQL_BASEDir\$FileName"
					}
				}
			}
			
		}
		
		
	} #end switch
	Show-BalloonTip -Text "$SQLVersions is now available in $SQL_BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
	
}

function Receive-SCCM
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('CurrentBranch')]
		$SCCMVersions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "SCCM",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$SCCMFile = "http://care.dlservice.microsoft.com/dl/download/E/F/3/EF388C92-F307-42B7-989F-FF4DA328B328/SC_Configmgr_1511.exe"
	
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $SCCMFile"
	Switch ($SCCMVersions)
	{
		"CurrentBranch"
		{
			$SCCM_BASEVER = $SCCMVersions
			$SCCM_BASEDir = Join-Path $Product_Dir $SCCM_BASEVER
			if (!(Test-Path "$SCCM_BASEVER\CurrentBranch\SC_Configmgr_1511.exe"))
			{
				foreach ($url in ($SCCMFile))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $SCCM_BASEDir"
					if (!(test-path  "$SCCM_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download SCCM $SCCMVersions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$SCCM_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$SCCM_BASEDir\$FileName"
					}
				}
			}
			
		}
		
		
	} #end switch
	Show-BalloonTip -Text "$SCCMVersions is now available in $SCCM_BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
}

function Receive-SRV2012R2
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('2012R2EVAL')]
		$OSVersions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "OS",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$OSFile = "http://care.dlservice.microsoft.com/dl/download/F/D/2/FD241849-F219-40ED-B65C-64D274A6B46F/9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_FR-FR-IR3_SSS_X64FREE_FR-FR_DV9.ISO"
	
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $OSFile"
	Switch ($OSVersions)
	{
		"2012R2EVAL"
		{
			$OS_BASEVER = $OSVersions
			$OS_BASEDir = Join-Path $Product_Dir $OS_BASEVER
			if (!(Test-Path "$SCCM_BASEVER\2012R2EVAL\9600.17050.WINBLUE_REFRESH.140317-1640_X64FRE_SERVER_EVAL_FR-FR-IR3_SSS_X64FREE_FR-FR_DV9.ISO"))
			{
				foreach ($url in ($OSFile))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $OS_BASEDir"
					if (!(test-path  "$OS_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download Windows Server 2012R2" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$OS_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$OSCM_BASEDir\$FileName"
					}
				}
			}
			
		}
		
		
	} #end switch
	Show-BalloonTip -Text "$OSVersions is now available in $OS_BASEDir"  -Icon Info -Timeout 10 -Title "Download Finish"
}

function Receive-Windows10
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('Win10LSTBEVAL','Win101511EVAL')]
		$OSVersions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "OS",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$OSFile = "http://care.dlservice.microsoft.com/dl/download/6/2/4/62401377-7CCD-4AB9-B31F-D60C3CC38257/10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_FR-FR.ISO"
	$OSfile1 = "http://care.dlservice.microsoft.com/dl/download/8/5/C/85CA9FB3-CC7F-44FD-A352-EF960FC181AD/10586.0.151029-1700.TH2_RELEASE_CLIENTENTERPRISEEVAL_OEMRET_X64FRE_FR-FR.ISO"
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $OSFile"
	Switch ($OSVersions)
	{
		"Win10LSTBEVAL"
		{
			$OS_BASEVER = $OSVersions
			$OS_BASEDir = Join-Path $Product_Dir $OS_BASEVER
			if (!(Test-Path "$SCCM_BASEVER\Win10LSTBEVAL\10240.16384.150709-1700.TH1_CLIENTENTERPRISE_S_EVAL_X64FRE_FR-FR.ISO"))
			{
				foreach ($url in ($OSFile))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $OS_BASEDir"
					if (!(test-path  "$OS_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download Windows Windows 10 LSTB" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$OS_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$OSCM_BASEDir\$FileName"
						Show-BalloonTip -Text "Windows Windows 10 LSTB is now available in $OS_BASEDir" -Icon Info -Timeout 10 -Title "Downloading..."
						
					}
				}
			}
			
		}
		
		"Win101511EVAL"
		{
			$OS_BASEVER = $OSVersions
			$OS_BASEDir = Join-Path $Product_Dir $OS_BASEVER
			if (!(Test-Path "$SCCM_BASEVER\Win101511EVAL\10586.0.151029-1700.TH2_RELEASE_CLIENTENTERPRISEEVAL_OEMRET_X64FRE_FR-FR.ISO"))
			{
				foreach ($url in ($OSFile1))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $OS_BASEDir"
					if (!(test-path  "$OS_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download Windows Windows 10 1511" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$OS_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$OSCM_BASEDir\$FileName"
						Show-BalloonTip -Text "Windows Windows 10 1511 is now available in $OS_BASEDir" -Icon Info -Timeout 10 -Title "Downloading..."
						
					}
				}
			}
			
		}
		
		
	} #end switch
}


function Receive-BGinfo
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('Current')]
		$BginfoVersions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "BGINFO",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$BGinfoFile = "http://live.sysinternals.com/Bginfo.exe"
	
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $BGinfoFile"
	Switch ($BginfoVersions)
	{
		"Current"
		{
			$BGinfo_BASEVER = $BginfoVersions
			$BGinfo_BASEDir = Join-Path $Product_Dir $BGinfo_BASEVER
			if (!(Test-Path "$BGinfo_BASEVER\Current\Bginfo.exe"))
			{
				foreach ($url in ($BGinfoFile))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BGinfo_BASEDir"
					if (!(test-path  "$BGinfo_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download BGinfo" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BGinfo_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BGinfo_BASEDir\$FileName"
					}
				}
			}
			
		}
		
		
	} #end switch

	Show-BalloonTip -Text "BGinfo is now available in $BGinfo_BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
	
}

function Receive-Windows10ADMX
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('Current')]
		$AdmxVersions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "Windows_10_ADMX_Templates",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$ADMXFile = "https://download.microsoft.com/download/2/E/3/2E3A1E42-8F50-4396-9E7E-76209EA4F429/Windows10-ADMX.msi"
	
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $ADMXFile"
	Switch ($AdmxVersions)
	{
		"Current"
		{
			$ADMX_BASEVER = $AdmxVersions
			$ADMX_BASEDir = Join-Path $Product_Dir $ADMX_BASEVER
			if (!(Test-Path "$ADMX_BASEVER\Current\Windows10-ADMX.msi"))
			{
				foreach ($url in ($ADMXFile))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $ADMX_BASEDir"
					if (!(test-path  "$ADMX_BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download Windows 10 AMDX" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$ADMX_BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$ADMX_BASEDir\$FileName"
					}
				}
			}
			
		}
		
		
	} #end switch
	Show-BalloonTip -Text "Windows 10 ADMX Templates is now available in $ADMX_BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
	
	
}
function Receive-VisualC
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('2005', '2008', '2010', '2012', '2013', '2015', 'ALL')]
		$Versions,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "VisualC++",
		[String]$Prereq = "prereq"
		
	)
	$2005Files = ("http://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.exe", "http://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.exe")
	$2008Files = ("http://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x86.exe", "http://download.microsoft.com/download/5/D/8/5D8C65CB-C849-4025-8E95-C3966CAFD8AE/vcredist_x64.exe")
	$2010Files = ("http://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x86.exe", "http://download.microsoft.com/download/1/6/5/165255E7-1014-4D0A-B094-B6A430A6BFFC/vcredist_x64.exe")
	$2012Files = ("http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x86.exe", "http://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4/vcredist_x64.exe")
	$2013Files = ("http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x86.exe", "http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe")
	$2015Files = ("http://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x86.exe", "http://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe")
	
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $2005Files"
	Switch ($Versions)
	{
		"2005"
		{
			$BASEVER = $Versions
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\2005\vcredist_x86.exe"))
			{
				foreach ($url in ($2005Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download C++ $Versions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\$FileName"
						Show-BalloonTip -Text " Microsoft Visual C++ 2005 is now available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
						
					}
				}
			}
			
		}
		"2008"
		{
			$BASEVER = $Versions
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\2008\vcredist_x86.exe"))
			{
				foreach ($url in ($2008Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download C++ $Versions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\$FileName"
						Show-BalloonTip -Text " Microsoft Visual C++ 2008 is now available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
						
					}
				}
			}
			
		}
		"2010"
		{
			$BASEVER = $Versions
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\2010\vcredist_x86.exe"))
			{
				foreach ($url in ($2010Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download C++ $Versions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\$FileName"
						Show-BalloonTip -Text " Microsoft Visual C++ 2010 is now available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
						
					}
				}
			}
			
		}
		"2012"
		{
			$BASEVER = $Versions
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\2012\vcredist_x86.exe"))
			{
				foreach ($url in ($2012Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download C++ $Versions"  -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\$FileName"
						Show-BalloonTip -Text " Microsoft Visual C++ 2012 is now available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
						
					}
				}
			}
			
		}
		"2013"
		{
			$BASEVER = $Versions
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\2013\vcredist_x86.exe"))
			{
				foreach ($url in ($2013Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download C++ $Versions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\$FileName"
						Show-BalloonTip -Text " Microsoft Visual C++ 2013 is now available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
						
					}
				}
			}
			
		}
		"2015"
		{
			$BASEVER = $Versions
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\2015\vcredist_x86.exe"))
			{
				foreach ($url in ($2015Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						Show-BalloonTip -Text " Trying Download C++ $Versions" -Icon Info -Timeout 10 -Title "Downloading..."
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\$FileName"
						Show-BalloonTip -Text " Microsoft Visual C++ 2015 is now available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
						
					}
				}
			}
			
		}
		"ALL"
		{
			$BASEVER = $Versions
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\ALL\vcredist_x86.exe"))
			{
				foreach ($url in ($2015Files))
				{
					Show-BalloonTip -Text "Download All Visual C++ Runtime" -Icon Info -Timeout 10 -Title "Downloading..."
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\2015\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\2015\$FileName"
						
					}
				}
				foreach ($url in ($2012Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\2012\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\2012\$FileName"
						
					}
				}
				foreach ($url in ($2013Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\2013\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\2013\$FileName"
						
					}
				}
				foreach ($url in ($2010Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\2010\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\2010\$FileName"
						
					}
				}
				foreach ($url in ($2008Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\2008\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\2008\$FileName"
						
					}
				}
				foreach ($url in ($2005Files))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BASEDir\$FileName"))
					{
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\2005\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							
							exit
						}
						Unblock-File "$BASEDir\2005\$FileName"
						
					}
				}
			}
			
		}
	
	} #end switch
	Show-BalloonTip -Text " All Microsoft Visual C++ are now  available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"
	
}

function Receive-RSAT
{
	[CmdletBinding(DefaultParametersetName = "1",
				   SupportsShouldProcess = $true,
				   ConfirmImpact = "Medium")]
	[OutputType([psobject])]
	param (
		[ValidateSet('x64')]
		$Architecture,
		[ValidateSet('C:\HydrationCM\Source\Downloads')]
		[String]$Destination,
		[String]$Product_Dir = "RSAT10",
		[String]$Prereq = "prereq",
		[switch]$DownloadContent,
		[switch]$force
	)
	$File = "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/WindowsTH-KB2693643-x64.msu"
	
	$Product_Dir = Join-Path $Destination $Product_Dir
	Write-Verbose "Destination: $Product_Dir"
	if (!(Test-Path $Product_Dir))
	{
		Try
		{
			Write-Verbose "Trying to create $Product_Dir"
			$NewDirectory = New-Item -ItemType Directory -Path "$Product_Dir" -ErrorAction Stop -Force
		}
		catch
		{
			Write-Verbose "Could not create Destination Directory $Product_Dir"
			break
		}
	}
	$Prereq_Dir = Join-Path $Destination $Prereq
	Write-Verbose "Prereq = $Prereq_Dir"
	Write-Verbose "We are now going to Test $File"
	Switch ($Architecture)
	{
		"x64"
		{
			$BASEVER = $Architecture
			$BASEDir = Join-Path $Product_Dir $BASEVER
			if (!(Test-Path "$BASEVER\x64\WindowsTH-KB2693643-x64.msu"))
			{
				foreach ($url in ($File))
				{
					$FileName = Split-Path -Leaf -Path $Url
					Write-Verbose "Testing $FileName in $BASEDir"
					if (!(test-path  "$BBASEDir\$FileName"))
					{
						
						Show-BalloonTip -Text " Trying Download RSAT Windows 10" -Icon Info -Timeout 10 -Title "Downloading..."
						
						if (!(Receive-ToolsBitsFile -DownLoadUrl $URL -destination "$BASEDir\$FileName"))
						{
							Show-BalloonTip -Text " Error Donwloading File $url , Please check connectivity" -Icon Error -Timeout 10 -Title "Downloading..."
							exit
						}
						Unblock-File "$BASEDir\$FileName"
					}
				}
			}
			
		}
		
		
	} #end switch
	Show-BalloonTip -Text "RSAT Windows 10 is now available in $BASEDir" -Icon Info -Timeout 10 -Title "Download Finish"

}

function Show-BalloonTip
{
	
	[CmdletBinding(SupportsShouldProcess = $true)]
	param
	(
		[Parameter(Mandatory = $true)]
		$Text,
		[Parameter(Mandatory = $true)]
		$Title,
		[ValidateSet('None', 'Info', 'Info', 'Error')]
		$Icon = 'Info',
		$Timeout = 10
	)
	
	Add-Type -AssemblyName System.Windows.Forms
	
	if ($script:balloon -eq $null)
	{
		$script:balloon = New-Object System.Windows.Forms.NotifyIcon
	}
	
	$path = Get-Process -id $pid | Select-Object -ExpandProperty Path
	$balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
	$balloon.BalloonTipIcon = $Icon
	$balloon.BalloonTipText = $Text
	$balloon.BalloonTipTitle = $Title
	$balloon.Visible = $true
	
	$balloon.ShowBalloonTip($Timeout)
}

