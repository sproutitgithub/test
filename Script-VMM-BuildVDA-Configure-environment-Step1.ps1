
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
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\administrator\SQLJenkins.txt" -Verbose
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
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\administrator\SCinframanagement.txt" -Verbose
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
        Write-Warning "Could not obtain Path \\vscdevops\BuildConfigurations\Sprout Cloud\Configs\Secure\administrator\MDTDeploy.txt" -Verbose

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

#region locate VM and Host 
Write-verbose "Creating a PS session on the VMM cluster" -Verbose
Start-Sleep 1
$Session = New-PSSession -ComputerName vmmcluster01 -Credential $MyCredential1
IF (!($Session))
{
    Write-Warning "could not obtain Node to Usecreate PS Session to VMM" -Verbose
    Exit 1
}
Try
{
    $NodeAndVM = 
    Invoke-Command -Session $Session {
    Write-Verbose "Attempting to identify $($Using:outsideVDANAMETRIMMED)" -Verbose
        Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $using:outsideVDANAMETRIMMED
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}
IF ((!$NodeAndVM))
{
        Write-Warning "could not obtain Node to Use" -Verbose
    exit 1
}
ELSE
{
    $NodeToUse = [string]$NodeAndVM.HostName.Replace('.sproutcloud.local','')
    IF (!($NodeToUse))
    {    
        Write-Warning "could not obtain Node to Use and split string" -Verbose
        Exit 1
    }
}
#endregion 

#region Set PVS NIC for VM on Hyper V host 
Write-Verbose "Obtain PVS Function for Streaming Network Card" -Verbose
$ENVIRON =  $RT.ENVIRONMENT | select -First 1
Start-Sleep 1
Try
{
    $PVSGen2 = Get-ChildItem "E:\CitrixVDA\PVSGen\$ENVIRON"
    IF (!($PVSGen2))
    {    
        Write-Warning "could not obtain PVS Function file Path" -Verbose
        Exit 1
    }
    $PVSGen2Hash = (Get-FileHash $PVSGen2.FullName).hash
    IF (!($PVSGen2Hash))
    {
        Write-Warning "could not obtain file Hash for PVS Function" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Write-Verbose "Creating a PSDrive to VMHost $NodeToUse" -Verbose
Start-Sleep 1

Try
{
    New-PSDrive -Name PVSServer -PSProvider FileSystem -Root "\\$NodeToUse\c$\Scripts" -Credential $MyCredential1
    IF (!(Get-PSDrive -Name PVSServer))
    {
         Write-Warning "could not connect to PVS Server" -Verbose
        Exit 1
    }
    Set-Location PVSServer:
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Write-Verbose "Copying over PVS Streaming NIC script to VMHost $NodeToUse" -Verbose
Start-Sleep 1

Try
{
    Copy-Item $PVSGen2.FullName -Destination . -Force
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Write-Verbose "Check that PVS Script file is most recent" -Verbose
Start-Sleep 1
Try
{
    $CheckScriptFile = Get-ChildItem | ? {$_.Name -match 'Function.ps1'}
    IF (!($CheckScriptFile))
    {
        Write-Warning "could not obtain PS1 function" -Verbose
        Exit 1
    }
    $CheckScriptFileHash =  (Get-FileHash $CheckScriptFile).hash
    IF (!($CheckScriptFileHash))
    {
        Write-Warning "could not obtain file Hash" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
Write-Verbose "Compare Both File Hashes" -Verbose
Start-Sleep 1
IF (!($CheckScriptFileHash -match $PVSGen2Hash))
{
    Write-Warning "Hashes do not match" -Verbose
  Exit 1
}


Set-Location c:
Write-Verbose "Removing PS Drive" -Verbose
Start-Sleep 1
Try
{
    Remove-PSDrive PVSServer
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}

Set-Location C:
Write-Verbose "Creating a PS Session to $NodeToUse to identify and copy over Streaming NIC function" -Verbose
Start-Sleep 1
Try
{

    $Session1 = new-pssession -computername $NodeToUse -Credential $MyCredential1
    IF (!($Session1))
    {
        Write-Warning "Could not create PS Session to $NodeToUse" -Verbose
        Exit 1
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}


    Write-Verbose "Connect to VMHost $NodeToUse to invoke PVS Streaming NIC script on VM Guest $($XML.ROOT.VM.Name) " -Verbose
    Start-Sleep 1
Try
{
    Invoke-Command -Session $Session1 {
    Write-Verbose "In VMHost $ENV:COMPUTERNAME" -Verbose
    Start-Sleep 1

    Write-Verbose "Attempting to locate VM configured in SCVMM $using:outsideVDANAMETRIMMED" -Verbose
    $VM = Get-VM $using:outsideVDANAMETRIMMED
    IF (!($VM))
    {
        Write-warning "I could not locate VM $VM on this host" -Verbose
        exit 1
    }
    ELSE
    {
        Write-Verbose "VM $using:outsideVDANAMETRIMMED located on this host" -Verbose
        Start-Sleep 1
        Write-Verbose "Setting location to c:\Scripts" -Verbose
        Start-Sleep 1
        Set-Location C:\Scripts 
        Write-Verbose "Dot Sourcing the script pvsgen2Function.ps1" -Verbose
        Start-Sleep 1
        . .\pvsgen2Function.ps1
        Write-Verbose "Running Function to Set streaming Nic" -Verbose
        Start-Sleep 1
        $VM = Get-VM $using:outsideVDANAMETRIMMED
        xAdd-Streamingnic -computername $VM.Name
    }
  }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Start-Sleep 10
Write-Verbose "Refresh VMM Console with new VM settings for $($XML.ROOT.VM.NAME)" -Verbose
Start-Sleep 1
Try
{
    Invoke-Command -Session $Session {
    Write-Verbose "Refreshing VMM VM $using:outsideVDANAMETRIMMED" -Verbose
    $VM = Get-SCVirtualMachine -Name $using:outsideVDANAMETRIMMED -VMMServer vmmcluster01 
    Start-Sleep 1
    Read-SCVirtualMachine -VM $VM -Force
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

#endregion

#region Check for Network Card
$CatchNIC = 
Invoke-Command -Session $Session {
    Write-Verbose "Checking VM $using:outsideVDANAMETRIMMED has a network card attached" -Verbose
    $NIC = Get-SCVirtualMachine  -VMMServer vmmcluster01 $($using:outsideVDANAMETRIMMED) | Get-SCVirtualNetworkAdapter
    [pscustomobject]@{
        Name  = $NIC.Name
        Compliance = $NIC.VirtualNetworkAdapterComplianceStatus
    }
} | select -Property * -ExcludeProperty Runsp*,PSCO*
IF (!($CatchNIC.Compliance -match 'Compliant'))
{
    Write-Warning "Network Card not added" -Verbose
    Exit 1
}
#endregion

#region Configure PVS Network Card
Write-Verbose "Configuring Network Adapter for VM $outsideVDANAMETRIMMED" -Verbose
Start-Sleep 1
Try
{
    Invoke-Command -Session $Session {
    Write-Verbose "Creating GUIDS" -Verbose
    Start-Sleep 1
    $JOB1 = [GUID]::NewGuid().Guid

    Write-Verbose "Obtain Network Adapter Settings" -Verbose
    Start-Sleep 1
    try
    {
        $VMNetworkAdapterID = Get-SCVirtualNetworkAdapter -VMMServer VMMCLUSTER01 -VM $using:outsideVDANAMETRIMMED 
        $VirtualNetworkAdapter = Get-SCVirtualNetworkAdapter -VMMServer VMMCLUSTER01 -Name $using:outsideVDANAMETRIMMED  -ID $VMNetworkAdapterID.id.guid
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }

    Write-Verbose "Obtain Network VMSubnet and VMNetwork Settings" -Verbose
    Start-Sleep 1
    Try
    {
        $VMNetworkID = Get-SCVMNetwork -VMMServer VMMCLUSTER01 $using:OutsideBUILDVMNETWORKTRIMMED
        $VMNetwork = Get-SCVMNetwork -VMMServer VMMCLUSTER01 -Name $USING:OutsideBUILDVMNETWORKTRIMMED -ID $VMNetworkID.ID.Guid
        $VMSubnetID = Get-SCVMSubnet -VMMServer VMMCLUSTER01 -Name $USING:OutsideBUILDVMSUBNETTRIMMED
        $VMSubnet = Get-SCVMSubnet -VMMServer VMMCLUSTER01 -Name $USING:OutsideBUILDVMSUBNETTRIMMED | where {$_.VMNetwork.ID -eq $VMNetworkID.ID.Guid}
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit
    }

    Write-Verbose "Set Network Adapter Settings" -Verbose
    Start-Sleep 1
    Try
    {
        Set-SCVirtualNetworkAdapter -VirtualNetworkAdapter $VirtualNetworkAdapter -VMNetwork $VMNetwork -VMSubnet $VMSubnet -VirtualNetwork $USING:outsideLOGICALSWITCHTRIMMED `
        -MACAddressType Dynamic -IPv4AddressType Dynamic -IPv6AddressType Dynamic -NoPortClassification -JobGroup $JOB1
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }

    Write-Verbose "Obtain VM ID" -Verbose
    Start-Sleep 1
    Try
    {
        $VMID = Get-SCVirtualMachine -VMMServer VMMCLUSTER01 -Name $using:outsideVDANAMETRIMMED 
        $VM = Get-SCVirtualMachine -VMMServer VMMCLUSTER01 -Name $using:outsideVDANAMETRIMMED  -ID $VMID.ID.Guid
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }

    Write-Verbose "Obtain OS" -Verbose
    Start-Sleep 1
    Try
    {
        #$OSID = Get-SCOperatingSystem -VMMServer localhost  | ?{$_.Name -match $USING:XML.ROOT.OPERATINGSYSTEM.NAME}
        #$OperatingSystem = Get-SCOperatingSystem -VMMServer localhost -ID $OSID.ID.Guid
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }

    Write-Verbose "Set VM configuration" -Verbose
    Start-Sleep 1
    Try
    {
        Set-SCVirtualMachine -VM $VM -Name $using:outsideVDANAMETRIMMED  -JobGroup $JOB1
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }

    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit
}
#endregion 

#region Check Network Card Configuration 
Write-Verbose "Check that Network Cards has been configured correctly" -Verbose
$CheckNetConfig = 
Invoke-Command -Session $Session {
    Write-Verbose "Check Network Configuration" -Verbose
    Start-Sleep 1
    $VMNet = Get-SCVirtualMachine  $using:outsideVDANAMETRIMMED  | Get-SCVirtualNetworkAdapter
        [pscustomobject]@{
        Name = $using:outsideVDANAMETRIMMED 
        VMNetworkConfiguration = $VMNet.VMNetwork
        }
    $VMNet
Start-Sleep 1
}
IF (!($CheckNetConfig.VMNetworkConfiguration.name -eq $OutsideBUILDVMNETWORKTRIMMED))
{
    Write-Warning "VM Network card not configured" -Verbose
    Exit 1
}
#endregion 

#region Move VM to Cloud 
Write-Verbose "Moving VM $outsideVDANAME" -Verbose
Start-Sleep 1
Try
{
    Invoke-Command -Session $Session {

Write-Verbose "Modifying VM" -Verbose
  Start-Sleep 2

    Write-Verbose "Moving VM $($using:outsideVDANAMETRIMMED) to $($using:outsideVDACLOUDTRIMMED) " -Verbose
    Start-Sleep 1
    $Cloud = Get-SCCloud $using:outsideVDACLOUDTRIMMED
    $VM  = $using:outsideVDANAMETRIMMED
    foreach ($VM in $VM)
        {
            Set-SCVirtualMachine $VM -Cloud $Cloud
        }

Start-Sleep 5
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion

#region Check Cloud Move
Write-Verbose "Check that Cloud has been configured correctly" -Verbose
$CheckCloudConfig = 
Invoke-Command -Session $Session {
    Write-Verbose "Check Cloud Configuration" -Verbose
    Start-Sleep 1
    $VM = Get-SCVirtualMachine  $using:outsideVDANAMETRIMMED 
        [pscustomobject]@{
        Name = $using:outsideVDANAMETRIMMED 
        Cloud = $VM.Cloud
        }
    $VM
Start-Sleep 1
}
IF (!($CheckCloudConfig.Cloud.name -eq $outsideVDACLOUDTRIMMED))
{
    Write-Warning "Cloud not configured" -Verbose
    Exit 1
}
#endregion

#region create snapshot 
$CheckSnapShot = 
Try
{
    Invoke-Command -Session $Session {
    Write-Verbose "Creating a snapshot prior to powering up, use this if you identify issues in the build, delete once built" -Verbose
    Start-Sleep 1
    Get-SCVirtualMachine -VMMServer vmmcluster01 $using:outsideVDANAMETRIMMED  | New-SCVMCheckpoint -Description "Before Build" -Name "prior to MDT Build" -RunAsynchronously
    Start-Sleep 5
    do {
        Write-Verbose "Waiting for VM to complete Snapshot" -Verbose
        $VM = Get-SCVirtualMachine -VMMServer vmmcluster01 $using:outsideVDANAMETRIMMED
        Start-Sleep 1
    }until ($VM.Status -match 'Poweroff')
    $VMStatus = Get-SCVMCheckpoint -VM $using:outsideVDANAMETRIMMED
        [pscustomobject]@{
            Name = $VM.name
            CheckPoint = $VMStatus.Enabled
        }
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion

#region check snapshot 

IF (!($CheckSnapShot.checkpoint -match 'true'))
{
    Write-Warning "Checkpoint not created" -Verbose
    Exit 1
}

#endregion

#region Set boot device DVD
Try
{
    $ObtainBootOrder = 
    Invoke-Command -Session $Session {

    Write-Verbose "Setting First Boot device to be the DVD Drive" -Verbose
    Start-Sleep 1
    Set-SCVirtualMachine -vm $using:outsideVDANAMETRIMMED  -FirstBootDevice "SCSI,0,1"
    $GetBootOrder = Get-SCVirtualMachine $using:outsideVDANAMETRIMMED 
        IF (!($GetBootOrder.FirstBootDevice -eq "SCSI,0,1"))
        {
            Write-Warning "First Boot Device NOT Correctly Configured" -Verbose
            Start-Sleep 1
        }
        ELSE
        {
            Write-Verbose "First Boot Device Correctly Configured" -Verbose
            Start-Sleep 1
        }
        Write-Verbose "Obtaining Boot order" -Verbose
        Start-Sleep 1
        $BootOrder = Get-SCVirtualMachine $using:outsideVDANAMETRIMMED 
            [pscustomobject]@{
                Name = $using:outsideVDANAMETRIMMED
                BootOrder = $BootOrder.FirstBootDevice
            }
Start-Sleep 5
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion 

#region check Boot order 

Write-Verbose "Check Boot Order has been Set" -Verbose
Start-Sleep 1
IF (!($ObtainBootOrder.bootOrder -match 'SCSI,0,1'))
{
    Write-Warning "Boot Order not correctly set" -Verbose
    Exit 1
}

#endregion 