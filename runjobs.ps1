Param(
    [Parameter(Mandatory=$true)]
    [string]$root
)

$dirs = [System.IO.Directory]::GetDirectories($root + "/jobs")
foreach($dir in $dirs)
{
	$jobname = [System.IO.Path]::GetFileName($dir)
	powershell $dir/$jobname.ps1 -root $root
}