Invoke-Pester -Path C:\Git\test1\Dev\PesterResults.ps1  -OutputFormat NUnitXml -OutputFile "C:\tests\dev\AllResults.xml" -PassThru
Set-Location C:\extentreports-dotnet-cli-master\extentreports-dotnet-cli-master\dist
.\extent.exe -i "C:\tests\dev\AllResults.xml" -o "C:\Users\svc_jenkins\AppData\Local\Jenkins\.jenkins\workspace\Ansible8\Dev\AllResults"
.\extent.exe -i "C:\tests\dev\AllResults.xml" -o "C:\Tests\Dev\AllResults.html"