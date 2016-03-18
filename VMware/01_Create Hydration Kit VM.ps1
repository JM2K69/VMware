
New-HydraInfraVM -VMName CM01 -Disksize 300GB -Size XXXL -Description 'SCCM Server' -Path 'c:\virtual Machines'
New-HydraInfraVM -VMName DC01 -Disksize 90GB -Size L -Description 'Domain Controller' -Path 'c:\virtual Machines'
New-HydraInfraVM -VMName MDT01 -Disksize 300GB -Size L -Description 'MDT Server' -Path 'c:\virtual Machines'
New-HydraInfraVM -VMName PC001 -Disksize 90GB -Size M -Description 'PC Client' -Path 'c:\virtual Machines'
New-HydraInfraVM -VMName PC002 -Disksize 90GB -Size M -Description 'PC Client' -Path 'c:\virtual Machines'
New-HydraInfraVM -VMName PCA1 -Disksize 90GB -Size L -Description   'PC Admin' -Path 'c:\virtual Machines'


Show-BalloonTip -Text "All Virtual machine are available" -Icon Info -Timeout 10 -Title "Hydration Kit VM"
