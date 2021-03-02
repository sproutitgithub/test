#region Step 9
$importResults = Import-Csv E:\JenkinsConfigurations\Configurations\RDSPVS\RDSRESULTS.csv
IF (!($importResults))
{
    exit 1
}
ELSE
{
    Write-Verbose "Import-Module Pester" -Verbose
    Import-Module Pester
    Describe "All The following Have Delprof2" {
    
        foreach ($Item in $CatchAllForPesterTests)
        {
            it "The Server $($Item.NAME) has Delprof2.exe in evidence" {
            $Item.FILEEXISTS | Should be "TRUE"
            }
        }

    }
}

#endregion 

