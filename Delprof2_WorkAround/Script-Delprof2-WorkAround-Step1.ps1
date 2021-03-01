#region step 1
$ErrorActionPreference="Stop"
$Start = Get-Date

$VMMUserName = "scinframanagement"
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
    exit 1
}

foreach ($File in Get-ChildItem E:\JenkinsJobs\Configurations\RDSPVS\)
{
    Write-Verbose "Removing File $($File.name)" -Verbose
    Remove-Item $File.fullname -WhatIf
}
$ErrorActionPreference="stop"
Try
{
    $Session = New-PSSession -ComputerName vmmcluster01 -Credential $MyCredential1
}
Catch
{
    Write-Warning "Could not create a PS Session to VMM" -Verbose
    exit 1
}
Write-Verbose "Attempting to obtain computers which are RDS" -Verbose
Start-Sleep 1
& {
    Try
    {
        Invoke-Command -Session $Session {
            (Get-SCVirtualMachine -VMMServer vmmcluster01 | ?{$_.tag -match '^Shared Desktop'}).computernamestring  
        }
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }
} | Add-Content E:\JenkinsJobs\Configurations\RDSPVS\RDSPVS.csv
$TP1 = Test-Path E:\JenkinsJobs\Configurations\RDSPVS\RDSPVS.csv 
IF ($TP1)
{
    $GC1 = Get-Content E:\JenkinsJobs\Configurations\RDSPVS\RDSPVS.csv
    IF (!($GC1 -match '\.'))
    {
        exit 1
    }
}

Write-Verbose "Attempting to obtain FQDN and cloud details" -Verbose
Start-Sleep 1
& {
    Try
    {
        Invoke-Command -Session $Session {
            Get-SCCloud -VMMServer vmmcluster01 | Where-Object {$_.Description -ne [string]::Empty} | select ID,@{name="FQDN";Expression={$_.Description}},@{Name="Cloud";Expression={$_.Name}}
        }
    }
    Catch
    {
        $Err1 = $Error[0]
        Write-Warning $Err1 -Verbose
        exit 1
    }
}  | Export-Csv  E:\JenkinsJobs\Configurations\RDSPVS\RDSPVSFQDNS.csv -NoTypeInformation

$TP2 = Test-Path E:\JenkinsJobs\Configurations\RDSPVS\RDSPVSFQDNS.csv
IF ($TP2)
{
    $GC2 = Get-Content E:\JenkinsJobs\Configurations\RDSPVS\RDSPVSFQDNS.csv
    IF (!($GC2 -match 'vmmcluster01'))
    {
        exit 1
    }
}

#endregion 