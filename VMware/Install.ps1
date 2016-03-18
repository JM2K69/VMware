$Folder = $PSScriptRoot
$Buildname = Split-Path -Leaf $Folder
$wshell = New-Object -comObject WScript.Shell
$Deskpath = $wshell.SpecialFolders.Item('Desktop')
$link = $wshell.CreateShortcut("$Deskpath\$Buildname.lnk")
$link.TargetPath = "$psHome\powershell.exe"
$link.Arguments = "-noexit -command $Folder\profile.ps1"
$link.Description = "$Buildname"
$link.WorkingDirectory = "$Folder"
$link.IconLocation = 'powershell.exe'
$link.Save()