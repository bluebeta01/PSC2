#This is an example of a job that will print hello world every minute

Param(
	[Parameter(Mandatory=$true)]
    [string]$root
)
$ErrorActionPreference = "Stop"
. $root/config.ps1
$JOBNAME = "example_job_1"
$HOSTNAME = hostname
if((powershell $root/should_run.ps1 -jobname $JOBNAME -hostname $HOSTNAME -root $root -frequency 1) -eq $false)
{
	return
}
	

#Do Stuff
Write-Host Hello World



powershell $root/mark_success.ps1 -jobname $JOBNAME -hostname $HOSTNAME -root $root