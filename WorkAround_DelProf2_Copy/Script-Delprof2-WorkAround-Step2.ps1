#region Step 2
$ErrorActionPreference="silentlycontinue"
$importRDs = Get-Content E:\JenkinsConfigurations\Configurations\RDSPVS\RDSPVS.csv

IF (!($importRDS))
{
    Exit 1
}
ELSE
{
    $CatchAllWSMAN = 
    foreach ($Machine in $importRDs)
    {
        Write-host "Attempting connection to Copmputer $Machine" -ForegroundColor Yellow
        $TM =  Test-WSMan $Machine
        IF ($TM)
        {
            [pscustomobject]@{
                Name = $Machine
                Connected = "True"
            }
        }
        ELSE
        {
            [pscustomobject]@{
                Name = $Machine
                Connected = "False"
            }

        }
    }
}
$CatchAllWSMAN | Export-csv E:\JenkinsConfigurations\Configurations\RDSPVS\RDSWSMAN.csv -NoTypeInformation

#endregion