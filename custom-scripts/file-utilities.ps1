function findProgram ([string] $programName) {
	Get-ChildItem -Path $programFiles -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $programFiles86 -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $programFiles86D -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $programFilesD -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $appDataLocal -Recurse -Include $("*" + $programName + "*.exe")
}
