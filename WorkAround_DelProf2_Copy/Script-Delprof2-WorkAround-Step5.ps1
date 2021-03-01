#region Step 5
$ErrorActionPreference="silentlycontinue"
$Importcreds = Import-Clixml E:\JenkinsConfigurations\Configurations\RDSPVS\RDSCreds.xml 
$Getcreds = $Importcreds
IF (!($Importcreds))
{
    exit 1
}
$importSMB = Import-Csv E:\JenkinsConfigurations\Configurations\RDSPVS\RDSSMB.csv 
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


$AllTrue = $CatchAllPVS  | ? {$_.ISPVS -match 'TRUE'}
$HashTable = @{}
$i = 0
$c = 1
do {
$HashTable.Add($c,$AllTrue.values[$i])
$i+=2
$c++ 
}until($C -eq $AllTrue.values.Count /2)
$CatchAllPVS1 =  $HashTable.values | select -Unique
$CatchAllPVS1 | Add-Content E:\JenkinsConfigurations\Configurations\RDSPVS\RDSPVSTRUE.csv
#endregion 