<#
This file provies the storage API functions to be called from within job scripts
#>


function Get-KeyExists
{
    <#
    .Description
    Returns a bool indicating whether or not the provided key exists
    #>
    param(
    [Parameter(Mandatory=$true)]
    [string]$jobname,
	
	[Parameter(Mandatory=$true)]
    [string]$hostname,
	
	[Parameter(Mandatory=$true)]
    [string]$root,

    [Parameter(Mandatory=$true)]
    [string]$keyname
    )

    . $root/config.ps1

    return [System.IO.File]::Exists($JOB_STOREAGE_DIR + "/" + $jobname + "/" + $hostname + "-" + $keyname)
}

function Set-Key
{
    <#
    .Description
    Sets a key to a given object. May throw an exception if the key cannot be created
    #>
    param(
    [Parameter(Mandatory=$true)]
    [string]$jobname,
	
	[Parameter(Mandatory=$true)]
    [string]$hostname,
	
	[Parameter(Mandatory=$true)]
    [string]$root,

    [Parameter(Mandatory=$true)]
    [string]$keyname,

    [Parameter(Mandatory=$true)]
    [System.Object]$keyvalue
    )

    . $root/config.ps1

    if ([System.IO.Directory]::Exists($JOB_STOREAGE_DIR + "/" + $jobname) -eq $false)
    {
        [System.IO.Directory]::CreateDirectory($JOB_STOREAGE_DIR + "/" + $jobname)
    }

    [System.IO.File]::WriteAllText($JOB_STOREAGE_DIR + "/" + $jobname + "/" + $hostname + "-" + $keyname, [System.Management.Automation.PSSerializer]::Serialize($keyvalue))
}