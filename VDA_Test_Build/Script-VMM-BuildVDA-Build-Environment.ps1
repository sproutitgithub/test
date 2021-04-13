param (
      [string]$WORKSPACE,
      [string]$JOB_NAME

)

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
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\SCinframanagement\SCinframanagement.txt" -Verbose
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
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\MDTDeploy\MDTDeploy.txt" -Verbose
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
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\administrator\administrator.txt" -Verbose
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
    Write-Warning "could not obtain XML file contents" -Verbose
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
IF (!($ENVIRON))
{
    Write-Warning "could not obtain Environment" -Verbose

    Exit 1
}
Write-Verbose "Environment is $ENVIRON" -Verbose
Start-Sleep 1
#endregion 

#region create DHCP PS Session
Write-Verbose "Creating a new pssession to $outsideVMMSERVERTRIMMED to check whether an existing VM called $outsideVDANAMETRIMMED is present" -Verbose
Start-Sleep 1
Try
{
    $VMMPresession = New-PSSession -ComputerName $outsideVMMSERVERTRIMMED -Credential $MyCredential1
    IF (!($VMMPresession))
    {
        Write-Warning "could not create PS Session to VMM server" -Verbose

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

#region Pick a Node to build on 
Write-Host "Identify node to build VDA on" -ForegroundColor Yellow
$Nodes = 
Invoke-Command -ComputerName vmmcluster01 -Credential $MyCredential1 {
$CLuster = $USING:outsideCLUSTERTRIMMED
Write-Host "attempting to identify nodes for cluster $CLuster" -ForegroundColor Yellow
Start-Sleep 1
$ErrorActionPreference="stop"
((Get-SCVMHostCluster -VMMServer vmmcluster01 | ? {$_.Name -match $CLuster}).nodes).fqdn
}
$Rand = Get-Random -Maximum $Nodes.Count -Minimum 0
IF (!($Rand))
{
    $Rand = Get-Random -Maximum $Nodes.Count -Minimum 0
    IF (!($Rand))
    {    
        Write-Warning "could not create a random node count" -Verbose
        Exit 1
    }
}
$NodeToUse = $Nodes[$Rand]
IF (!($NodeToUse))
{
    $Rand = Get-Random -Maximum $Nodes.Count -Minimum 0
    $NodeToUse = $Nodes[$Rand]
    IF (!($NodeToUse))
    {
        Write-Warning "could not create a node to use" -Verbose
        Exit 1
    }
}
#endregion

#region Locate VM
Write-Verbose "Determing whether a VM called $outsideVDANAMETRIMMED is in evidence" -Verbose
Start-Sleep 1
Try
{
    $CheckVMM = Invoke-Command -Session $VMMPresession {
     Get-SCVirtualMachine  -Name $using:outsideVDANAMETRIMMED -VMMServer $using:outsideVMMSERVERTRIMMED
     }

}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

IF (($CheckVMM))
{
    Write-Warning "Located an existing VM called $outsideVDANAMETRIMMED, so exiting" -Verbose
   Exit 1
   
}

#endregion

#region check MDT and Image not on same host
Write-Verbose "Checking to see whether deployment server is located on the same host to which the new VM will be deployed. IF true then the deployment server needs to be migrated to another host" -Verbose
$Deployserver  = $env:COMPUTERNAME
Start-Sleep 1
$CheckSameHost = 
Invoke-Command -Session $VMMPresession {
$VM = $USING:Deployserver
Write-Verbose "Obtaining VM details" -Verbose
Start-Sleep 1
$VMHost =   Get-SCVirtualMachine -VMMServer vmmcluster01 $VM 
$CurrentVMHost = $USING:NodeToUse  -replace (".$ENV:USERDNSDOMAIN","")
IF ($CurrentVMHost -eq $USING:NodeToUse )
    {
        Write-Warning "Deployment server is on same host, please migrate - exiting script" -Verbose
        [pscustomobject]@{
        IsOnSameServer = "True"
        }
    }
ELSE
{
        Write-Verbose "Deployment server is not on same host, continuing" -Verbose
        [pscustomobject]@{
        IsOnSameServer = "False"
        }
}

} | select -Property * -ExcludeProperty Runspace*,PSCom*
IF ($CheckSameHost.IsOnSameServer -match 'True')
{
    Write-Warning "VM to be built is on  same server as MDT deployment" -Verbose
    Exit 1
}
#endregion

#region VMM Build Start 
Write-Verbose "Connecting to PS session $($VMMPresession.name) on VMM Server $outsideVMMSERVERTRIMMED to start build" -Verbose
Start-Sleep 1

Try
{
    Invoke-Command -Session $VMMPresession  {
Write-Verbose "Create GUIDs for each Job, Template, Hardware profile" -Verbose
Start-Sleep 1
$JOB1 = [GUID]::NewGuid().Guid
$JOB2 = [GUID]::NewGuid().Guid
$PROF1 = [GUID]::NewGuid().Guid
$TEMP1 = [GUID]::NewGuid().Guid

#job1
$ErrorActionPreference="Stop"

Write-Verbose "Create New SCSI Virtual Adapter" -Verbose
Start-Sleep 1
Try
{
    New-SCVirtualScsiAdapter -VMMServer VMMCLUSTER01 -JobGroup $JOB1 -AdapterID 7 -ShareVirtualScsiAdapter $false -ScsiControllerType DefaultTypeNoType 
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 
}

$DataCentreLibrary = $USING:outsideDATACENTRETRIMMED

Write-Host "Obtain MDT Build ISO" -ForegroundColor Green
Start-Sleep 1 
#$ISOID = Get-SCISO -VMMServer localhost | ? {$_.Name -eq "vscdeploy01LiteTouchPE_x64.iso"}
Try
{
    $ISOID = Get-SCISO -VMMServer VMMCLUSTER01 | ? {$_.Name -eq $USING:outsideMDTDEPLOYISOTRIMMED}
    Write-Host "Located an ISO Called $($USING:outsideMDTDEPLOYISOTRIMMED)" -ForegroundColor Green
    Start-Sleep 1
    $ISOSort = $ISOID.libraryserver | sort 
    IF ($DataCentreLibrary -eq "Hayes")
    {
        Write-Verbose "The Datacentre into which the VM will be deployed is $DataCentreLibrary" -Verbose
        Start-Sleep 1
        $ISO1 = Get-SCISO -VMMServer VMMCLUSTER01 -ID $ISOID[0].ID.Guid | where {$_.Name -eq $USING:outsideMDTDEPLOYISOTRIMMED}
        Write-Host "Attaching $ISO1 to VM" -ForegroundColor Yellow
        Start-Sleep 1
        New-SCVirtualDVDDrive -VMMServer vmmcluster01 -JobGroup $JOB1 -Bus 0 -LUN 1 -ISO $ISO1 -Link 
    }
    IF ($DataCentreLibrary -eq "Enfield")
    {
        Write-Verbose "The Datacentre into which the VM will be deployed is $DataCentreLibrary" -Verbose
        Start-Sleep 1
        $ISO2 = Get-SCISO -VMMServer VMMCLUSTER01 -ID $ISOID[1].ID.Guid | where {$_.Name -eq $USING:outsideMDTDEPLOYISOTRIMMED}
        Write-Host "Attaching $ISO2 to VM" -ForegroundColor Yellow
        Start-Sleep 1
        New-SCVirtualDVDDrive -VMMServer vmmcluster01 -JobGroup $JOB1 -Bus 0 -LUN 1 -ISO $ISO2 -Link 
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}


Write-Verbose "Obtain VMNetwork and VMSubnet" -Verbose
Start-Sleep 1
Try
{
    $VMSubnetID = Get-SCVMSubnet -VMMServer VMMCLUSTER01 $USING:outsideVMSUBNETTRIMMED
    $VMNetworkID = Get-SCVMNetwork -VMMServer VMMCLUSTER01 $USING:outsideVMNETWORKTRIMMED
    $VMSubnet = Get-SCVMSubnet -VMMServer VMMCLUSTER01 -Name $USING:outsideVMSUBNETTRIMMED | where {$_.VMNetwork.ID -eq $VMNetworkID.ID.Guid}
    $VMNetwork = Get-SCVMNetwork -VMMServer VMMCLUSTER01 -Name $USING:outsideVMNETWORKTRIMMED -ID $VMNetworkID.ID.Guid
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}



Write-Verbose "Obtain Capability Profile" -Verbose
Start-Sleep 1
Try
{
    $CapabilityProfile = Get-SCCapabilityProfile -VMMServer VMMCLUSTER01 | where {$_.Name -eq "Hyper-V"}
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

#prof1
#job1
Write-Verbose "Create New Hardware Profile" -Verbose
Start-Sleep 1
Try
{
    New-SCHardwareProfile -VMMServer VMMCLUSTER01 -Name "Profile$PROF1" `
    -Description "Profile used to create a VM/Template" -CPUCount $USING:outsideVDACPUCOUNTTRIMMED -MemoryMB $USING:outsideVDARAMSIZETRIMMED -DynamicMemoryEnabled $false `
    -MemoryWeight 5000 -CPUExpectedUtilizationPercent 20 -DiskIops 0 -CPUMaximumPercent 100 -CPUReserve 0 `
    -NumaIsolationRequired $false -NetworkUtilizationMbps 0 -CPURelativeWeight 100 -HighlyAvailable $true `
    -HAVMPriority 2000 -DRProtectionRequired $false -SecureBootEnabled $false -CPULimitFunctionality $false -CPULimitForMigration $true `
    -CapabilityProfile $CapabilityProfile -Generation 2 -JobGroup $JOB1
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

#job2
Write-Verbose "Create New Virtual Disk Drive" -Verbose
Start-Sleep 1
Try
{
    New-SCVirtualDiskDrive -VMMServer vmmcluster01 -SCSI -Bus 0 -LUN 0 -JobGroup $JOB2 -VirtualHardDiskSizeMB $USING:outsideVDADISKSIZETRIMMED `
    -CreateDiffDisk $false  -Dynamic -Filename $USING:outsideVDAFILENAMETRIMMED -VolumeType BootAndSystem 
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

#job2
Write-Verbose "Create Write cache Disk" -Verbose
Start-Sleep 1
Try
{
    New-SCVirtualDiskDrive -VMMServer vmmcluster01 -SCSI -Bus 0 -LUN 2 -JobGroup $JOB2 -VirtualHardDiskSizeMB $USING:outsideWRITECACHESIZETRIMMED `
    -CreateDiffDisk $false -Dynamic -Filename $USING:outsideWRITECACHENAMETRIMMED -VolumeType None 
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}
#prof1
Write-Verbose "Obtain Hardware Profile" -Verbose
Start-Sleep 1
Try
{
    $HardwareProfile = Get-SCHardwareProfile -VMMServer vmmcluster01 | where {$_.Name -eq "Profile$PROF1"}
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

#temp1 # #job2
Write-Verbose "Create Temporary Template" -Verbose
Start-Sleep 1
Try
{
    New-SCVMTemplate -Name "Temporary Template$TEMP1" -Generation 2 -HardwareProfile $HardwareProfile -JobGroup $JOB2 -NoCustomization 
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Obtain Temporary Template and apply VM configuration" -Verbose
Start-Sleep 1
Try
{
    $template = Get-SCVMTemplate -All | where { $_.Name -eq "Temporary Template$TEMP1" }
    $virtualMachineConfiguration = New-SCVMConfiguration -VMTemplate $template -Name $USING:outsideVDANAMETRIMMED
    Write-Output $virtualMachineConfiguration
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}


Write-Verbose "Obtain VMHost to build VM on" -Verbose
Start-Sleep 1
Try
{
    $vmHostID = Get-SCVMHost $USING:NodeToUse -VMMServer vmmcluster01 
    $vmHost = Get-SCVMHost -ID $vmHostID.ID.Guid
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Set VM Configuration" -Verbose
Start-Sleep 1
Try
{
    Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMHost $vmHost
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Update VM Configuration" -Verbose
Start-Sleep 1
Try
{
    Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Set VM Configuration" -Verbose
Start-Sleep 1
Try
{
    Set-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration -VMLocation $USING:outsideVDACSVTRIMMED -PinVMLocation $true
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Obtain Network Configuration" -Verbose
Start-Sleep 1
Try
{
    $AllNICConfigurations = Get-SCVirtualNetworkAdapterConfiguration -VMConfiguration $virtualMachineConfiguration
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}


#job2
Write-Verbose "Update VM Configuration" -Verbose
Start-Sleep 1
Try
{
    Update-SCVMConfiguration -VMConfiguration $virtualMachineConfiguration
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Obtain OS Configuration" -Verbose
Start-Sleep 1
Try
{
    $operatingSystem = Get-SCOperatingSystem | where { $_.Name -eq $using:OutsideOPERATINGSYSTEMTRIMMED}
    
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Create VM" -Verbose
Start-Sleep 1
Try
{
    New-SCVirtualMachine -Name $using:outsideVDANAMETRIMMED -VMConfiguration $virtualMachineConfiguration -Description "" -BlockDynamicOptimization $false `
    -JobGroup $JOB2 -ReturnImmediately -StartAction "NeverAutoTurnOnVM" -StopAction "TurnOffVM" -OperatingSystem $operatingSystem
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}


	Do {
	Write-Verbose "Waiting for VM $($using:outsideVDANAMETRIMMED) to complete its creation" -Verbose
	$VMState = Get-SCVirtualMachine $using:outsideVDANAMETRIMMED -VMMServer VMMCLUSTER01 
	start-sleep 1
	}until ($VMState.status -eq 'PowerOff')


Write-Verbose "Remove Hardware Profile" -Verbose
Start-Sleep 1
Try
{
    Get-SCHardwareProfile -All | ? {$_.Name -eq $HardwareProfile } | Remove-SCHardwareProfile 
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Write-Verbose "Remove Temporary Template" -Verbose
Start-Sleep 1
Try
{
    Get-SCVMTemplate -All | ? {$_.Name -eq  "Temporary Template$TEMP1"} | Remove-SCVMTemplate 
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 
}
  
    }
    IF (!($VMMPresession))
    {
        Write-Warning "could not locate a PS Sesion to VMM" -Verbose
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