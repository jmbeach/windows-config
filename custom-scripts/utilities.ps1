function Get-JsonFromFile([string] $filePath) {
	return Get-Content -Raw -Path $filePath | ConvertFrom-Json
}

function Search-C-FileName([string] $fileName, [string] $fileType) {
	if (!($fileType -eq '')) {
		Get-ChildItem -Path C:\ -Filter *$fileName* -Include *.$fileType -Recurse
	}
	else {
		Get-ChildItem -Path C:\ -Filter *$fileName* -Recurse
	}
}

function go-yfai () {
	cd D:\Code\Customers\yfai\
}

function Convert-Pdfs2Txt () {
	Get-ChildItem *.pdf | foreach { python C:\Python27\Scripts\pdf2txt.py $_.Name | Out-File -Encoding ascii $($_.Name + '.txt') }
}

function Convert-Htmls2Txt () {
	Get-ChildItem -r *.html | foreach { pandoc $_.Name -o $($_.Name + '.txt') }
}

function Convert-Pdf2Txt () {
	python C:\Python27\Scripts\pdf2txt.py $1 | Out-File -Encoding ascii $($1 + '.txt') 
}

function Get-RunningProcessCount () {
	$i = 0
	tasklist | sort | foreach { $i = $i + 1 }
	Write-Host $i
}

function Kill-LeastUseful () {
	$killable = @(
		"DMedia",
		"FBAgent",
		"openvpn-gui",
		"OneDrive",
		"openvpnserv",
		"TeamViewer",
		"TeamViewer_Service",
		"tvnserver",
		"Wexflow.Clients.WindowsService")
	$killable | foreach {
		taskkill /F /IM $($_ + ".exe")
	}
}

function Kill-Vmware {
	taskkill /F /IM vmware*
}
