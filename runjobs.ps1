<#
This script should be called periodically by the client to run any jobs
that are available to be run
#>

Param(
    #The PSC2 root
    [Parameter(Mandatory=$true)]
    [string]$root
)

$dirs = [System.IO.Directory]::GetDirectories($root + "/jobs")
foreach($dir in $dirs)
{
	$jobname = [System.IO.Path]::GetFileName($dir)
	powershell $dir/$jobname.ps1 -root $root
}