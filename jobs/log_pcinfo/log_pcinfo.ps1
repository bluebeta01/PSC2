<#
This is an example job which should be used as a template for creating other job scripts.
It runs every 5 minutes and logs some information about the client machine
#>

<#
BEGIN_JOB_HEADER
This is a basic job header. Every job must start with this code. You can extend this header
code to include addtional checks to determine if the job should run. In this example,
the job will run every 5 minutes. You can change the $FREQUENCY variable to change this.
#>
Param(
	[Parameter(Mandatory=$true)]
    [string]$root
)
$ErrorActionPreference = "Stop"
. $root/config.ps1
. $root/storage.ps1
$JOBNAME = $MyInvocation.MyCommand.Name
$HOSTNAME = hostname
$FREQUENCY = 5
if((powershell $root/should_run.ps1 -jobname $JOBNAME -hostname $HOSTNAME -root $root -frequency $FREQUENCY) -eq $false)
{
	return
}
#END_JOB_HEADER
	


#This is where all of the job code should go
$pcinfo = Get-ComputerInfo
Set-Key -jobname $JOBNAME -hostname $HOSTNAME -root $root -keyname "pcinfo" -keyvalue $pcinfo




#This call should be made at the end of every job ONLY when the job completed successfully.
powershell $root/mark_success.ps1 -jobname $JOBNAME -hostname $HOSTNAME -root $root