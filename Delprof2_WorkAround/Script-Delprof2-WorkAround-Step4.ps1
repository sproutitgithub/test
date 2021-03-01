#region Step 4 
$ErrorActionPreference="silentlycontinue"
$importFQDN = Import-Csv E:\JenkinsJobs\Configurations\RDSPVS\RDSPVSFQDNS.csv
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
$Catchcreds | Export-Clixml E:\JenkinsJobs\Configurations\RDSPVS\RDSCreds.xml 
#endregion 