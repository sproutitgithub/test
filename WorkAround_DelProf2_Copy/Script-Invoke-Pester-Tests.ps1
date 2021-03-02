
Invoke-Pester -Path E:\Jenkins\jobs\WorkAround_DelProf2_Copy\workspace\WorkAround_DelProf2_Copy\Script-Invoke-Pester-Tests.ps1 -OutputFormat NUnitXml -OutputFile "E:\Jenkins\jobs\WorkAround_DelProf2_Copy\workspace\WorkAround_DelProf2_Copy\AllResults.xml" -PassThru
Set-Location "E:\Admin\Utilities\extentreports-dotnet-cli-master\dist\"
.\extent.exe -i "E:\Jenkins\jobs\WorkAround_DelProf2_Copy\workspace\WorkAround_DelProf2_Copy\AllResults.xml" -o "E:\Jenkins\jobs\WorkAround_DelProf2_Copy\workspace\WorkAround_DelProf2_Copy\AllResults"