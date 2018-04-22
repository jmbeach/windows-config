function findProgram ([string] $programName) {
	Get-ChildItem -Path $programFiles -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $programFiles86 -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $programFiles86D -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $programFilesD -Recurse -Include $("*" + $programName + "*.exe")
	Get-ChildItem -Path $appDataLocal -Recurse -Include $("*" + $programName + "*.exe")
}

function Replace-Tabs([string] $fileName, [int] $spaceCount) {
	if (!$spaceCount -eq 0) {
		(Get-Content $fileName).Replace("`t", "    ") | Out-File $fileName -Encoding ascii
		return
	}

	$strTab = "";
	
	for ($i = 0; $i -lt $spaceCount; $i = $i + 1) {
		$strTab += " "
	}

	(Get-Content $fileName).Replace("`t", $strTab) | Out-File $fileName -Encoding ascii
	return
}

function Shorten-SpaceTabs([string] $fileName) {
	(Get-Content $fileName).Replace("    ", "  ") | Out-File $fileName -Encoding ascii
	return
}

function Replace-Newlines([string] $fileName) {
	(Get-Content $fileName).Replace("`r`n", "`n") | Out-File $fileName -Encoding ascii
	return
}

function Make-GmailSendable([string] $fileName) {
	$newName = $fileName.Replace("exe", "abc")
	$finalName = $fileName.Replace("exe", "123")
	$zipName = $fileName.Replace("exe", "zip")

	Copy-Item $fileName $newName

	7z a "$zipName" "$newName"

	Copy-Item $zipName $finalName
}
