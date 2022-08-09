#This script is used to determine if a job should run. It should be called by
#the job script when the job script is envoked. This script will return true if
#the job should run and false if it should not. Usage listed below.
#
# should_run.ps1 -jobname <jobname> -hostname <hostname> -frequency <frequency>
#
# -jobname is a name to uniquly identify this job
#
# -hostname is the hostname of the machine running the job
#
# -frequency is how often the job should be run in minutes. The script will ensure
#that at least <frequency> minutes have passed since the last time the script was run.
#Setting this option to 0 means this script always return true and the job will run
#every time it is envoked. If the parameter is not supplied, it default to Int32.MaxValue

Param(
    [Parameter(Mandatory=$true)]
    [string]$jobname,
	
	[Parameter(Mandatory=$true)]
    [string]$hostname,
	
	[Parameter(Mandatory=$true)]
    [string]$root,
	
    [int]$frequency = [System.Int32]::MaxValue
)

. $root/config.ps1


if ([System.IO.Directory]::Exists($JOB_TRACKING_DIR + "/" + $jobname) -eq $false)
{
	return $true
}

if ([System.IO.File]::Exists($JOB_TRACKING_DIR + "/" + $jobname + "/" + $hostname) -eq $false)
{
	return $true
}
else
{
	$filetime = [System.IO.File]::GetLastWriteTime($JOB_TRACKING_DIR + "/" + $jobname + "/" + $hostname)
	$now = [System.DateTime]::Now
	$difference = $now.Subtract($filetime).TotalMinutes
	if ($difference -lt $frequency)
	{
		return $false
	}
	else
	{
		return $true
	}
}