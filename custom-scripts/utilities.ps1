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

function Convert-Pdfs2Txt () {
	Get-ChildItem *.pdf | foreach { python C:\Python27\Scripts\pdf2txt.py $_.Name | Out-File -Encoding ascii $($_.Name + '.txt') }
}

function Convert-ObjectToHash ($asObj) {
	$result = @{};
	$asObj.PSObject.Properties | ForEach-Object {
        $result[$_.Name] = $_.Value;
    }
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

function Kill-NonDefault () {
	$defaultProcesses = Get-Content "$HOME\custom-scripts\default-processes.txt";
	$processes = Get-Process | Where-Object {-not $defaultProcesses.Contains($_.Name)}
	$defaultServices = Get-Content "$HOME\custom-scripts\default-services.txt";
	$services = Get-Service | Where-Object {-not $defaultServices.Contains($_.Name)}
	$services | ForEach-Object {
		Write-Host $('Stopping service "' + $_.Name + '".');
		Get-Service $_.Name | Stop-Service -Force;
	}

	$processes | ForEach-Object {
		Write-Host $('Stopping process "' + $_.Name + '".');
		Get-Process $_.Name | Stop-Process -Force;
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

function Write-Tabular([array]$list, [scriptblock]$highlightExpression, $headerUnderlineColor, $highlightColor, [switch]$debug = $false) {
	$first = $list[0];
    $members = $first | Get-Member | Where-Object { $_.MemberType -ne 'Method' };

	if ($null -eq $headerUnderlineColor) {
		$headerUnderlineColor = 'Blue';
	}

	if ($null -eq $highlightColor) {
		$highlightColor = 'Blue';
	}

	$writingDetails = @{};
	for ($i = 0; $i -lt $members.Length; $i++) {
		$member = $members[$i];
		$writingDetails[$member.Name] = @{
			maxLength = $member.Name.Length;
		}
	}

	$list | ForEach-Object {
		$item = $_;
		$members | ForEach-Object {
			$member = $_;
			$details = $writingDetails[$member.Name];
			if ($item.PSObject.Properties[$member.Name].Value.ToString().Length -gt $details.maxLength) {
				$writingDetails[$member.Name].maxLength = $item.PSObject.Properties[$member.Name].Value.ToString().Length;
			}
		}
    }
    
    function get-tabCount([string]$val, $details) {
        $debugInfo = '';
        $factorRaw = $val.Length / $details.maxLength;
        $factor = [System.Math]::Round($factorRaw * 10) / 10;

        $tabCount = 0;
        $maxTabs = [System.Math]::Floor($details.maxLength / 8);
        if ($val.Length -ne $details.maxLength) {
            $tabCount = [System.Math]::Round((1 - $factor) * $maxTabs);
            if ($maxTabs % 2 -ne 0 -and $factorRaw -gt 0.5 -and $factorRaw -lt 0.55) {
                $tabCount--
            }
            if ($factor -eq 0 -and $maxTabs -gt 0) {
                $tabCount = $maxTabs - 1;
            } elseif ($factor -lt 0.21 -and $maxTabs -gt 0) {
                $tabCount++;
            }

            if ($factor -gt 0 -and $factor -lt 0.11 -and $maxTabs -gt 0) {
                $tabCount = $maxTabs;
            }

            if ($maxTabs -eq 1 -and $factorRaw -lt 0.7) {
                $tabCount = 1;
            }
        }

        $debugInfo = 'fr:' + [System.Math]::Round($factorRaw, 2) + ',f:' + [System.Math]::Round($factor, 2) + ',m:' + $maxTabs + ',t:' + $tabCount + '|';

        $result = @{
            DebugInfo = $debugInfo;
            TabCount = $tabCount;
        }
        return $result;
    }

	$header = '';
	$underline = '';
	for ($i = 0; $i -lt $members.Length; $i++) {
		$member = $members[$i];
		$details = $writingDetails[$member.Name];
        $tabCountResult = get-tabCount -val $member.Name -details $details;
        $tabCount = $tabCountResult.TabCount;
		$header += $member.Name;
		$(1..$member.Name.Length) | ForEach-Object { $underline += "=" };
		if ($tabCount -gt 0 -and $i -ne $members.Length - 1) {
			$(1..$tabCount) | ForEach-Object { $header += "`t" };
			$(1..$tabCount) | ForEach-Object { $underline += "========" }
		}

		if ($i -ne $members.Length - 1) {
			$header += "`t|`t";
			$underline += "`t|`t";
		}
	}

	Write-Host $header;
	$underlines = $underline.Split("|");
	for ($i = 0; $i -lt $underlines.Length; $i++) {
		$underline = $underlines[$i];
		Write-Host -NoNewline -ForegroundColor $headerUnderlineColor $underline
		if ($i -ne $underlines.Length - 1) {
			Write-Host "|" -NoNewline
		}
	}

	# Adds a new line after the underline section of header
	Write-Host

	$list | ForEach-Object {
		$item = $_
        $line = '';

        $debugInfo = '--';
		for ($j = 0; $j -lt $members.Length; $j++) {
            $member = $members[$j];
			$val = $item.PSObject.Properties[$member.Name].Value.ToString();
            $details = $writingDetails[$member.Name];
            $tabCountResult = get-tabCount -val $val -details $details;
            $tabCount = $tabCountResult.TabCount;
            $debugInfo += $tabCountResult.DebugInfo;
			$line += $val
			if ($tabCount -gt 0 -and $j -ne $members.Length - 1) {
				$(1..$tabCount) | ForEach-Object { $line += "`t" };
			}

			if ($j -ne $members.Length - 1) {
                $line += "`t|`t"
            }
		}

		if ($null -ne $highlightExpression -and $($item | &$highlightExpression)) {
			$lineParts = $line.Split('|');
			for ($j = 0; $j -lt $lineParts.Length; $j++) {
				$part = $lineParts[$j];
				Write-Host -ForegroundColor $highlightColor $part -NoNewline;
				if ($j -ne $lineParts.Length - 1) {
					Write-Host "|" -NoNewline;
				}
            }
            
            if ($debug) {
                Write-Host $debugInfo -NoNewline
            }

			Write-Host;
		} else {
            Write-Host $line -NoNewline
            if ($debug) {
                Write-Host $debugInfo -NoNewline
            }

            Write-Host
		}
	}
}