#region Step 7
$ErrorActionPreference="silentlycontinue"
$importRDSDIRSExist = Get-Content E:\JenkinsConfigurations\Configurations\RDSPVS\RDSDIREXISTS.csv
IF (!($importRDSDIRSExist))
{
    exit 1
}
$Importcreds = Import-Clixml E:\JenkinsConfigurations\Configurations\RDSPVS\RDSCreds.xml
$Getcreds = $Importcreds
IF (!($Importcreds))
{
    exit 1
}
ELSE
{

    $computername = $importRDSDIRSExist 
    $CatchAllForPesterTests = 
    foreach ($Computer in $computername)
    {
        foreach ($Cred in $Getcreds)
        {

            IF ($Computer -match $Cred.UserName.Replace('\scinframanagement',''))
            {
                Write-Host "Matched $($Computer) with $($Cred.UserName.Replace('\scinframanagement',''))" -ForegroundColor Yellow
                Invoke-Command -ComputerName $Computer -Credential $Cred {
                    
                   $Dir =  Get-ChildItem C:\_SproutITInstalls\Delprof2\DelProf2.exe
                   IF ($Dir)
                   {
                        [pscustomobject]@{
                            NAME = $env:COMPUTERNAME
                            FILEEXISTS = "TRUE"
                        }
                   }
                   ELSE
                   {
                           [pscustomobject]@{
                            NAME = $env:COMPUTERNAME
                            FILEEXISTS = "FALSE"
                        }
                   }
                 }

             }
        }

    }
}
$CatchAllForPesterTests | select Name,FileExists | Export-Csv E:\JenkinsConfigurations\Configurations\RDSPVS\RDSRESULTS.csv -NoTypeInformation