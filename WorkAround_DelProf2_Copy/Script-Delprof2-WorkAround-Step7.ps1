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
    foreach ($Computer in $computername)
    {
        foreach ($Cred in $Getcreds)
        {

            IF ($Computer -match $Cred.UserName.Replace('\scinframanagement',''))
            {
                Write-Host "Matched $($Computer) with $($Cred.UserName.Replace('\scinframanagement',''))" -ForegroundColor Yellow
                $PSDrive = (($computer) -split'\.')[0]
                Write-Host "Creating a PS Drive $PSDrive" -ForegroundColor Yellow
                New-PSDrive -Name "$PSDrive" -PSProvider FileSystem -Root "\\$($computer)\c$\_SproutITInstalls\Delprof2" -Credential $Cred
                #Set-Location "$($PSDrive):"
                Write-Host "Copying file C:\CopyFilesFrom\DelProf2.exe to $($PSDrive):" -ForegroundColor Yellow 
                Copy-Item "C:\CopyFilesFrom\DelProf2.exe" "$($PSDrive):" -Force
                Write-Host "Copying file C:\CopyFilesFrom\DelProf2.exe to $($PSDrive):" -ForegroundColor Yellow 
                Copy-Item "C:\CopyFilesFrom\DelProf2.exe" "$($PSDrive):" -Force
                $Item = Get-ChildItem "$($PSDrive):"
                IF ($Item)
                {
                    Write-Host "Located $($Item.fullname)" -ForegroundColor green
                }
                Write-Host "Set location to C:" -ForegroundColor Yellow
                Set-Location c:\ 
                Write-Host "Remove PS Drive $PSDrive" -ForegroundColor Yellow
                Remove-PSDrive $PSDrive
             }
        }

    }
}
#endregion 