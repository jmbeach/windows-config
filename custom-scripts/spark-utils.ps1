function spark() {
	$sparkDir = 'D:\Users\Administrator\AppData\Local\CiscoSparkLauncher'
	$newestVersion = $(Get-ChildItem -Directory -Path $sparkDir | Select-Object -Last 1)
	& "$sparkDir\$newestVersion\SparkWindows.exe"
}
