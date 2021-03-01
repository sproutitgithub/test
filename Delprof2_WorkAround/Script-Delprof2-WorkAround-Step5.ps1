#region Step 5
$ErrorActionPreference="silentlycontinue"
$Importcreds = Import-Clixml E:\JenkinsJobs\Configurations\RDSPVS\RDSCreds.xml 
$Getcreds = $Importcreds
IF (!($Importcreds))
{
    exit 1
}
$importSMB = Import-Csv E:\JenkinsJobs\Configurations\RDSPVS\RDSSMB.csv 
IF (!($importSMB))
{
    exit 1
}
ELSE
{
    $computername = $importSMB | ? {$_.STATUS -match 'Open'}

    $CatchAllPVS = 
    Try
    {
        foreach ($Computer in $computername)
        {
            foreach ($Cred in $Getcreds)
            {

                IF ($Computer -match $Cred.UserName.Replace('\scinframanagement',''))
                {
                    Write-Host "Matched $($Computer.name) with $($Cred.UserName.Replace('\scinframanagement',''))" -ForegroundColor Yellow
                    Invoke-Command -ComputerName $Computer.Name -Credential $Cred {
                     $GI = Get-ChildItem c:\ | ? {$_.Name -match 'Personality.'} -ErrorAction SilentlyContinue
                        IF ($GI)
                        {
                            @{
                            NAME = ($ENV:COMPUTERNAME+'.'+$ENV:USERDNSDOMAIN)
                            ISPVS = "TRUE"
                            }
                        } 
                        ELSE
                        {
                           @{
                            NAME = ($ENV:COMPUTERNAME+'.'+$ENV:USERDNSDOMAIN)
                            ISPVS = "FALSE"
                            }
                        }
                    }
                }
            }
        }
    }
    Catch
    {
        $err1 = $Error[0]
        Write-Host $err1 -ForegroundColor Magenta
    }
}
$CatchAllPVS | ? {$_.ISPVS -match 'TRUE'} | Export-Csv E:\JenkinsJobs\Configurations\RDSPVS\RDSPVSTRUE.csv -NoTypeInformation
#endregion 