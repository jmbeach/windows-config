# Pre assign the hooks so the first run of cmder gets a working prompt.
[ScriptBlock]$PrePrompt = {
	Microsoft.PowerShell.Utility\Write-Host "$(Get-Date -f "MM-dd HH:mm:ss") " -NoNewLine -ForegroundColor Gray
}

[ScriptBlock]$PostPrompt = {
	Microsoft.PowerShell.Utility\Write-Host ">" -NoNewLine -ForegroundColor DarkGray
}
[ScriptBlock]$CmderPrompt = {
    $Host.UI.RawUI.ForegroundColor = "White"
	Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor DarkCyan
    checkGit($pwd.ProviderPath)
}

[ScriptBlock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE
    $host.UI.RawUI.WindowTitle = Microsoft.PowerShell.Management\Split-Path $pwd.ProviderPath -Leaf
    PrePrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    CmderPrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    PostPrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

## <Continue to add your own>
# Variables

$profile = "$env:CMDER_ROOT\config\user-profile.ps1"
$windir = "C:\Windows"
$big = "D:\"
$startup = "$home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$ghUsername = "jaredbeachdesign@gmail.com"
$chocoInstall = "C:\ProgramData\chocolatey\"
$hosts = "C:\Windows\System32\Drivers\etc\hosts"
$lockscreenimgs = "$home\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"
$programFiles = "C:\Program Files\"
$programFiles86 = "C:\Program Files (x86)\"
$programFiles86D = "D:\Program Files (x86)\"
$programFilesD = "D:\Program Files\"
$appDataLocal = "$env:APPDATA\..\Local"

# Aliases

Set-Alias -Name open -Value explorer -Option AllScope
Set-Alias -Name fortune -Value "C:\tools\cygwin\bin\fortune.exe" -Option AllScope
Set-Alias -Name grep -Value "C:\tools\cygwin\bin\grep.exe" -Option AllScope
Set-Alias -Name xsltproc -Value "C:\tools\cygwin\bin\xsltproc.exe" -Option AllScope
Set-Alias -Name shimgen -Value "$env:ChocolateyInstall\tools\shimgen.exe"
Set-Alias -Name ssms12-config -Value "C:\Windows\SysWOW64\SQLServerManager12.msc"
Set-Alias -Name ssms11-config -Value "C:\Windows\SysWOW64\SQLServerManager11.msc"

# Functions

function escape-string {
	$toEsc = $args[0]
	$chars = $toEsc.ToCharArray()
	$escaped = "";
	for ($i = 0; $i -lt $chars.Length; $i++) {
		$current = $chars[$i]
		if ($current -eq '"') {
			$escaped+= '"'
		}
		$escaped+= $current
	}
	$escaped
}

function go-big {
	cd $big
}

function go-home {
	cd $home
}

function go-code {
	cd "$home\Code"
}

function go-programs {
	cd $programFiles
}

function go-programs86 {
	cd $programFiles86
}

function go-williams {
	cd "$big\Code\Williams.International\AutomationEngine"
}

function restart-sqlexpress {
	net stop MSSQL"$"SQLEXPRESS
	net start MSSQL"$"SQLEXPRESS
}

function test-transform {
	$transform = $args[0]
	$fileName = $args[1]
	$out = $args[2] 
	$tempName = "temp$($out)"
	xsltproc $transform $fileName > $tempName
	xmllint --format $tempName
	xmllint --format $tempName > $out
	rm $tempName
}

function gh-create {
	$repoName = $args[0]
	$data = @{
		name=$repoName
	}
	$data | ConvertTo-Json -Compress | curl -H "Content-Type: application/json" -u $ghUsername https://api.github.com/user/repos -d "@-"
}

function notify-done {
	echo "done" | pb push
}

Function gig {
  param(
    [Parameter(Mandatory=$true)]
    [string[]]$list
  )
  $params = $list -join ","
  Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | select -ExpandProperty content
}

function register-chocolatey-functions() {
	$helpers = "$chocoInstall\helpers"
	Import-Module "$helpers\chocolateyInstaller.psm1"
}

# Settings

## Makes tab completion work like bash
Set-PSReadlineKeyHandler -Chord Tab -Function Complete

# Load other files
Get-ChildItem "$home\custom-scripts\utilities.ps1" | %{.$_}
Get-ChildItem "$home\custom-scripts\*.ps1" | %{.$_}

fortune
register-chocolatey-functions

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$env:PYTHONIOENCODING='utf-8'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-Alias ls "C:\tools\cygwin\bin\ls.exe" -Option AllScope