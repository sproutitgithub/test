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
IF (!($XML))
{
    Write-Warning "Could not obtain XML File contents" -Verbose
    Exit 1
}
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

#region Write SQL data
    $i = ""
   $Results = [pscustomobject]@{
    ID = $i
    "DATE OF OUTCOME" = (Get-Date).ToShortDateString()
    "TIME OF OUTCOME" = (Get-Date).ToShortTimeString()
     "VALUE OF OUTCOME" = "1" 
     "ENVIRONMENT" = $ENVIRON
     "TOTAL RUN TIME" = $null
    }

	Write-Warning "The VM did build successfully as a 1 has been detected for BuildSuccess - This will be logged in the database" -Verbose
	start-sleep 1
    Invoke-Command -ComputerName sqlcluster01 -Credential $MyCredential1 {
    $Results3 = $using:Results
    foreach ($Result in $Results)
        {
            Write-Host "Writing out Failure to VMM_AUTOMATION_BUILD_OUTCOME" -ForegroundColor Yellow
            Write-SqlTableData -DatabaseName "Citrix_Image_Automation" -SchemaName dbo -TableName "VMM_AUTOMATION_BUILD_OUTCOME" -InputData $Result -ServerInstance "SQLCluster01"
        }
    }
#endregion