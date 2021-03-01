#region Step 6 
$ErrorActionPreference="silentlycontinue"
$importRDsPVSTrue = Get-Content E:\JenkinsConfigurations\Configurations\RDSPVS\RDSPVSTRUE.csv 
IF (!($importRDsPVSTrue))
{
    Exit 1
}
$Importcreds = Import-Clixml E:\JenkinsConfigurations\Configurations\RDSPVS\RDSCreds.xml 
$Getcreds = $Importcreds
IF (!($Importcreds))
{
    exit 1
}
ELSE
{
    $AllRDSGood = 
    foreach ($thing in $importRDsPVSTrue)
    {
        $thing | ? {$_ -match '\.'}
    }
    $GetDirExists = 
    Try
    {
        foreach ($Computer in $AllRDSGood)
        {
            foreach ($Cred in $Getcreds)
            {

                IF ($Computer -match $Cred.UserName.Replace('\scinframanagement',''))
                {
                    Write-Host "Matched $($Computer) with $($Cred.UserName.Replace('\scinframanagement',''))" -ForegroundColor Yellow
                    Invoke-Command -ComputerName $Computer -Credential $Cred {
                     $GI = Get-ChildItem c:\_SproutITInstalls -ErrorAction SilentlyContinue
                        IF (!($GI))
                        {
                            @{
                                NAME = $env:COMPUTERNAME+'.'+$env:USERDNSDOMAIN
                                EXISTS = "FALSE"
                            }
                            Write-Host "Creating a new directory called c:\_SproutITInstalls\Delprof2" -ForegroundColor Yellow
                            New-Item -ItemType Directory c:\_SproutITInstalls\Delprof2\ -Force
                            Start-Sleep 1
                        }
                        ELSE
                        {
                            Write-Host "Directory c:\_SproutITInstalls\Delprof2 already exists" -ForegroundColor Magenta
                            @{
                                NAME = $env:COMPUTERNAME+'.'+$env:USERDNSDOMAIN
                                EXISTS = "TRUE"
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
$AllTrue = $GetDirExists  | ? {$_.EXISTS -match 'TRUE'}
$HashTable = @{}
$i = 0
$c = 1
do {
$HashTable.Add($c,$AllTrue.values[$i])
$i+=2
$c++ 
}until($C -eq $AllTrue.values.Count /2)
$CatchAllDirs =  $HashTable.values | select -Unique

$CatchAllDirs | Add-Content E:\JenkinsConfigurations\Configurations\RDSPVS\RDSDIREXISTS.csv 
#endregion 