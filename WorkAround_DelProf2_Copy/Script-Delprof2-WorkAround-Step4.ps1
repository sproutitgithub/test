#region Step 4 
$ErrorActionPreference="silentlycontinue"
$UserName = "scinframanagement"

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
    $MyCredential1 = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "sproutcloud\$UserName", (Get-Content $PasswordFile1 | ConvertTo-SecureString -Key $key1)
    $SecurePassword = $MyCredential1.GetNetworkCredential().Password | ConvertTo-SecureString -AsPlainText -Force
}
Catch
{
    $Err1 = $Error[0]
    Write-Warning $Err1 -Verbose
    exit 1
}

$importFQDN = Import-Csv E:\JenkinsConfigurations\Configurations\RDSPVS\RDSPVSFQDNS.csv
IF (!($importFQDN))
{
    exit 1
}

ELSE
{
    $domains  = 
    foreach ($Cloud in $importFQDN)
    {
        $Cloud.FQDN
    }
    $domsAndUsers = 
    foreach ($domain in $domains)
    {
        "$domain\$UserName"
    }
    $Catchcreds = foreach ($SecureUser in $domsAndUsers)
    {
        Try
        {
            Write-Host "Creating credential set for $SecureUser" -ForegroundColor Yellow
            New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SecureUser,$SecurePassword
        }
        Catch
        {
            Write-Warning "I could not Obtain Credentials for $domain\$Username" -verbose  
        }
    }
}
$Catchcreds | Export-Clixml E:\JenkinsConfigurations\Configurations\RDSPVS\RDSCreds.xml 
#endregion 