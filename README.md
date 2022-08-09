# PSC2 (Powershell Command and Control)
Powershell command and control framework for running scripts on client machines across a network created by Logan Klumpp

## What is this?
PSC2 was created a way to run a powershell script (called a "job") many machines very quickly. It was built to be deployed via Active Directory, but can be deployed in other ways as well. This simple framework allows us to very quickly run a job on every machine on the network or a subset of those machines.

## How it works
The script jobrunner.ps1 is configured to run at startup on every machine on the network. This script will periodically run all of the jobs in the "jobs" folder.

### Job Header Check
When a job starts up, it will first check whether or no it should actually execute. It does this by calling the should_run.ps1 script as well as doing any other custom checks unique to that job. The should_run.ps1 script is responsible for checking how long it has been since the job last ran on the machine and deciding if it is time to run again. Using should_run.ps1, a job can be configured to run only once on a given machine or perodically every so many minutes using the frequency parameter. Excatly how the should_run.ps1 script works is described in detail further down.

The job script may also do other checks upon execution, such as ensuring that the machine's hostname matches a hardcoded value to ensure the script only runs on one target machine, for example.

### Job Payload
Once the job script checks that it should actually run, it begins executing its payload. The framework provides a script called storage.ps1 which provides an easy way for jobs to store and retrive information using a key-value system. A job can store a powershell object at a key and later retrive the object back from that key later. This data is stored on the server that hosts the framework files and is non-volitile between runs. This means that the information that a job stores at a key will still be available the next time the job runs. An administrator can easily view all of the key-value pairs stored by the jobs, making this an effective way for jobs to report back information for data collection.

### Job Footer
At the end of every job, there will be a call to mark_success.ps1. This call should only happen in the event that the job script run successfully. This can be easily accomplished by ensuring that the default error action of the script is to stop execution so that this script isn't called unless there were no errors.

The mark_success.ps1 script is responsible for documenting to the framework that the job has run without errors. This information is referenced in the job's header the next time it is run to check if it should run again. Failing to call this script means that the job's call to should_run.ps1 will always succeed, meaning the job will run every time it is envoked without a way to stop it.

## Setup and Use
### Inital Setup
To setup the PSC2 framework on the network, simply place the framework files in a network share that all machines you want to run jobs can access. This share should be marked as read-only (when a job needs to store information, it will do so in a different directory which is configurable in the config.ps1 file). We will refer to this network share containg the PSC2 files the "PSC2 root directory" in the following steps.

The next step is to configure the config.ps1 file. This file contains variables that the framework needs in order to function. The file contains documentation on what each variable does. Configure each variable in that script accordingly before continuing.

Once the configuration is done, you're now ready configure your client machines to start running jobs. To do this, you simply need to have all of your client machines execute the jobrunner.ps1 powershell script at startup in the background and pass in the PSC2 root directory as a paramter called -root. In our evironment, we accomplish this using group policy by making jobrunner.ps1 a startup script on all of our machines. If you're not using active directory, you'll have to find some other way to have your machines execute this script at startup.

At this point, your machines should now be executing the jobrunner.ps1 script and are ready to execute jobs. This framework comes with an example of a job called log_pcinfo which should start running immediatly. This will provide a simple santiy check to demonstrate that the framwork is working. You should be able to naviagte to $JOB_TRACKING_DIR/log_pcinfo.ps1/ and see that there are files there corresponding to the hostnames of your client machines. If you've deployed the framework and are sure that jobrunner.ps1 is running and don't see this directory, something isn't configured correctly. If something isn't right, you can always run jobrunner.ps1 in a live powershell window to see any erors that it's encountering.

### Deploying Jobs
Jobs are just powershell scripts located in the "jobs" folder of the PSC2 root directory. A job should be placed in a folder of the same name. For example, a job called "get_windows_version" should be located at <PSC2 root directory>/jobs/get_windows_version/get_windows_version.ps1. It is best practice not to use whitespace in the name of your jobs, as this can cause issues when accessing directories.
  
Once a job file has be placed in its directory, all clients will start executing it the next time they check for jobs to run. You can prevent a job from running by appending a ".disabled" to the name of job script file.
  
You should refer to the example job called log_pcinfo included with this framework to better understand how jobs execute. You should use this job as a template for creating new jobs to ensure you don't leave out any important code. Failing to to execute the checks at the start of the job or forgetting the footer will cause the job to misbehave.

## File Descriptions
### config.ps1
This script defines several configuration varaibles that are used by the framework when executing jobs. This file should be edited accordingly when setting up the framework. You can find a description of every variable in that script. Varaibles referenced in this documentation come from this config file.

### mark_success.ps1
This script should be called at the end of a job when the job has completed without errors. This script will create a file called $JOB_TRACKING_DIR/<jobname>/<hostname>. This file is used to track the last time the job ran successfully on the host machine.

### should_run.ps1
This script is one of the first things envoked by a job script and is used to determined if the job should run. It returns $true if the job should run or $false if it should not. The script does this by taking in a frequency paramter indicating how many minutes the job should wait between executions. When envoked, the script will measure how long it has been since this job ran on this host by checking the last modified property of the file created by mark_success.ps1. If this file does not exist or is older that the frequency parameter, the script will return $true, otherwise it returns $false.
  
### storage.ps1
This script provides function for storing and retreiving key-value pairs. Keys are always strings and point to powershell objects. When a job creates a key, stored in a file called $JOB_STORAGE_DIR/<jobname>/<hostname>-<keyname>, for example "$JOB_STORAGE_DIR/testjob/johnpc-mykey".
