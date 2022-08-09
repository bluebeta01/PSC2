<#	
This script should be run by a job script ONLY if the job script
has run successfully. This script will update the backend so
that the should_run script will know the last time a job has run
#>

Param(
	#The name of the job being run
    [Parameter(Mandatory=$true)]
    [string]$jobname,
	
	#The hostname of the client machine running the job
	[Parameter(Mandatory=$true)]
    [string]$hostname,
	
	#The PSC2 root
	[Parameter(Mandatory=$true)]
    [string]$root
)

. $root/config.ps1

if ([System.IO.Directory]::Exists($JOB_TRACKING_DIR + "/" + $jobname) -eq $false)
{
	[System.IO.Directory]::CreateDirectory($JOB_TRACKING_DIR + "/" + $jobname)
}

[System.IO.File]::WriteAllText($JOB_TRACKING_DIR + "/" + $jobname + "/" + $hostname, "success")