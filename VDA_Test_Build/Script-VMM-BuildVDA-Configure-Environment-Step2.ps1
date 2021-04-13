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
    exit 1
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

#region boot VM
Try
{
    Invoke-Command -Session $Session {
    $ErrorActionPreference="silentlycontinue"
    Write-Verbose "Attempting to boot VM $using:outsideVDANAMETRIMMED " -Verbose
    Start-Sleep 1
    Start-SCVirtualMachine -VM $using:outsideVDANAMETRIMMED -RunAsynchronously
     do {
    $VM = Get-SCVirtualMachine -Name $using:outsideVDANAMETRIMMED 
    Write-Verbose "Waiting for Boot of $using:outsideVDANAMETRIMMED" -Verbose
    Start-Sleep 1
        }until($VM.status -match 'running')
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

#region get MAC
Set-Location C:
Write-Verbose "Creating a PS Session to $NodeToUse to identify VM and MAC Address" -Verbose
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

Write-Verbose "obtaining MAC address for $outsideVDANAMETRIMMED" -Verbose
Start-Sleep 1
Try
{
         $MACAddress = Invoke-Command -Session $Session1 {
         Start-Sleep 1
        #(get-vm $using:outsideVDANAMETRIMMED | Get-VMNetworkAdapter | ? {$_.status -match 'Ok'}).MacAddress
        (get-vm $using:outsideVDANAMETRIMMED | Get-VMNetworkAdapter | ? {$_.Name -match '^PVS'}).MacAddress
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion

#region check MAC
IF (!($MACAddress))
{
    $Err1 = $Error[0]
    Write-Warning "MAC Address not found" -Verbose
    Exit 1
}
#endregion 

#region tidy up mac address
Write-Verbose "Split MAC Address at every two characters" -Verbose
Start-Sleep 1
Try
{
    $mac1 = for ($i = 0;$i -lt $MACAddress.Length;$i +=2)
    {
        $MACAddress.Substring($i,2)
    } 
}
Catch
{    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

Write-Verbose "Concatenate MAC Address with - Separator" -Verbose
Start-Sleep 1
Try
{
    $MacToSearchFor = $mac1 -join '-'
}
Catch
{    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion 

#region Check MAC format 
Write-Verbose "Checking MAC format" -Verbose
IF (!($MacToSearchFor -match '-'))
{
    $Err1 = $Error[0]
    Write-Warning "MAC Address format not set correctly" -Verbose
    Exit 1
}

#endregion

#region New PSSession

Write-Verbose "Create a new PS Session to $outsideDHCPSERVERTRIMMED to obtain DHCP Lease for VM $outsideVDANAMETRIMMED" -Verbose
Start-Sleep 1
Try
{
    $Session2 = New-PSSession -ComputerName $outsideDHCPSERVERTRIMMED -Credential $MyCredential1
    IF (!($Session2))
    {
        $Err1 = $Error[0]
        Write-Warning "Could not create PS Session" -Verbose
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

#region obtain IP Lease from DHCP
Write-Verbose "Locate IP Address from Lease on $outsideDHCPSERVERTRIMMED  with a MAC address of $MacToSearchFor" -Verbose
$i = 0
Do {
$IP =  Try
{
    Invoke-Command -Session $Session2 {
    Write-Verbose "Obtaining IP Address for VM $using:outsideVDANAMETRIMMED from $ENV:COMPUTERNAME / Looping as sometimes the DHCP scope takes somewhile to refresh / This script will end if the count exceeds 60 / Count now is $USING:i" -Verbose
      Start-Sleep 1
        Get-DhcpServerv4Lease -ScopeId $using:outsideDHCPSCOPEIDTRIMMED | ? {$_.clientid -match $USING:MacToSearchFor}
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-W arning $Err1 -Verbose
    exit 1
	}
$i++
}until ($IP.IPAddress -or $i -eq 60)
#endregion

#region check IP address reservation - wait for build - NEW!
IF (!($IP.IPAddress))
{
    Write-Warning "No IP Reservation found for $outsideVDANAMETRIMMED" -Verbose
    exit 1

}
ELSE
{
    $ErrorActionPreference="Silentlycontinue"
    Write-Verbose "DHCP Reservation found $($IP.IPAddress) , Waiting for VM to complete Build........." -Verbose
    Start-Sleep 1
        Do 
        {
            $RetrieveData = 
             Invoke-Command -ComputerName $IP.IPAddress -Credential $MyCredential3  {
            $ErrorActionPreference="Silentlycontinue"
            Write-Verbose "Waiting for BuildSuccess and Value of 1 or 0 which means faliure in Registry on $ENV:COMPUTERNAME" -Verbose
            $BS = (Get-ItemPropertyValue HKLM:\SOFTWARE\_SproutITInstalls -Name BuildSuccess) 
            IF ($BS -eq 1)
            {
              $BSVal =  [pscustomobject]@{
                    NAME = "BuildSuccess"
                    VALUE = "$BS"
                }
                $BSVal
                break
            }
            ELSEIF ($BS -eq 0)
            {
                    $BSVal =  [pscustomobject]@{
                    NAME = "BuildSuccess"
                    VALUE = "$BS"
                }
                $BSVal
                Break
            }
            Start-Sleep 1
            Write-Host "Checking for failures throughout Registry in _SproutITInstalls" -ForegroundColor Yellow
            Start-Sleep 1
            $allSproutInstallsReg = reg query HKLM\software\_SproutITInstalls
            $CatchAll = 
            foreach ($thing in $allSproutInstallsReg)
            {
                [string]$String = $thing
                $StringReplace = ($String.Replace('REG_DWORD','')).TrimEnd().TrimStart().Trim()
                $StringReplace
            }
            $FoundFailure = 
            foreach ($Item in $CatchAll)
            {
                $DisplayItem = $Item.Split('')[0] 
                Write-Verbose "Checking for a failure in  HKLM\software\_SproutITInstalls $DisplayItem" -Verbose
                IF ($Item | ? {$_ -match '0x0'})
                {
                    [string]$BadItem = $Item
                    $LocatedBadItem = $BadItem.Split('')[0]
                    [pscustomobject]@{
                        NAME = $LocatedBadItem
                        VALUE = 0
                        }
        
                }
            }
            IF ($FoundFailure) {
                Write-Warning "Matched Bad Item $LocatedBadItem - Logging and exiting" -Verbose
                  $BSVal = [pscustomobject]@{
                    ERROR="BuildSuccess"
                    VALUE=$LocatedBadItem
                }
                $BSVal
                Break
               
              
             }
            Write-Host "Sleeping for 30 Seconds" -ForegroundColor Green
            Start-Sleep 30
        }
      }until ($RetrieveData)
}
IF ($RetrieveData.VALUE -notmatch '[0,1]')
{
    $i = ""
   $Results1 = [pscustomobject]@{
    ID = $i
    "DATE OF STEP" = (Get-Date).ToShortDateString()
    "TIME OF STEP" = (Get-Date).ToShortTimeString()
     "VALUE OF STEP" = $RetrieveData.VALUE 
     "ENVIRONMENT" = $XML.ENVIRONMENT[0]
    }
	Write-Warning "A build step failed and the Build step will be logged in the Database" -Verbose
	start-sleep 1
    Invoke-Command -ComputerName sqlcluster01 -Credential $MyCredential1 {
    $Results1 = $using:Results1
        foreach ($Result in $Results1)
        {
            Write-Host "Writing out Failure to VMM_AUTOMATION_BUILD_STEP_ERRORS" -ForegroundColor Yellow
            Write-SqlTableData -DatabaseName "Citrix_Image_Automation" -SchemaName dbo -TableName "VMM_AUTOMATION_BUILD_STEP_ERRORS" -InputData $Result -ServerInstance "SQLCluster01" -Credential $MyCredential
        }
    }

    $i = ""
   $Results2 = [pscustomobject]@{
    ID = $i
    "DATE OF OUTCOME" = (Get-Date).ToShortDateString()
    "TIME OF OUTCOME" = (Get-Date).ToShortTimeString()
     "VALUE OF OUTCOME" = 0
     "ENVIRONMENT" = $XML.ENVIRONMENT[0]
    "TOTAL RUN TIME" = $null
    }

	Write-Warning "The VM did not build successfully as a 0 has been detected for BuildSuccess - This will be logged in the database" -Verbose
	start-sleep 1
    Invoke-Command -ComputerName sqlcluster01 -Credential $MyCredential1 {
    $Results2 = $using:Results2
        foreach ($Result in $Results2)
        {
            Write-Host "Writing out Failure to VMM_AUTOMATION_BUILD_OUTCOME" -ForegroundColor Yellow
            Write-SqlTableData -DatabaseName "Citrix_Image_Automation" -SchemaName dbo -TableName "VMM_AUTOMATION_BUILD_OUTCOME" -InputData $Result -ServerInstance "SQLCluster01"
        }
    }


}
ELSEIF ($RetrieveData.VALUE -eq 0)
{
    $i = ""
   $Results3 = [pscustomobject]@{
    ID = $i
    "DATE OF OUTCOME" = (Get-Date).ToShortDateString()
    "TIME OF OUTCOME" = (Get-Date).ToShortTimeString()
     "VALUE OF OUTCOME" = $RetrieveData.VALUE 
     "ENVIRONMENT" = $XML.ENVIRONMENT[0]
     "TOTAL RUN TIME" = $null
    }

	Write-Warning "The VM did not build successfully as a 0 has been detected for BuildSuccess - This will be logged in the database" -Verbose
	start-sleep 1
    Invoke-Command -ComputerName sqlcluster01 -Credential $MyCredential1 {
    $Results3 = $using:Results3
    foreach ($Result in $Results3)
        {
            Write-Host "Writing out Failure to VMM_AUTOMATION_BUILD_OUTCOME" -ForegroundColor Yellow
            Write-SqlTableData -DatabaseName "Citrix_Image_Automation" -SchemaName dbo -TableName "VMM_AUTOMATION_BUILD_OUTCOME" -InputData $Result -ServerInstance "SQLCluster01"
        }
    }
}
ELSEIF ($RetrieveData.VALUE -eq 1)
{
    $i = ""
   $Results4 = [pscustomobject]@{
    ID = $i
    "DATE OF OUTCOME" = (Get-Date).ToShortDateString()
    "TIME OF OUTCOME" = (Get-Date).ToShortTimeString()
     "VALUE OF OUTCOME" = $RetrieveData.VALUE 
    "ENVIRONMENT" = $XML.ENVIRONMENT[0]
    "TOTAL RUN TIME" = $null
    }
	Write-Verbose "The VM did build successfully as a 1 has been detected for BuildSuccess - this will be logged in the Database" -Verbose
	start-sleep 1
    Invoke-Command -ComputerName sqlcluster01 -Credential $MyCredential1 {
    $Results4 = $using:Results4
        foreach ($Result in $Results4)
        {
            Write-Host "Writing out success to VMM_AUTOMATION_BUILD_OUTCOME" -ForegroundColor Yellow
            Write-SqlTableData -DatabaseName "Citrix_Image_Automation" -SchemaName dbo -TableName "VMM_AUTOMATION_BUILD_OUTCOME" -InputData $Result -ServerInstance "SQLCluster01"
        }
    }

}
#endregion

#region wait for script to end 
Write-Verbose "Wait for Script end" -Verbose
Start-Sleep 1

   Write-Verbose "Connecting to $($IP.IPAddress) to detect End of MDT Task sequence " -Verbose
    Start-Sleep 1
    $i = 0
        Do 
        {
              $item1 =  Invoke-Command -ComputerName $IP.IPAddress -Credential $MyCredential3  {
                Write-Verbose "Waiting for MDT task sequence to to create registry String value of 'End' on $ENV:COMPUTERNAME" -Verbose
                Start-Sleep 1
                (Get-ItemPropertyValue HKLM:\SOFTWARE\_SproutITRuntime -Name End ) 
                Start-Sleep 1
        }
        $i++ 
      }until ($Item1 -or $i -eq 900)
Write-Verbose "Script detected end of task sequence" -Verbose
Start-Sleep 1
#endregion 

#region wait for script to remove MINNT
Write-Verbose "Wait for Script end" -Verbose
Start-Sleep 1
    Write-Verbose "Connecting to $($IP.IPAddress) wait for MDT task sequence to complete by detecting removal of directory MINNT" -Verbose
    Start-Sleep 1
    $i = 0
        Do 
        {
              $item2 =  Invoke-Command -ComputerName $IP.IPAddress -Credential $MyCredential3  {
                Write-Verbose "Waiting for MDT task sequence to remove the MINNT directory on $ENV:COMPUTERNAME" -Verbose
                Start-Sleep 1
                (Get-ChildItem  "c:\MININT") 
                Start-Sleep 1
        }
        $i++ 
      }until (!$Item2 -or $i -eq 900)
Write-Verbose "Script detected removal of MININT directory" -Verbose
Start-Sleep 1
#endregion 

#region configure VMM Network boot 

Try
{
    Write-Verbose "Setting VM first boot device to boot from Network" -Verbose
    Start-Sleep 1
    $ObtainBootOrder = 
    Invoke-Command -Session $Session {
    Write-Verbose "Create GUIDs for each Job, Template, Hardware profile" -Verbose
    Start-Sleep 1
	$JOB1 = [GUID]::NewGuid().Guid
    Write-Verbose "Setting First Boot device to be the Network Adapter" -Verbose
    Start-Sleep 1
    Set-SCVirtualMachine -vm $using:outsideVDANAMETRIMMED -FirstBootDevice "NIC,0"
    $GetBootOrder = Get-SCVirtualMachine $using:outsideVDANAMETRIMMED
    IF (!($GetBootOrder.FirstBootDevice -eq "NIC,0"))
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
        $BootOrder
    Start-Sleep 5

    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -verbose
    exit 1
}

#endregion 

#region check vm network Boot 
IF (!($ObtainBootOrder.BootOrder -match 'NIC,0'))
{
    Write-Warning "Boot Order For Networking not set" -Verbose
    Exit 1
}

#endregion 

#region Set Custom property IsAutomatedBuild
Try
{

    Invoke-Command -Session $Session {
    $ENV = $using:ENVIRON
	Write-Verbose "Adding to Custom Property IsTestBuild,IsDevelopmentBuild or IsMasterImage = True" -Verbose
	Start-Sleep 1

	Write-Verbose "Creating GUIDs" -Verbose
	Start-Sleep 1
	$JOB1 = [guid]::NewGuid().Guid

	Write-Verbose "Obtaining VM ID and Name" -Verbose
	Start-Sleep 1
	$VMID = Get-SCVirtualMachine -VMMServer VMMCLUSTER01 -Name $using:outsideVDANAMETRIMMED 
	$VM = Get-SCVirtualMachine -VMMServer VMMCLUSTER01 -Name $using:outsideVDANAMETRIMMED   -ID $VMID.id.guid 
	Write-Verbose "Set VM configuration" -Verbose
	Start-Sleep 1
	Set-SCVirtualMachine -VM $VM -Name $using:outsideVDANAMETRIMMED  -JobGroup $JOB1

	Write-Verbose "Obtaining CustomProperty" -Verbose
	Start-Sleep 1
    IF ($ENV -match 'TEST')
    {
        Write-Verbose "Test environment so setting isAutomatedBuild" -Verbose
        Start-Sleep 1
	    $CustID = Get-SCCustomProperty | ? {$_.Name -match 'IsTestBuild'}
    }
    ELSEIF ($ENV -match 'DEV')
    {
        Write-Verbose "Dev environment so setting IsDevelopment" -Verbose
        Start-Sleep 1
        $CustID = Get-SCCustomProperty | ? {$_.Name -match 'IsDevelopmentBuild'}
    }
    ELSEIF ($ENV -match 'LIVE')
    {
        Write-Verbose "Live environment so setting IsMasterImage" -Verbose
        Start-Sleep 1
        $CustID = Get-SCCustomProperty | ? {$_.Name -match 'IsMasterImage'}
    }
	$customProperty = Get-SCCustomProperty -ID $CustID.ID.Guid
	Write-Verbose "Set Custom Property" -Verbose
	Start-Sleep 1
	Set-SCCustomPropertyValue -CustomProperty $customProperty -InputObject $VM -Value "True"

	$customProperty = Get-SCCustomProperty -ID $CustID.ID.Guid
	Write-Verbose "Set Custom Property" -Verbose
	Start-Sleep 1
	Set-SCCustomPropertyValue -CustomProperty $customProperty -InputObject $VM -Value "True"
   }

}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -verbose
    Exit 1
}

#endregion 

#region New PSSession

Write-Verbose "Create a new PS Session to VMMCluster01 to check Customproperty" -Verbose
Start-Sleep 1
Try
{
    $Session3 = New-PSSession -ComputerName vmmcluster01 -Credential $MyCredential1
    IF (!($Session3))
    {
        $Err1 = $Error[0]
        Write-Warning "Could not create PS Session" -Verbose
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

#region Check Cust Prop
    $ObtainCustProperty = 
    Invoke-Command -Session $Session3 {
    $VM = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $Using:outsideVDANAMETRIMMED
    Write-Verbose "Checking and Obtain custom Property for VM $($VM)" -Verbose
    $ObtainCustProp = Get-SCVirtualMachine -VMMServer vmmcluster01 $VM
     [pscustomobject]@{
        Name = $ObtainCustProp.Name
        CustProp =  $ObtainCustProp.CustomProperty  
        }
    }

IF ($ENVIRON -match 'TEST')
{
Write-Verbose "Check Custom Property For TEST" -Verbose
$CustPropKey =  $ObtainCustProperty.CustProp.Keys1
    Try
    {
        IF (!($ObtainCustProperty.Custprop.Keys -match "IsTestBuild"))
        {
            Write-Warning "Custom property not set" -Verbose
            Exit 1
        }
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        Exit 1
    }
}
ELSEIF ($ENVIRON -match 'DEV')
{
$CustPropKey =  $ObtainCustProperty.CustProp.Keys1
Write-Verbose "Check Custom Property For DEV" -Verbose
    Try
    {
        IF (!($ObtainCustProperty.Custprop.Keys -match "IsDevelopmentBuild"))
        {
            Write-Warning "Custom property not set" -Verbose
            Exit 1
        }
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        Exit 1
    }
}
ELSEIF ($ENVIRON -match 'LIVE')
{
$CustPropKey =  $ObtainCustProperty.CustProp.Keys1
Write-Verbose "Check Custom Property For LIVE" -Verbose
    Try
    {
        IF (!($ObtainCustProperty.Custprop.Keys -match "IsMasterImage"))
        {
            Write-Warning "Custom property not set" -Verbose
            Exit 1
        }
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        Exit 1
    }
}
#endregion 

#region Remove Checkpoint
Try
{
    Invoke-Command -Session $Session {
    $VM = get-SCVirtualMachine $using:outsideVDANAMETRIMMED
    Write-Verbose "Identifying checkpoint for $($VM.Name)" -Verbose
    Start-Sleep 1
    $Checkpoint = Get-SCVMCheckpoint -VM $VM.Name -VMMServer vmmcluster01 -MostRecent


    Write-Verbose "Removing checkpoint for $($VM.Name)" -Verbose
    Start-Sleep 1
    Remove-SCVMCheckpoint -VMCheckpoint $Checkpoint -Confirm:$false
    Start-Sleep 5
    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -verbose
    exit 1
}
#endregion 

#region check snapshot 
    $CheckCheckPoint = 
    Invoke-Command -Session $Session {
    Write-Verbose "Checking whether checkpoint has been removed" -Verbose
    Start-Sleep 1
        $VMStatus = Get-SCVMCheckpoint -VM $using:outsideVDANAMETRIMMED
    [pscustomobject]@{
        Name = $VM.name
        CheckPoint = $VMStatus.Enabled
        }
    }
    
IF (!([string]::IsNullOrEmpty($CheckCheckPoint.checkpoint)))
{
    Write-Warning "Checkpoint not removed" -Verbose
    Exit 1
}

#endregion

#region Remove ISO
Try
{

      Invoke-Command -Session $Session {  
    Write-Verbose "removing MDT ISO from machine $using:outsideVDANAMETRIMMED" -Verbose
    Start-Sleep 1
    Write-Verbose "Obtain Virtual Machine Name" -Verbose
    start-sleep 1
    $VMID = Get-SCVirtualMachine $using:outsideVDANAMETRIMMED -VMMServer vmmcluster01 
    Write-Verbose "Obtain Virtual Machine DVD Drive" -Verbose
    start-sleep 1
    $ISOID =  Get-SCVirtualDVDDrive -VM $using:outsideVDANAMETRIMMED -VMMServer vmmcluster01 
    $VirtualDVDDrive = Get-SCVirtualDVDDrive -VMMServer vmmcluster01 -All | where {$_.ID -eq $ISOID.ID.Guid }
    Write-Verbose "Set Virtual Machine DVD Drive No Media" -Verbose
    start-sleep1
    Set-SCVirtualDVDDrive -VirtualDVDDrive $VirtualDVDDrive -Bus 0 -LUN 1 -NoMedia -JobGroup $JOB1
    Write-Verbose "Obtain Virtual Machine ID" -Verbose
    start-sleep1
    $VM = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $using:outsideVDANAMETRIMMED -ID $VMID.ID.Guid
    Write-Verbose "Configure Virtual Machine Name" -Verbose
    start-sleep1
    Set-SCVirtualMachine -VM $VM -Name $using:outsideVDANAMETRIMMED -JobGroup $JOB1
    Start-Sleep 5


    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -verbose
    exit 1
}
#endregion 

#region Check ISO
    $ObtainISO = 
Invoke-Command -Session $Session {
    Write-Verbose "Obtain ISO details for VM" -Verbose
    Start-Sleep 1
    $obtainISOLinked =  Get-SCVirtualDVDDrive -VM $using:outsideVDANAMETRIMMED -VMMServer vmmcluster01
    [pscustomobject]@{
        Name = $using:outsideVDANAMETRIMMED
        ISIsOLinked = $obtainISO.ISOLinked
        }
}

IF ((![string]::IsNullOrEmpty($ObtainISO.ISIsOLinked)))
{
    Write-Warning "ISO Still linked" -Verbose
    Exit 1
}

#endregion 

#region add VM TAG
    Try
    {
    Invoke-Command -Session $Session {
    Write-Verbose "Setting TAG for VM $using:outsideVDANAMETRIMMED" -Verbose
    Start-Sleep 1
    IF ($USING:OutsideVDATYPETRIMMED -match 'Multi')
    {
        $Jobtag1 = (New-Guid).Guid
        Write-Verbose "Setting Tag for $using:outsideVDANAMETRIMMED to Shared Desktop" -Verbose
        Start-Sleep 1
        $VMID = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $using:outsideVDANAMETRIMMED 
        $VM = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $VMID.Name -ID $VMId.ID.Guid
        Set-SCVirtualMachine -VM $VM -Name $VM.Name -Tag "Shared Desktop" -JobGroup $Jobtag1
        Do {
            $VMWait = Get-SCVirtualMachine -Name $using:outsideVDANAMETRIMMED
            Write-Verbose "Waiting for VM $using:outsideVDANAMETRIMMED to update" -Verbose
            Start-Sleep 1
        }until($VMWait.Status -eq 'Running')
    }
    ELSEIF ($USING:OutsideVDATYPETRIMMED -match 'Single')
    {
        $Jobtag1 = (New-Guid).Guid
        Write-Verbose "Setting Tag for $using:outsideVDANAMETRIMMED to VDI" -Verbose
        Start-Sleep 1
        $VMID = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $using:outsideVDANAMETRIMMED
        $VM = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $VMID.Name -ID $VMId.ID.Guid
        Set-SCVirtualMachine -VM $VM -Name $VM.Name -Tag "VDI" -JobGroup $Jobtag1
        Do {
        $VMWait = Get-SCVirtualMachine -Name $using:outsideVDANAMETRIMMED
        Write-Verbose "Waiting for VM $using:outsideVDANAMETRIMMED to update" -Verbose
        Start-Sleep 1
        }until($VMWait.Status -eq 'Running')
        }
        Start-Sleep 2

    }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -verbose
    exit 1
}
#endregion 

#region Check Tag
    $ObtainTag = 
invoke-command -Session $session {

        Write-Verbose "Checking for Tag" -Verbose
        $VMTag = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $using:outsideVDANAMETRIMMED
        [pscustomobject]@{
            Name = $using:outsideVDANAMETRIMMED
            VMTag = $VMTag.Tag
        }

}

IF (!($ObtainTag.VMTAG -match $outsideVDATAGTRIMMED))
{
    Write-Warning "Could not set TAG" -Verbose
    Exit 1
}

#endregion

#region set Client VM Network 
Try
{

    Invoke-Command -Session $Session {
    $JobNet = (New-Guid).Guid

    Write-Verbose "Obtain VM configuration" -Verbose
    Start-Sleep 1
    $VMID = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $using:outsideVDANAMETRIMMED
    Write-Verbose "Obtain VM Network configuration" -Verbose
    Start-Sleep 1
    $VMNetID = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $VMID.Name | Get-SCVirtualNetworkAdapter
    $VirtualNetworkAdapter = Get-SCVirtualNetworkAdapter -VMMServer vmmcluster01 -Name $VMID.Name -ID $VMNetID.ID.Guid
    Write-Verbose "Obtain VMNetwork configuration" -Verbose
    Start-Sleep 1  
    $VMNetWorkID = Get-SCVMNetwork -VMMServer vmmcluster01 -Name $USING:outsideVMNETWORKTRIMMED
    Write-Verbose "Obtain VMSubnet configuration" -Verbose
    Start-Sleep 1
    $VMSubnetID = Get-SCVMSubnet -VMMServer vmmcluster01 -Name $USING:outsideVMSUBNETTRIMMED
    Write-Verbose "Prepare VM configuration" -Verbose
    Start-Sleep 1
    $VMNetwork = Get-SCVMNetwork -VMMServer vmmcluster01 -Name $VMNetWorkID.Name -ID $VMNetWorkID.ID.Guid
    $VMSubnet = Get-SCVMSubnet -VMMServer vmmcluster01 -Name  $VMSubnetID.Name | where {$_.VMNetwork.ID -eq $VMNetWorkID.ID.Guid}
    write-Verbose "Set VM Net Adapter configuration" -Verbose
    Start-Sleep 1
    Set-SCVirtualNetworkAdapter -VirtualNetworkAdapter $VirtualNetworkAdapter -VMNetwork $VMNetwork -VMSubnet $VMSubnet -VirtualNetwork "LS_CLOUD" -MACAddressType Dynamic -IPv4AddressType Dynamic -IPv6AddressType Dynamic -NoPortClassification -JobGroup $JobNet
    Write-Verbose "Modify VM configuration" -Verbose
    Start-Sleep 1
    $VM = Get-SCVirtualMachine -VMMServer vmmcluster01 -Name $VMID.Name #-ID $VMID.id.Guid
    Set-SCVirtualMachine -VM $VM -Name $VM.Name -JobGroup $JobNet
        Do {
    $VMWait = Get-SCVirtualMachine -Name $using:outsideVDANAMETRIMMED
    Write-Verbose "Waiting for VM $using:outsideVDANAMETRIMMED to update" -Verbose
    Start-Sleep 1
    }until($VMWait.Status -eq 'Running')


     }
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}
#endregion

#region Check networking

    $ObtainVMNetwork = 
    Invoke-Command -Session $Session {
    Write-Verbose "Checking that Correct VM Network applied" -Verbose
    Start-Sleep 1
    $VMNet = Get-SCVirtualMachine $using:outsideVDANAMETRIMMED | Get-SCVirtualNetworkAdapter
        [pscustomobject]@{
            Name  = $using:outsideVDANAMETRIMMED 
            VMNet = $VMNet.VMNetwork
            VMSub = $VMNet.VMSubnet
        }

    }

IF (!($ObtainVMNetwork.VMSub.name -match $outsideCLIENTVMSUBNETTRIMMED))
{
    Write-Warning "Could not obtain VM Subnet" -Verbose
    Exit 1
}
#endregion

#region Log total run time
Write-Verbose "Stop Clock and write time to registry" -Verbose
Start-Sleep 1
Invoke-Command -ComputerName sqlcluster01 -Credential $MyCredential1 {

Write-Verbose "Obtain Time from registry" -Verbose
Start-Sleep 1
$StopClock = [datetime]::Now
New-ItemProperty HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_END -Name End -Value $StopClock -Force

$ObtainStarttime = (Get-ItemProperty HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_START -Name Start).start
$ObtainEndtime = (Get-ItemProperty  HKLM:\SOFTWARE\_SproutITBuildRunTimes\_DEV\_END -Name End).end

Write-Verbose "Obtain elapsed time" -Verbose
Start-Sleep 1
$ElapsedTime = New-TimeSpan -Start $ObtainStarttime -End $ObtainEndtime

Write-Verbose "Writing out time of build to SQL Citrix_Image_Automation.[dbo].[VMM_AUTOMATION_BUILD_OUTCOME]"  -Verbose

Write-Verbose "Timing = $ElapsedTime" -Verbose
Start-Sleep 1

$ENVIRONinside = $using:ENVIRON
New-Item E:\SSIS_Scripts\UpdateSQL\updateSQL.sql -ItemType File -Force
$NewEnvironment =  "'" + $ENVIRONinside + "'"
$NewEnvironmentTime =  "'" + $ElapsedTime + "'"

Write-Verbose "Create TSQL Query and update File" -Verbose
Start-Sleep 1
Add-Content E:\SSIS_Scripts\UpdateSQL\updateSQL.sql "
  USE [Citrix_Image_Automation]
  GO
  DECLARE @LASTID INT 
  SET @LASTID = (
  SELECT TOP(1) ID FROM [dbo].[VMM_AUTOMATION_BUILD_OUTCOME]
  ORDER BY ID DESC
  )
 update [dbo].[VMM_AUTOMATION_BUILD_OUTCOME]
 SET [TOTAL RUN TIME] = $NewEnvironmentTime WHERE ID = @LASTID AND ENVIRONMENT = $NewEnvironment " -Force
 
 Write-Verbose "Update Table" -Verbose 
 Start-Sleep 1
  sqlcmd -S sqlcluster01 -i "E:\SSIS_Scripts\UpdateSQL\updateSQL.sql"
}
#endregion 

