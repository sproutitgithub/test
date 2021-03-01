#region Step 3
$ErrorActionPreference="Silentlycontinue"
$importWSMAN = import-csv E:\JenkinsJobs\Configurations\RDSPVS\RDSWSMAN.csv
IF (!($importWSMAN))
{
    exit 1
}
ELSE
{
    $TcpPort="445"
    $AllSMBCheck =  foreach ($computer in $importWSMAN | ? {$_.connected -match 'true'})
        {
        try 
            {
                Write-Verbose "Attempting connection to $TcpPort on computer $($computer.name)" -Verbose
                $socket = new-object Net.Sockets.TcpClient
                $socket.Connect($Computer.name, $TcpPort)
                $status = "Open"
                $socket.Close()
            } 
            catch 
            {
                $status = 'Closed'
            } 
            finally 
            {
               $obj  = [pscustomobject]@{
               NAME = $Computer.name
               TCPPORT = $TcpPort
               STATUS = $status
               }
        $obj
        }
    }
}
$AllSMBCheck = $AllSMBCheck | Sort NAME
$ActiveComputers = $AllSMBCheck | sort 
$ActiveComputers | Export-Csv E:\JenkinsJobs\Configurations\RDSPVS\RDSSMB.csv -NoTypeInformation
#endregion 