<#This is the directory where the framework will store the files it uses to track
when which clients have run which jobs. This directory should be a shared network
location which is readable and writable to all client machines. #>
$JOB_TRACKING_DIR = ""

<#This is the directory where the framework will store the key-value pairs that
are stored by jobs. This directory should be a shared network location which is
readable and writable to all client machines. #>
$JOB_STOREAGE_DIR = ""

<#This is how often (in seconds) the client machines will check for new jobs to
be run. Ex: 60 * 5 is five minutes.#>
$SLEEP_INTERVAL = 60 * 5