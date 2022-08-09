#This script should be run by a job script ONLY if the job script
#has run successfully. This script will update the backend so
#that the should_run script will know when a script has run
#
# mark_success.ps1 -jobname <jobname> -hostname <hostname>
#
# -jobname is a name to uniquly identify this job
#
# -hostname is the hostname of the machine running the job

Param(
    [Parameter(Mandatory=$true)]
    [string]$jobname,
	
	[Parameter(Mandatory=$true)]
    [string]$hostname,
	
	[Parameter(Mandatory=$true)]
    [string]$root
)

. $root/config.ps1

if ([System.IO.Directory]::Exists($JOB_TRACKING_DIR + "/" + $jobname) -eq $false)
{
	[System.IO.Directory]::CreateDirectory($JOB_TRACKING_DIR + "/" + $jobname)
}

[System.IO.File]::WriteAllText($JOB_TRACKING_DIR + "/" + $jobname + "/" + $hostname, "success")