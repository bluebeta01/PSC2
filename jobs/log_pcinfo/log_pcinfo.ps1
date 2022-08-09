#This is an example script which should be used as a template for creating other job scripts.

#BEGIN_JOB_HEADER This is the job header. Every job must start with this code.
#Job freqency can be changed in the call to should_run.ps1
Param(
	[Parameter(Mandatory=$true)]
    [string]$root
)
$ErrorActionPreference = "Stop"
. $root/config.ps1
. $root/storage.ps1
$JOBNAME = $MyInvocation.MyCommand.Name
$HOSTNAME = hostname
if((powershell $root/should_run.ps1 -jobname $JOBNAME -hostname $HOSTNAME -root $root -frequency 1) -eq $false)
{
	return
}
#END_JOB_HEADER
	



$pcinfo = Get-ComputerInfo
Set-Key -jobname $JOBNAME -hostname $HOSTNAME -root $root -keyname "pcinfo" -keyvalue $pcinfo




#This call should be made at the end of every job ONLY when the job completed successfully.
powershell $root/mark_success.ps1 -jobname $JOBNAME -hostname $HOSTNAME -root $root