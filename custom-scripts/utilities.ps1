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

function Get-EmojiShrug () {
	Get-Content $home\shrug.txt
}

function Get-Randomizer () {
	[string]$seedString = [System.DateTime]::Now.Ticks.ToString();
	$length = 9;
	$smaller = $seedString.Substring($seedString.Length - $length, $length);
	$seed = [System.Convert]::ToInt32($smaller) - $i;
	$rand = [System.Random]::new($seed);
	return $rand;
}

function Get-RandomText ($length = 10, [switch]$alphaNumeric = $false, [switch]$numeric = $false, [switch]$alpha = $false) {
	$text = '';
	$nonAlphaNumeric = @(
		58,59,60,61,62,63,64,91,92,93,94,95,96
	);

	for ($i = 0; $i -lt $length; $i++) {
		$start = 32;
		$end = 126;
		if ($alphaNumeric) {
			$start = 48;
			$end = 122;
		} elseif ($numeric) {
			$start = 48;
			$end = 57;
		} elseif ($alpha) {
			$start = 65;
			$end = 122;
		}

		$rand = Get-Randomizer;
		$rando = $rand.Next($start, $end);

		# re-roll
		while (($alphaNumeric -or $alpha) -and $nonAlphaNumeric.Contains($rando)) {
			$rand = Get-Randomizer;
			$rando = $rand.Next($start, $end);
		}

		$text += [System.Convert]::ToChar($rando);
	}

	return $text;
}

function Get-RunningProcessCount () {
	$i = 0
	tasklist | sort | foreach { $i = $i + 1 }
	Write-Host $i
}

function tasklist-v () {
	Get-Process | foreach {
		$_ | Format-Table Name, Id, CPU, PrivateMemorySize, Path
	}
}

function Kill-Unessential () {
	$killable = Get-JsonFromFile('~/custom-scripts/unessential.json')
	$killable.processes | foreach {
		if ($_.type -eq 'service') {
			$fullName = $_.name
			net stop $fullName /yes
		}
		else {
			try {
				Get-Process $_.name -EA SilentlyContinue | Stop-Process -Force
			} catch {}
		}
	}
}

function Destroy-SearchUI {
	Get-Process SearchUI | Stop-Process
  Move-Item "C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy\" "C:\Windows\SystemApps\Microsoft.Windows.Cortana_cw5n1h2txyewy.bak" -Force
}

function Kill-Vmware {
	taskkill /F /IM vmware*
}

function Get-UserGroups($userName) {
	(New-Object System.DirectoryServices.DirectorySearcher("(&(objectCategory=User)(samAccountName=$($userName)))")).FindOne().GetDirectoryEntry().memberOf
}

function Get-Wallpapers() {
	$location = "$HOME\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
	dir $location | foreach {
		if ($_.Length -lt 100kb) { return }
		cp $_.FullName $("$home\Pictures\Wallpapers\" + $_.Name + ".jpg");
	}
}