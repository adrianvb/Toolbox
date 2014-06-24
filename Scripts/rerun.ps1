Param(
	[Parameter(Mandatory=$true)] [String] $Path,
	[Parameter(Mandatory=$true)] [ScriptBlock] $Command
)

$Watcher = New-Object System.IO.FileSystemWatcher
$Watcher.Path = $Path
$Watcher.IncludeSubdirectories = $true
$Watcher.EnableRaisingEvents = $false
$Watcher.NotifyFilter = [System.IO.NotifyFilters]::LastWrite -bor [System.IO.NotifyFilters]::FileName
 
while($TRUE){
	$result = $Watcher.WaitForChanged([System.IO.WatcherChangeTypes]::Changed -bor [System.IO.WatcherChangeTypes]::Renamed -bOr [System.IO.WatcherChangeTypes]::Created, 1000);
	if($result.TimedOut){
		continue;
	}
	write-host ("Change in {0} " -f $result.Name)
	& $Command
}