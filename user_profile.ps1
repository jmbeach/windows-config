# Pre assign the hooks so the first run of cmder gets a working prompt.
[ScriptBlock]$PrePrompt = {
	Microsoft.PowerShell.Utility\Write-Host "$(Get-Date -f "MM-dd HH:mm:ss") " -NoNewLine -ForegroundColor Gray
}

[ScriptBlock]$PostPrompt = {
	$promptChar = Get-Content "$env:CMDER_ROOT\config\prompt-char.txt"
	Write-Host ">`n" -NoNewLine -ForegroundColor DarkGray
	Write-Host $promptChar -NoNewline -ForegroundColor Red
}

[ScriptBlock]$CmderPrompt = {
	$Host.UI.RawUI.ForegroundColor = "White"
	Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath.Replace($home, '~').Replace("C:\code\secure.ironguides.com\IronGuides.Web", "IG-Web") -NoNewLine -ForegroundColor DarkCyan
	Microsoft.PowerShell.Utility\Write-Host ' {' -ForegroundColor Green -NoNewLine 
	Microsoft.PowerShell.Utility\Write-Host (Get-IronConfig).activeTicket -NoNewLine 
	Microsoft.PowerShell.Utility\Write-Host '}' -ForegroundColor Green -NoNewLine
	checkGit($pwd.ProviderPath)
}

[ScriptBlock]$Prompt = {
	$realLASTEXITCODE = $LASTEXITCODE
	$host.UI.RawUI.WindowTitle = Microsoft.PowerShell.Management\Split-Path $pwd.ProviderPath -Leaf
	PrePrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
	CmderPrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
	PostPrompt | Microsoft.PowerShell.Utility\Write-Host  -NoNewline
	$global:LASTEXITCODE = $realLASTEXITCODE
	return " "
}

## <Continue to add your own>
# Variables

$userprofile = "$env:CMDER_ROOT\config\user_profile.ps1"
$startup = "$home\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"
$chocoInstall = "C:\ProgramData\chocolatey\"
$hosts = "C:\Windows\System32\Drivers\etc\hosts"
$lockscreenimgs = "$home\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"

# Aliases

Set-Alias -Name grep -Value "C:\tools\cygwin\bin\grep.exe" -Option AllScope
Set-Alias -Name checkout -Value Checkout-IronTicket
Set-Alias -Name build -Value Build-IronTicket
Set-Alias -Name test -Value Test-IronTicket
Set-Alias -Name jira -Value Open-JiraTicket
Set-Alias -Name list -Value List-IronTickets
Set-Alias -Name open -Value explorer -Option AllScope
Set-Alias -Name shimgen -Value "$env:ChocolateyInstall\tools\shimgen.exe"
Set-Alias -Name ss -Value Select-String
Set-Alias -Name ssms11-config -Value "C:\Windows\SysWOW64\SQLServerManager11.msc"
Set-Alias -Name ssms12-config -Value "C:\Windows\SysWOW64\SQLServerManager12.msc"
Set-Alias -Name status -Value Get-IronTicketStatus
Set-Alias -Name todos -Value List-IronTicketTodos
Set-Alias -Name qube -Value Get-IronQubeIssues
Set-Alias -Name speak -Value Start-GoogleTTS
Set-Alias -Name xsltproc -Value "C:\tools\cygwin\bin\xsltproc.exe" -Option AllScope

# Functions

Function gig {
  param(
    [Parameter(Mandatory=$true)]
    [string[]]$list
  )
  $params = $list -join ","
  Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | select -ExpandProperty content
}
# Settings

## Makes tab completion work like bash
Set-PSReadlineKeyHandler -Chord Tab -Function Complete

# Load other files
Get-ChildItem "$home\custom-scripts\*.ps1" | %{.$_}
Get-ChildItem "$home\private-custom-scripts\*.ps1" | Where-Object {$_.Name -notlike '*profile.ps1' } | %{.$_}

$homeUnix = $HOME.Replace("\", "/").Replace("Copen:", "")

$env:PYTHONIOENCODING='utf-8'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-Item -Path function:\PrePrompt   -Value $PrePrompt   -Options Constant
Set-Item -Path function:\CmderPrompt -Value $CmderPrompt -Options Constant
Set-Item -Path function:\PostPrompt  -Value $PostPrompt  -Options Constant

# Functions can be made constant only at creation time
# ReadOnly at least requires `-force` to be overwritten
if (!$(get-command Prompt).Options -match 'ReadOnly') {Set-Item -Path function:\prompt  -Value $Prompt  -Options ReadOnly}
Set-Item -Path function:\prompt  -Value $Prompt  -Options ReadOnly
function Get-ChildItemPretty () {
	$children = Get-ChildItem;
	$dirs = $children | Where-Object {$_.PSIsContainer};
	$files = $children | Where-Object {-not $_.PSIsContainer};
	$foreground = $host.ui.RawUI.ForegroundColor
	$host.ui.RawUI.ForegroundColor = 'Magenta';
	$dirs | Sort-Object {$_.Name} | Format-Wide -Property {$_.Name} -AutoSize;
	$host.ui.RawUI.ForegroundColor = $foreground;
	$files | Sort-Object {$_.Name} | Write-Host;
}

Set-Alias -Name ls -Value Get-ChildItemPretty -Option AllScope
Import-Module $HOME\Code\github\jmbeach\Windows-screenFetch\windows-screenfetch.psd1
Import-Module $HOME\custom-scripts\gulp-completion.psm1
Add-Type -Path "$home\bin\nuget_packages\HtmlAgilityPack.1.11.24\lib\netstandard2.0\HtmlAgilityPack.dll"
clear