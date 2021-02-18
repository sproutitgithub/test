$TP = test-path E:\JenkinsJobs\VDA\Scripts\TEST\
IF (!($TP))
{
      Write-verbose "Creating a new Directory called E:\JenkinsJobs\VDA\Scripts\TEST" -verbose 
      start-sleep 1
      new-item E:\JenkinsJobs\VDA\Scripts\TEST\ -itemtype Dir -force 
}
$TP1 = test-path E:\CitrixVDA\BuildXML\TEST\
IF (!($TP1))
{
      Write-verbose "Creating a new Directory called E:\CitrixVDA\BuildXML\TEST" -verbose 
      start-sleep 1
      new-item E:\CitrixVDA\BuildXML\TEST\ -itemtype Dir -force 

}
$TP2 = test-path E:\CitrixVDA\PVSGen\TEST\
IF (!($TP2))
{
      Write-verbose "Creating a new Directory called E:\CitrixVDA\PVSGen\TEST" -verbose 
      start-sleep 1
      new-item E:\CitrixVDA\PVSGen\TEST\ -itemtype Dir -force 

}
$TP3 = test-path E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\TEST\
IF (!($TP3))
{
      Write-verbose "Creating a new Directory called  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\TEST\" -verbose 
      start-sleep 1
      new-item  E:\DeploymentShare\_Virtual_Delivery_Agent_Builds\CopyFiles\Utilities\BuildXML\TEST\ -itemtype Dir -force 

}

$TP4 = test-path E:\JenkinsJobs\VDA\configs\TEST\
IF (!($TP4))
{
      Write-verbose "Creating a new Directory called E:\JenkinsJobs\VDA\configs\TEST" -verbose 
      start-sleep 1
      new-item E:\JenkinsJobs\VDA\configs\TEST\ -itemtype Dir -force 
}
$TP5 = test-path E:\DeploymentShare\Control\Backup
IF (!($TP5))
{
      Write-verbose "Creating a new Directory called E:\DeploymentShare\Control\Backup" -verbose 
      start-sleep 1
      new-item E:\DeploymentShare\Control\Backup\ -itemtype Dir -force 
}
Write-verbose "Creating New PSDrive" -verbose 

    Write-Verbose "Pulling Scripts and configurations from Live" -Verbose
    Try
    {
      	foreach ($file in get-childitem "E:\Jenkins\jobs\Test_VDA_Automation\workspace"| ? {$_.Name -match 'Script-'})
      	{
        	Write-verbose "Copy File $($file.Name) to E:\JenkinsJobs\VDA\Scripts\TEST\" -verbose 
          	copy-item $File.FullName -destination E:\JenkinsJobs\VDA\Scripts\TEST\
      	}
      
        foreach ($file in get-childitem "E:\Jenkins\jobs\Test_VDA_Automation\workspace"| ? {$_.Name -match 'PVSGen2Function'})
      	{
        	Write-verbose "Copy File $($file.Name) to E:\CitrixVDA\PVSGen\TEST\" -verbose 
          	copy-item $File.FullName -destination E:\CitrixVDA\PVSGen\TEST\
      	}

        foreach ($file in get-childitem "E:\Jenkins\jobs\Test_VDA_Automation\workspace"| ? {$_.Name -match 'DevopsSrcControl'})
      	{
        	Write-verbose "Copy File $($file.Name) to E:\JenkinsJobs\VDA\configs\TEST\" -verbose 
          	copy-item $File.FullName -destination E:\JenkinsJobs\VDA\configs\TEST 
      	}
      
        foreach ($file in get-childitem "E:\Jenkins\jobs\Test_VDA_Automation\workspace"| ? {$_.Name -match 'MDTDeploy'})
      	{
        	Write-verbose "Copy File $($file.Name) to E:\JenkinsJobs\VDA\configs\TEST\" -verbose 
          	copy-item $File.FullName -destination E:\JenkinsJobs\VDA\configs\TEST 
      	}

        foreach ($file in get-childitem "E:\Jenkins\jobs\Test_VDA_Automation\workspace"| ? {$_.Name -match 'Administrator'})
      	{
        	Write-verbose "Copy File $($file.Name) to E:\JenkinsJobs\VDA\configs\TEST\" -verbose 
          	copy-item $File.FullName -destination E:\JenkinsJobs\VDA\configs\TEST 
      	}

        foreach ($file in get-childitem "E:\Jenkins\jobs\Test_VDA_Automation\workspace"| ? {$_.Name -match 'customsettings'})
      	{
        	Write-verbose "Copy File $($file.Name) to E:\JenkinsJobs\VDA\configs\TEST\" -verbose 
          	copy-item $File.FullName -destination E:\JenkinsJobs\VDA\configs\TEST 
      	}
      
    }
    Catch
    {
        $err1 = $error[0]
        Write-warning $err1
        exit 1
    }


