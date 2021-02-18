
#region use credentials
$ErrorActionPreference="Silentlycontinue"
$Start = Get-Date
$UserName = "SQLJenkins"
$VMMUserName = "scinframanagement"
$MDTUserName = "mdtdeploy"
$LocalAdminUser = "Administrator"


Try
{
    Write-Host "Obtaining Secure credentials for SQLJenkins" -ForegroundColor Yellow
    $TP = Test-Path "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SQLJenkins\SQLJenkins.txt"
    IF (!($TP))
    {
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SQLJenkins\SQLJenkins.txt" -Verbose
        Exit 1
    }
    $PasswordFile = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SQLJenkins\SQLJenkins.txt"
    $KeyFile = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SQLJenkins\SQLJenkins.key"
    $key = Get-Content $KeyFile
    $MyCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserName, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)
    $SecurePassword = $MyCredential.Password
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}
Try
{
    Write-Host "Obtaining Secure credentials for SCInframanagment" -ForegroundColor Yellow
    $TP = Test-Path "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SCinframanagement\SCinframanagement.txt"
    IF (!($TP))
    {
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SQLJenkins\SCinframanagement.txt" -Verbose
        Exit 1
    }
    $PasswordFile1 = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SCinframanagement\SCinframanagement.txt"
    $KeyFile1 = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SCinframanagement\SCinframanagement.key"
    $key1 = Get-Content $KeyFile1
    $MyCredential1 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sproutcloud\$VMMUserName", (Get-Content $PasswordFile1 | ConvertTo-SecureString -Key $key1)
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}
Try
{
    Write-Host "Obtaining Secure credentials for MDTDeploy" -ForegroundColor Yellow
    $TP = Test-Path "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\MDTDeploy\MDTDeploy.txt"
    IF (!($TP))
    {
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SQLJenkins\MDTDeploy.txt" -Verbose
        Exit 1
    }
    $PasswordFile2 = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\MDTDeploy\MDTDeploy.txt"
    $KeyFile2 = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\MDTDeploy\MDTDeploy.key"
    $key2 = Get-Content $KeyFile2
    $MyCredential2 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sproutcloud\$MDTUserName", (Get-Content $PasswordFile2 | ConvertTo-SecureString -Key $key2)
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}
Try
{
    Write-Host "Obtaining Secure credentials for Administrator" -ForegroundColor Yellow
    $TP = Test-Path "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\administrator\administrator.txt"
    IF (!($TP))
    {
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SQLJenkins\administrator.txt" -Verbose
        Exit 1
    }
    $PasswordFile3 = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\administrator\administrator.txt"
    $KeyFile3 = "\\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\administrator\administrator.key"
    $key3 = Get-Content $KeyFile3
    $MyCredential3 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "$LocalAdminUser", (Get-Content $PasswordFile3 | ConvertTo-SecureString -Key $key3)
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 
}



#endregion

#region log start 

Invoke-Command -ComputerName sqlcluster01 -Credential $MyCredential1 {
$Startclock = [datetime]::Now
New-ItemProperty HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_START -Name Start -Value $StartClock -Force
Write-Verbose "Removing any entries in HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_START and HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_STOP" -Verbose
Remove-ItemProperty HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_START -Name Start -Force -ErrorAction SilentlyContinue
Remove-ItemProperty HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_END -Name End -Force -ErrorAction SilentlyContinue
$StartClock = Get-Date
New-ItemProperty HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_START -Name Start -Value $StartClock -Force
}

#endregion

#region read from commit table 
Try
{
    Write-Host "Obtain latest SQL table data for build" -ForegroundColor Yellow

    $RT = Read-SqlTableData -DatabaseName Citrix_Image_Automation -TableName AUTOMATION_CONFIGURATION_TEST_MULTI -ServerInstance "SQLCluster01" -SchemaName dbo -Credential $MyCredential
    IF (!($RT))
    {
        Write-Warning "Could not obtain Table Data for Build #configuration" -Verbose
        Exit 1
    }
    $TableDetails = $RT | sort 'DATE OF BUILD' -Descending |select -First 1
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
   exit 
}

#endregion 

#region read from default table 
Try
{
    Write-Host "Obtain latest SQL table data for defaults" -ForegroundColor Yellow
    $RT1 = Read-SqlTableData -DatabaseName Citrix_Image_Automation -TableName AUTOMATION_DEFAULTS -ServerInstance "SQLCluster01" -SchemaName dbo -Credential $MyCredential
    IF (!($RT1))
    {
        Write-Warning "Could not obtain Table Data for Defaults" -Verbose
        Exit 1
    }
    $TableDetails1 = $RT1| sort 'DATE OF BUILD' -Descending |select -First 1
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Write-Host "Combine DB commit table with defaults table" -ForegroundColor Yellow
Start-Sleep 1
[array]$AllTables = $TableDetails
Start-Sleep 1
$AllTables += $TableDetails1
$XML = $AllTables
#endregion 

#region create outside variables 

Write-Host "obtaining variables" -ForegroundColor Yellow
[STRING]$outsideVDANAME = $($XML.'VDA NAME') 
[STRING]$OutsideVDATYPE = $($XML.'VDA TYPE')
[STRING]$outsideVDADISKSIZE = $($XML.'DISK SIZE')
[STRING]$outsideVDAFILENAME = $($XML.'VDA FILE NAME')
[STRING]$outsideVDARAMSIZE = $($XML.'RAM SIZE')
[STRING]$outsideVDACPUCOUNT = $($XML.'CPU COUNT')
[STRING]$outsideTFSLOCATION = $($XML.'TFS LOCATION') 
[STRING]$outsideWRITECACHESIZE = $($XML.'WRITE CACHE SIZE')
[STRING]$outsideWRITECACHENAME = $($XML.'WRITE CACHE FILE NAME')
[STRING]$outsideVMMSERVER = $($XML.'VMM SERVER')
[STRING]$outsideVMHOSTNAME = $($XML.ROOT.VMHOST.NAME)
[STRING]$outsideVDACSV = "C:\Clusterstorage\$($XML.'VDA CSV')"
[STRING]$outsideVDACLOUD = $($XML.'VDA CLOUD')
[STRING]$outsideVDATAG = $($XML.'VDA TAG')
[STRING]$outsideOFFICEBITNESS = $($XML.'OFFICE BITNESS')
[STRING]$outsideOFFICEXMLPATH = $($XML.'OFFICE XML PATH')
[STRING]$outsideOFFICEINSTALLER = $($XML.'OFFICE INSTALLER PATH')
[STRING]$outsideBITDEFENDERXMLPATH = $($XML.'BIT DEFENDER XML PATH')
[STRING]$outsideMDTDEPLOYISO = $($XML.'DEPLOY ISO NAME')
[STRING]$outsideDHCPSERVER  = $($XML.'DHCP SERVER')
[STRING]$outsideDHCPSCOPEID = $($XML.'DHCP SCOPE ID')
[STRING]$outsideCLIENTVMNETWORK = $($XML.'VM NETWORK')
[STRING]$outsideCLIENTVMSUBNET = $($XML.'VM SUBNET')
[STRING]$outsideDATACENTRE = $($XML.DATACENTRE)
[STRING]$outsideCLUSTER = $($XML.'HOST NAME')
[STRING]$outsideTFSLOCATION = $($XML.'SOURCE CONTROL LOCATION')
[STRING]$outsideVMNETWORK = $($XML.'VM NETWORK')
[STRING]$outsideVMSUBNET = $($XML.'VM SUBNET')
[STRING]$OutsideOPERATINGSYSTEM = $($XML.'OPERATING SYSTEM')
[STRING]$OutsideBUILDVMNETWORK = $($XML.'BUILD VM NETWORK')
[STRING]$OutsideBUILDVMSUBNET = $($XML.'BUILD VM SUBNET')
[STRING]$outsideLOGICALSWITCH = $($XML.'LOGICAL SWITCH')
[STRING]$outsideENVIRONMENT = $($xml.'ENVIRONMENT')

Write-Host "Triming variables" -ForegroundColor Yellow
[STRING]$outsideVDANAMETRIMMED = $outsideVDANAME.Trim().TrimEnd().TrimStart()
[STRING]$OutsideVDATYPETRIMMED = $OutsideVDATYPE.Trim().TrimEnd().TrimStart()
[STRING]$outsideVDADISKSIZETRIMMED = $outsideVDADISKSIZE.Trim().TrimEnd().TrimStart()
[STRING]$outsideVDAFILENAMETRIMMED = $outsideVDAFILENAME.Trim().TrimEnd().TrimStart()
[STRING]$outsideVDARAMSIZETRIMMED = $outsideVDARAMSIZE.Trim().TrimEnd().TrimStart() 
[STRING]$outsideVDACPUCOUNTTRIMMED =  $outsideVDACPUCOUNT.Trim().TrimEnd().TrimStart()
[STRING]$outsideTFSLOCATION =  $outsideTFSLOCATION.Trim().TrimEnd().TrimStart()
[STRING]$outsideWRITECACHESIZETRIMMED= $outsideWRITECACHESIZE.Trim().TrimEnd().TrimStart()
[STRING]$outsideWRITECACHENAMETRIMMED= $outsideWRITECACHENAME.Trim().TrimEnd().TrimStart()
[STRING]$outsideVMMSERVERTRIMMED = $outsideVMMSERVER.Trim().TrimEnd().TrimStart()
[STRING]$outsideVMHOSTNAMETRIMMED = $outsideVMHOSTNAME.Trim().TrimEnd().TrimStart()
[STRING]$outsideVDACSVTRIMMED = ($outsideVDACSV.Trim().TrimEnd().TrimStart())
[STRING]$outsideVDACLOUDTRIMMED = $outsideVDACLOUD.Trim().TrimEnd().TrimStart()
[STRING]$outsideVDATAGTRIMMED = $outsideVDATAG.Trim().TrimEnd().TrimStart()
[STRING]$outsideOFFICEBITNESSTRIMMED = $outsideOFFICEBITNESS.Trim().TrimEnd().TrimStart()
[STRING]$outsideOFFICEXMLPATHTRIMMED = $outsideOFFICEXMLPATH.Trim().TrimEnd().TrimStart()
[STRING]$outsideOFFICEINSTALLERTRIMMED = $outsideOFFICEINSTALLER.Trim().TrimEnd().TrimStart()
[STRING]$outsideBITDEFENDERXMLPATHTRIMMED = $outsideBITDEFENDERXMLPATH.Trim().TrimEnd().TrimStart()
[STRING]$outsideMDTDEPLOYISOTRIMMED = $outsideMDTDEPLOYISO.Trim().TrimEnd().TrimStart()
[STRING]$outsideDHCPSERVERTRIMMED = $outsideDHCPSERVER.Trim().TrimEnd().TrimStart()
[STRING]$outsideDHCPSCOPEIDTRIMMED= $outsideDHCPSCOPEID.Trim().TrimEnd().TrimStart()
[STRING]$outsideCLIENTVMNETWORKTRIMMED = $outsideCLIENTVMNETWORK.Trim().TrimEnd().TrimStart()
[STRING]$outsideCLIENTVMSUBNETTRIMMED = $outsideCLIENTVMSUBNET.Trim().TrimEnd().TrimStart()
[STRING]$outsideDATACENTRETRIMMED = $outsideDATACENTRE.Trim().TrimEnd().TrimStart()
[STRING]$outsideCLUSTERTRIMMED = $outsideCLUSTER.Trim().TrimEnd().TrimStart()
[STRING]$outsideTFSLOCATIONTRIMMED = $outsideTFSLOCATION.Trim().TrimEnd().TrimStart()
[STRING]$outsideVMNETWORKTRIMMED = $outsideVMNETWORK.Trim().TrimEnd().TrimStart()
[STRING]$outsideVMSUBNETTRIMMED = $outsideVMSUBNET.Trim().TrimEnd().TrimStart()
[STRING]$OutsideOPERATINGSYSTEMTRIMMED = $OutsideOPERATINGSYSTEM.Trim().TrimEnd().TrimStart()
[STRING]$OutsideBUILDVMNETWORKTRIMMED =  $OutsideBUILDVMNETWORK.Trim().TrimEnd().TrimStart()
[STRING]$OutsideBUILDVMSUBNETTRIMMED = $OutsideBUILDVMSUBNET.Trim().TrimEnd().TrimStart()
[STRING]$outsideLOGICALSWITCHTRIMMED = $outsideLOGICALSWITCH.Trim().TrimEnd().TrimStart()
[STRING]$outsideENVIRONMENTTRIMMED = $outsideENVIRONMENT.Trim().TrimEnd().TrimStart()

#endregion 

#region get environment
$ENVIRON  = $outsideENVIRONMENTTRIMMED
Write-Verbose "Environment is $ENVIRON" -Verbose
Start-Sleep 1
#endregion 

#region Display Variables
Write-Verbose "
        WM Image settings >
               1. VM Name is                      : $outsideVDANAMETRIMMED 
               2. VM Disk Size is                 : $outsideVDADISKSIZETRIMMED 
               3. VM Disk Name is                 : $outsideVDAFILENAMETRIMMED 
               3. VM Memory Size is               : $outsideVDARAMSIZETRIMMED 
               4. VM CPU count is                 : $outsideVDACPUCOUNTTRIMMED 
               5 .Client suffix is                : $outsideTFSLOCATION 
               6. VM Write cache Name is          : $outsideWRITECACHESIZETRIMMED
               7. VM Write cache Size is          : $outsideWRITECACHENAMETRIMMED
               8.VM Operating System              : $OutsideOPERATINGSYSTEMTRIMMED
           
        VMM Hyper V Settings >
               9. VMM Server name is              : $outsideVMMSERVERTRIMMED 
               10. Hyper V Host name is           : $NodeToUse 
               11. CSV location is                : $outsideVDACSVTRIMMED 
               12. Cloud name is                  : $outsideVDACLOUDTRIMMED 
               13. Tag name is                    : $outsideVDATAGTRIMMED 
                
        Office Settings >
               14. Office Bitness is              : $outsideOFFICEBITNESSTRIMMED 
               15. Office XML file path is        : $outsideOFFICEXMLPATHTRIMMED 
               16. Office Installer path is       : $outsideOFFICEINSTALLERTRIMMED 
               17. Bit Defender XML Path is       : $outsideBITDEFENDERXMLPATHTRIMMED 
               18. TFS Location                   : $outsideTFSLOCATIONTRIMMED

        MDT Settings > 
               19. Iso to Boot from name is       : $outsideMDTDEPLOYISOTRIMMED 

        Other System / Networking settings >
               20. Management server name is      : $outsideDHCPSERVERTRIMMED 
               21. DHCP scope ID is               : $outsideDHCPSCOPEIDTRIMMED
               22. DHCP server name is            : $outsideDHCPSERVERTRIMMED 
               23. Client VM Network is           : $outsideCLIENTVMNETWORKTRIMMED 
               24. Client VM Subnet is            : $outsideCLIENTVMSUBNETTRIMMED 

        Datacentre
               25. Datacentre Name is             : $outsideDATACENTRETRIMMED 
               26. ClusterName is                 : $outsideCLUSTERTRIMMED 
               27. Environment is                 : $outsideENVIRONMENTTRIMMED

        " -Verbose


Start-Sleep 5

#endregion

#region Table Details Export 
Write-Host "Export DB commit table & defauls table to XML on E:\XMLImportExport\BuildVDA-MDT.xml" -ForegroundColor Yellow
$AllTables | Export-Clixml E:\XMLImportExport\BuildVDA-MDT.xml
Write-Host "Import DB commit table & defauls table to XML on E:\XMLImportExport\BuildVDA-MDT.xml" -ForegroundColor Yellow
Start-Sleep 1
$AllTablesImport = Import-Clixml E:\XMLImportExport\BuildVDA-MDT.xml
IF (!($AllTablesImport))
{
    Write-Warning "Could not import XML File from E:\XMLImportExport\BuildVDA-MDT.xml" -Verbose
    Exit 1
}
Write-Host "Obtain Path Name for E:\XMLImportExport\BuildVDA-MDT.xml" -ForegroundColor Yellow
Start-Sleep 1
$GetXML = Get-ChildItem E:\XMLImportExport\BuildVDA-MDT.xml
Write-Host "Create a new directory called E:\CitrixVDA\BuildXML\$ENVIRON\$($AllTablesImport.'VDA CLOUD')" -ForegroundColor Yellow
Start-Sleep 1
New-Item -ItemType Directory "E:\CitrixVDA\BuildXML\$ENVIRON\$($AllTablesImport.'VDA CLOUD')" -Force
Write-Host "Set location to E:\CitrixVDA\BuildXML\$($AllTablesImport.'VDA CLOUD')" -ForegroundColor Yellow 
Start-Sleep 1
Set-Location "E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED"
Copy-Item E:\XMLImportExport\BuildVDA-MDT.xml . 
Write-Host "Check that XML file has been copied" -ForegroundColor Yellow
Start-Sleep 1
$TP = Test-Path "E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED\BuildVDA-MDT.xml"
IF ($TP -match 'True')
{
    Write-Host "BuildVDA-MDT.xml File successfully copied" -ForegroundColor Green
}
ELSE
{
    Write-Host "BuildVDA-MDT.xml File not copied over - aborting Script" -ForegroundColor Green
    Start-Sleep 1
    exit 1
}


#endregion 

#region remove PSDRives
Start-Sleep 1
$date = Get-Date
Write-Verbose "Remove any previous PSdrives to Management" -Verbose
Start-Sleep 1

    IF (Get-PSDrive -Name Management)
    {
        Remove-PSDrive Management
    }

    IF (Get-PSDrive PVSServer)
    {
        Remove-PSDrive PVSServer
    }

#endregion

#region check PVSGenFunction

Write-Verbose "Checking availability of E:\CitrixVDA\PVSGen\PVSGen2Function.ps1" -Verbose
IF (Test-Path "E:\CitrixVDA\PVSGen\$ENVIRON\PVSGen2Function.ps1")
{
    Write-Host "E:\CitrixVDA\PVSGen\$ENVIRON\PVSGen2Function.ps1 is present" -ForegroundColor Green
    Start-Sleep 1
}
ELSE
{
    Write-Warning "No E:\CitrixVDA\PVSGen\$ENVIRON\PVSGen2Function.ps1 file Found so aborting" -Verbose
    Start-Sleep 1
    exit 1
}

#endregion

#region new pssession for DHCP Check 
Write-Verbose "Creating a new pssession to $outsideDHCPSERVERTRIMMED to check whether an existing lease for $outsideVDANAMETRIMMED is present" -Verbose
Start-Sleep 1
Try
{
    $DHCPPresession = New-PSSession -ComputerName $outsideDHCPSERVERTRIMMED -Credential $MyCredential1
    IF (!($DHCPPresession))
    {
        Write-Warning "Could not connect to DHCP server" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion 

#region Check DHCP

Write-Verbose "Determine whether a DHCP reservation is already in place for $outsideVDANAMETRIMMED" -Verbose
Start-Sleep 1
Try
{
    $CheckDHCP = Invoke-Command -Session $DHCPPresession {
        Start-Sleep 1
        Get-DhcpServerv4Lease -ScopeId $using:outsideDHCPSCOPEIDTRIMMED | ? {$_.hostname -match $using:outsideVDANAMETRIMMED}
    }
    IF ($CheckDHCP)
    {
        Write-Warning "Could not obtain DHCP information" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion 

#region create PSSession to VMM
Write-Verbose "Creating a new pssession to $outsideVMMSERVERTRIMMED to check whether an existing VM called $outsideVDANAMETRIMMED is present" -Verbose
Start-Sleep 1
Try
{
    $VMMPresession = New-PSSession -ComputerName $outsideVMMSERVERTRIMMED -Credential $MyCredential1
    IF (!($VMMPresession))
    {
        Write-Warning "Could not connect to VMM server" -Verbose
        Exit 1
    }

}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion

#region Copy Files
Write-Verbose "testing path E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED" -Verbose
Start-Sleep 1
$TP = Test-Path "E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED"
Set-Location E:\CitrixVDA\BuildXML\$ENVIRON
Write-Verbose "testing path $outsideVDACLOUDTRIMMED" -Verbose
$TP1 = Test-Path $outsideVDACLOUDTRIMMED
Write-Verbose "Checking that both paths exist" -Verbose
IF (!($TP -and $TP1))
{
    Write-Warning "Could not obtain paths for build XML and Cloud Client Dir" -Verbose
    Exit 1
}
Set-Location "$outsideVDACLOUDTRIMMED"

Write-Verbose "Checking that BuildXML is in evidence" -Verbose
Start-Sleep 1
Try
{
    $GI = Get-ChildItem .
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

IF (!($GI))
{
    Write-Warning "XML File not copied into directory E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED so aborting" -Verbose
    Start-Sleep 1
    exit 1
}
Write-Verbose "Copying BuildVDA-MDT.xml file from Source code repository to E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON" -Verbose
Start-Sleep 1
Try
{
    Copy-Item $GI.Name "E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON" -Force
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Try
{
    Write-Verbose "Obtain BUild XML File in E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED" -Verbose
    Start-Sleep 1
    $GI1 = Get-ChildItem "E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED"
    IF (!($GI1))
    {
        Write-Warning "Could not find path E:\CitrixVDA\BuildXML\$ENVIRON\$outsideVDACLOUDTRIMMED" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Try
{
    Write-Verbose "Obtain BUild XML File in E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON" -Verbose
    Start-Sleep 1
    $GI2 = Get-ChildItem "E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON" | ? {$_.Extension -match '.xml'}
    IF (!($GI2))
    {
        Write-Warning "Coud not find path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Try
{
    Write-Verbose "Obtain BUild XML File Hash for $($GI1.FullName)" -Verbose
    Start-Sleep 1
    $FH1 = (Get-FileHash $GI1.FullName).hash
    IF (!($FH1))
    {
        Write-Warning "Could not obtain hash for $($GI1.FullName)" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Try
{
    Write-Verbose "Obtain BUild XML File Hash for $($GI2.FullName)" -Verbose
    Start-Sleep 1
    $FH2 = (Get-FileHash $GI2.FullName).hash
    IF (!($FH2))
    {
        Write-Warning "Could not obtain hash for $($GI2.FullName)" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Write-Verbose "Comparing File from Source control with that on Build Server MDT deployment share = E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON" -Verbose
Start-Sleep 1
Try
{
    $compareHash =  @($FH1 -match $FH2)
    IF (!($compareHash))
    {
        Write-Warning "Hash comparisons do not match" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

IF (!($compareHash -eq 'True'))
{
    Write-Warning "File Hashes for BuildVDA-MDT.xml are not the same so aborting script" -Verbose
    Start-Sleep 5
    exit 1

}
ELSE
{
	Write-Verbose "File hashes for BuildVDA-MDT are the same so proceeding" -Verbose
	start-Sleep 1  
}
Try
{
	Write-Verbose "Attempting to locate the Secure credentials for Devops to be used in the MDT build" -Verbose
    Start-Sleep 1
    $Gi2 = Get-ChildItem "E:\JenkinsJobs\VDA\configs\$ENVIRON"
    IF (!($GI2))
    {
        Write-Warning "Could not locate path E:\JenkinsJobs\VDA\configs\$ENVIRON" -Verbose
        Exit 1
    }
}
catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
IF ($GI2)
{
    Try
    {
        foreach ($file in $GI2)
        {
            Write-Verbose "Copying $($file.FullName) to E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\" -Verbose
            Start-Sleep 1
            Copy-Item $GI2.FullName -Destination E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\ -Force
        }
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }
}
ELSE
{
	Write-Verbose "Coud not locate any files in E:\JenkinsJobs\VDA\configs\$ENVIRON" -Verbose
	start-Sleep 1 
    exit 1
}
Write-Verbose "Obtaining an copying Customsettings.ini to E:\DeploymentShare\Control" -Verbose
Start-Sleep 1
Try
{
    $GI3 = Get-ChildItem "E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\" | ? {$_.Name -match 'CustomSettings.'}
    IF (!($GI3))
    {
        Write-Warning "Could not obtain Customsettings.ini from E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\" -Verbose
        Start-Sleep 1
    }
    ELSE
    {
        Write-Verbose "Located File $($GI3.FullName)" -Verbose
        Start-Sleep 1
        Write-Verbose "Set location E:\DeploymentShare\Control" -Verbose
        Start-Sleep 1
        Set-Location E:\DeploymentShare\Control
        $Date = (Get-Date).ToString().Replace(' ','-').Replace(':','-').Replace('/','-')
        Write-Verbose "backing up customsettings.ini" -Verbose
        Start-Sleep 1
        Copy-Item .\CustomSettings.ini .\Backup\
        Set-Location .\Backup
        $GI4 = Get-ChildItem .\CustomSettings.ini 
        Write-Verbose "Rename $($GI4.FullName) to Customsettings-$date.ini" -Verbose
        Rename-Item $GI4.FullName -NewName "Customsettings-$date.ini"
        Write-Verbose "Set-location E:\DeploymentShare\Control" -Verbose
        Start-Sleep 1
        Set-Location ..\ 
        Write-Verbose "Removing customsettings.ini file" -Verbose
        $CSI = Get-ChildItem | ? {$_.Name -match 'CustomSettings.ini'}
        IF ($CSI)
        {
            Write-Host "Located CustomSettings.ini file, attempting to remove"
            Remove-Item $CSI.FullName -Force
        }
        dir
        Start-Sleep 10
        Write-Verbose "Copying Over file $($GI3.FullName) to current working directory" -Verbose
        Start-Sleep 1
        Copy-Item $GI3.FullName . -Force
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Try
{
    Write-Verbose "Testing path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\DevopsSrcControl.txt" -Verbose
    Start-Sleep 1
    $TP = Test-Path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\DevopsSrcControl.txt
    IF (!($TP))
    {
        Write-Warning "Could not locate file  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\DevopsSrcControl.txt" -Verbose
        Exit 1
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Try
{
    Write-Verbose "Testing path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\DevopsSrcControl.key" -Verbose
    Start-Sleep 1
    $TP1 = Test-Path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\DevopsSrcControl.key
    IF (!($TP1))
    {
        Write-Warning "Could not locate file  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\DevopsSrcControl.key" -Verbose
        Exit 1
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Try
{
    Write-Verbose "testing path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\MDTDeploy.txt" -Verbose
    Start-Sleep 1
    $TP2 = Test-Path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\MDTDeploy.txt
    IF (!($TP2))
    {
        Write-Warning "Could not locate file  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\MDTDeploy.txt" -Verbose

        Exit 1
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Try
{
    Write-Verbose "testing path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\MDTDeploy.key" -Verbose
    Start-Sleep 1
    $TP3 = Test-Path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\MDTDeploy.key
    IF (!($TP3))
    {
        Write-Warning "Could not locate file  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\MDTDeploy.key" -Verbose
        Exit 1
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Try
{
    Write-Verbose "testing path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\Administrator.txt" -Verbose
    Start-Sleep 1
    $TP4 = Test-Path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\Administrator.txt
    IF (!($TP4))
    {
        Write-Warning "Could not locate file  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\Administrator.txt" -Verbose
        Exit 1
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Try
{
    Write-Verbose "testing path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\Administrator.key" -Verbose
    Start-Sleep 1
    $TP5 = Test-Path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\Administrator.key
    IF (!($TP5))
    {
        Write-Warning "Could not locate file  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON\Administrator.key" -Verbose
        Exit 1
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Try
{
    Write-Verbose "testing path E:\DeploymentShare\Control\Customsettings.ini" -Verbose
    Start-Sleep 1
    $TP6 = Test-Path E:\DeploymentShare\Control\CustomSettings.ini
    IF (!($TP6))
    {
        Write-Warning "Could not locate file E:\DeploymentShare\Control\Customsettings.ini" -Verbose
        Exit 1
    }
    ELSE
    {
        Write-Verbose "Located a customsettings.ini in E:\DeploymentShare\Control, now determing whether it has correct Environment number ID"
        $TEST = 500
        $LIVE = 300
        $DEV = 400

        IF ($ENVIRON -match 'DEV')
        {
            Write-Verbose "Checking customsettings.ini for environment ID = $DEV / DEV" -Verbose
            Start-Sleep 1
            $content = Get-Content E:\DeploymentShare\Control\CustomSettings.ini | Select-String -Pattern $DEV
            IF (!($content))
            {
                Write-Warning "Did not locate environment ID for DEV in customsettings.ini so aborting" -Verbose
                Exit 1
            }
            ELSE
            {
                Write-Verbose "Located an environment in customsettings.ini for DEV" -Verbose
                Start-Sleep 1
            }
        }
        ELSEIF ($ENVIRON -match 'TEST')
        {
            Write-Verbose "Checking customsettings.ini for environment ID = $TEST / TEST" -Verbose
            Start-Sleep 1
            $content = Get-Content E:\DeploymentShare\Control\CustomSettings.ini | Select-String -Pattern $TEST
            IF (!($content))
            {
                Write-Warning "Did not locate environment ID for TEST in customsettings.in so aborting" -Verbose
                Exit 1
            }
            ELSE
            {
                Write-Verbose "Located an environment in customsettings.ini for TEST" -Verbose
                Start-Sleep 1
            }
        }
        ELSEIF ($ENVIRON -match 'LIVE')
        {
            Write-Verbose "Checking customsettings.ini for environment ID = $LIVE / LIVE" -Verbose
            Start-Sleep 1
            $content = Get-Content E:\DeploymentShare\Control\CustomSettings.ini | Select-String -Pattern $LIVE
            IF (!($content))
            {
                Write-Warning "Did not locate environment ID for DEV in customsettings.ini so aborting" -Verbose
                Exit 1
            }
            ELSE
            {
                Write-Verbose "Located an environment in customsettings.ini for LIVE" -Verbose
                Start-Sleep 1
            }
        }
    }
}
Catch
{
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
}
Write-Verbose "Testing to see whether the files has been successfully copied to E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON" -Verbose
Start-Sleep 1
IF (!($TP -and $TP1 -and $TP2 -and $TP3 -and $TP4 -and $TP5 -and $TP6))
{
    Write-Warning "all Secure Files could not be located in E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON, aborting script " 
    Start-Sleep 1
    exit 1
}
ELSE
{
    Write-Verbose "Located all secure files in E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\$ENVIRON, proceeding" -Verbose
    Start-Sleep 1
}

Start-Sleep 2

#endregion


<#
#region Set MDT task Sequence to full automation 
Copy-Item "E:\DeploymentShare\Control\CustomSettings.ini" E:\Admin\Scripts\source\ -Force
[string]$ID = $XML.ENVIRONMENT
IF (!($ID))
{
    Exit 1
}
$ID = $ID.Trim().TrimStart().TrimEnd()
IF ($ID -eq 'LIVE')
{
    $LIVEID = "300"
}
IF ($ID -eq 'DEV')
{
    $DEVID = "400"
}
IF ($ID -eq 'TEST')
{
    $TESTID = "500"
}


Write-Host "$ID will be deployed" -ForegroundColor Yellow
Start-Sleep 2


$GCWithNoSemiColon = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" )  | Select-String '^SkipTaskSequence=YES'
$GCWithSemiColon = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" )  | Select-String 'SkipTaskSequence=YES'
$Startwithcolon = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" )  | Select-String ';TaskSequenceID='
$Startwithoutcolon = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" )  | Select-String 'TaskSequenceID='
IF ($Startwithcolon)
{
    $End =  $Startwithcolon.LineNumber+1
}
IF ($Startwithoutcolon)
{
    $End =  $Startwithoutcolon.LineNumber+1
}
IF ($Startwithcolon)
{
    Write-Host "in Startwithcolon" -ForegroundColor Green
    IF ($ID -eq "LIVE")
    {
        Write-Host "Deploying a Live image" -ForegroundColor Green
        [string]$Line = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini")  | Select-String '\d' |? {$_.linenumber -ge $Startwithcolon.LineNumber -and $_.linenumber -le $End}
        $Sub = $Line.Substring($Line.Length-3,3)
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ';SkipTaskSequence=YES','SkipTaskSequence=YES' | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ";TaskSequenceID=$Sub","TaskSequenceID=$LIVEID" | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
    }
    IF ($ID -eq "DEV")
    {
        Write-Host "Deploying a Dev image" -ForegroundColor Green
        [string]$Line = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini")  | Select-String '\d' |? {$_.linenumber -ge $Startwithcolon.LineNumber -and $_.linenumber -le $End}
        $Sub = $Line.Substring($Line.Length-3,3)
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ';SkipTaskSequence=YES','SkipTaskSequence=YES' | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ";TaskSequenceID=$Sub","TaskSequenceID=$DEVID" | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
    }
    IF ($ID -eq "TEST")
    {
        Write-Host "Deploying a test image" -ForegroundColor Green
        [string]$Line = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini")  | Select-String '\d' |? {$_.linenumber -ge $Startwithcolon.LineNumber -and $_.linenumber -le $End}
        $Sub = $Line.Substring($Line.Length-3,3)
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ';SkipTaskSequence=YES','SkipTaskSequence=YES' | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ";TaskSequenceID=$Sub","TaskSequenceID=$TESTID" | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
    }
}
IF ($Startwithoutcolon)
{
    Write-Host "in Startwithoutcolon" -ForegroundColor Green
    IF ($ID -eq "LIVE")
    {
        Write-Host "Deploying a Live image" -ForegroundColor Green
        [string]$Line = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini")  | Select-String '\d' |? {$_.linenumber -ge $Startwithoutcolon.LineNumber -and $_.linenumber -le $End}
        $Sub = $Line.Substring($Line.Length-3,3)
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ';SkipTaskSequence=YES','SkipTaskSequence=YES' | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace "TaskSequenceID=$Sub","TaskSequenceID=$LIVEID" | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
    }
    IF ($ID -eq "DEV")
    {
        Write-Host "Deploying a Dev image" -ForegroundColor Green
        [string]$Line = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini")  | Select-String '\d' |? {$_.linenumber -ge $Startwithoutcolon.LineNumber -and $_.linenumber -le $End}
        $Sub = $Line.Substring($Line.Length-3,3)
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ';SkipTaskSequence=YES','SkipTaskSequence=YES' | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace "TaskSequenceID=$Sub","TaskSequenceID=$DEVID" | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
    }
    IF ($ID -eq "TEST")
    {
        Write-Host "Deploying a test image" -ForegroundColor Green
        [string]$Line = (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini")  | Select-String '\d' |? {$_.linenumber -ge $Startwithoutcolon.LineNumber -and $_.linenumber -le $End}
        $Sub = $Line.Substring($Line.Length-3,3)
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace ';SkipTaskSequence=YES','SkipTaskSequence=YES' | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
        (Get-Content "E:\DeploymentShare\Control\CustomSettings.ini" -raw) -replace "TaskSequenceID=$Sub","TaskSequenceID=$TESTID" | Set-Content -Path "E:\DeploymentShare\Control\CustomSettings.ini"
    }

}




#endregion 
#>