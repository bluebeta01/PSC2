#This is the script which should be run on all machines at startup.

Param(
    [Parameter(Mandatory=$true)]
    [string]$root
)

while($true)
{
	if ([System.IO.File]::Exists($root + "/KILLSWITCH"))
	{
		Exit -1
	}

    . $root/config.ps1
	
	powershell $root/runjobs.ps1
	
	Start-Sleep -Seconds $SLEEP_INTERVAL
}