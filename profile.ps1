# Init Script for PowerShell
# Created as part of cmder project

# !!! THIS FILE IS OVERWRITTEN WHEN CMDER IS UPDATED
# !!! Use "%CMDER_ROOT%\config\user-profile.ps1" to add your own startup commands

# We do this for Powershell as Admin Sessions because CMDER_ROOT is not beng set.
if (! $ENV:CMDER_ROOT ) {
    $ENV:CMDER_ROOT = resolve-path( $ENV:ConEmuDir + "\..\.." )
}

# Remove trailing '\'
$ENV:CMDER_ROOT = (($ENV:CMDER_ROOT).trimend("\"))

# Compatibility with PS major versions <= 2
if(!$PSScriptRoot) {
    $PSScriptRoot = Split-Path $Script:MyInvocation.MyCommand.Path
}

# Add Cmder modules directory to the autoload path.
$CmderModulePath = Join-path $PSScriptRoot "psmodules/"

if( -not $env:PSModulePath.Contains($CmderModulePath) ){
    $env:PSModulePath = $env:PSModulePath.Insert(0, "$CmderModulePath;")
}


try {
    # Check if git is on PATH, i.e. Git already installed on system
    Get-command -Name "git" -ErrorAction Stop >$null
} catch {
    $env:Path += $(";" + $env:CMDER_ROOT + "\vendor\git-for-windows\cmd")
    # for bash.exe, which in the cmd version is found as <GIT>\usr\bin\bash.exe
    $env:Path += $(";" + $env:CMDER_ROOT + "\vendor\git-for-windows\bin")
}

$gitLoaded = $false
function Import-Git($Loaded){
    if($Loaded) { return }
    $GitModule = Get-Module -Name Posh-Git -ListAvailable
    if($GitModule | select version | where version -le ([version]"0.6.1.20160330")){
        Import-Module Posh-Git > $null
    }
    if(-not ($GitModule) ) {
        Write-Warning "Missing git support, install posh-git with 'Install-Module posh-git' and restart cmder."
    }
    # Make sure we only run once by alawys returning true
    return $true
}

function checkGit($Path) {
    if (Test-Path -Path (Join-Path $Path '.git') ) {
        $gitLoaded = Import-Git $gitLoaded
        Write-VcsStatus
        return
    }
    $SplitPath = split-path $path
    if ($SplitPath) {
        checkGit($SplitPath)
    }
}

# Move to the wanted location
# This is either a env variable set by the user or the result of
# cmder.exe setting this variable due to a commandline argument or a "cmder here"
if ( $ENV:CMDER_START ) {
    Set-Location -Path "$ENV:CMDER_START"
}

if (Get-Module PSReadline -ErrorAction "SilentlyContinue") {
    Set-PSReadlineOption -ExtraPromptLineCount 1
}

# Enhance Path
$env:Path = "$Env:CMDER_ROOT\bin;$env:Path;$Env:CMDER_ROOT"

# Drop *.ps1 files into "$ENV:CMDER_ROOT\config\profile.d"
# to source them at startup.
if (-not (test-path "$ENV:CMDER_ROOT\config\profile.d")) {
  mkdir "$ENV:CMDER_ROOT\config\profile.d"
}

pushd $ENV:CMDER_ROOT\config\profile.d
foreach ($x in ls *.ps1) {
  # write-host write-host Sourcing $x
  . $x
}
popd

#
# Prompt Section
#   Users should modify their user-profile.ps1 as it will be safe from updates.
#

# Pre assign the hooks so the first run of cmder gets a working prompt.
[ScriptBlock]$PrePrompt = {}
[ScriptBlock]$PostPrompt = {}
[ScriptBlock]$CmderPrompt = {
    $Host.UI.RawUI.ForegroundColor = "White"
    Microsoft.PowerShell.Utility\Write-Host $pwd.ProviderPath -NoNewLine -ForegroundColor Green
    checkGit($pwd.ProviderPath)
}

$CmderUserProfilePath = Join-Path $env:CMDER_ROOT "config\user-profile.ps1"
if(Test-Path $CmderUserProfilePath) {
    # Create this file and place your own command in there.
    . "$CmderUserProfilePath"
} else {
# This multiline string cannot be indented, for this reason I've not indented the whole block

Write-Host -BackgroundColor Darkgreen -ForegroundColor White "First Run: Creating user startup file: $CmderUserProfilePath"

$UserProfileTemplate = @'
# Use this file to run your own startup commands

## Prompt Customization
<#
.SYNTAX
    <PrePrompt><CMDER DEFAULT>
    > <PostPrompt> <repl input>
.EXAMPLE
    <PrePrompt>N:\Documents\src\cmder [master]
    > <PostPrompt> |
#>

[ScriptBlock]$PrePrompt = {

}

# Replace the cmder prompt entirely with this.
# [ScriptBlock]$CmderPrompt = {}

[ScriptBlock]$PostPrompt = {

}

## <Continue to add your own>


'@

New-Item -ItemType File -Path $CmderUserProfilePath -Value $UserProfileTemplate > $null

}

# Once Created these code blocks cannot be overwritten
Set-Item -Path function:\PrePrompt   -Value $PrePrompt   -Options Constant
Set-Item -Path function:\CmderPrompt -Value $CmderPrompt -Options Constant
Set-Item -Path function:\PostPrompt  -Value $PostPrompt  -Options Constant

<#
This scriptblock runs every time the prompt is returned.
Explicitly use functions from MS namespace to protect from being overridden in the user session.
Custom prompt functions are loaded in as constants to get the same behaviour
#>
[ScriptBlock]$Prompt = {
    $realLASTEXITCODE = $LASTEXITCODE
    $host.UI.RawUI.WindowTitle = Microsoft.PowerShell.Management\Split-Path $pwd.ProviderPath -Leaf
    PrePrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    CmderPrompt
    Microsoft.PowerShell.Utility\Write-Host "`n> " -NoNewLine -ForegroundColor "DarkGray"
    PostPrompt | Microsoft.PowerShell.Utility\Write-Host -NoNewline
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

# Functions can be made constant only at creation time
# ReadOnly at least requires `-force` to be overwritten
Set-Item -Path function:\prompt  -Value $Prompt  -Options ReadOnly

#########################################
# Custom edits below this line
#########################################

# Variables

$profile = "C:\tools\cmder\vendor\conemu-maximus5\..\profile.ps1"
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

Set-Alias -Name gimp -Value "C:\Program Files\GIMP 2\bin\gimp-2.8.exe"
Set-Alias -Name clink -Value "C:\Program Files (x86)\clink\0.4.8\clink.lua"
Set-Alias -Name java -Value "C:\Program Files (x86)\Java\jdk1.8.0_111\bin\java.exe" -Option AllScope
Set-Alias -Name atom -Value "$home\AppData\Local\atom\atom.exe" -Option AllScope
Set-Alias -Name xmllint -Value "C:\cygwin\bin\xmllint.exe" -Option AllScope
Set-Alias -Name curl -Value "C:\cygwin\bin\curl.exe" -Option AllScope
Set-Alias -Name echo -Value "C:\cygwin\bin\echo.exe" -Option AllScope
Set-Alias -Name rm -Value "C:\cygwin\bin\rm.exe" -Option AllScope
Set-Alias -Name ssh -Value "C:\cygwin\bin\ssh.exe" -Option AllScope
Set-Alias -Name rsync -Value "C:\cygwin\bin\rsync.exe" -Option AllScope
Set-Alias -Name pandoc -Value "$home\AppData\Local\Pandoc\pandoc.exe" -Option AllScope
Set-Alias -Name rdp -Value "$windir\system32\mstsc.exe" -Option AllScope
Set-Alias -Name bitrix -Value "D:\Program Files (x86)\Bitrix24\Bitrix24.exe" -Option AllScope
Set-Alias -Name rapidee -Value "C:\Program Files\RapidEE\rapidee.exe" -Option AllScope
Set-Alias -Name bash -Value "C:\Windows\System32\bash.exe" -Option AllScope
Set-Alias -Name open -Value explorer -Option AllScope
Set-Alias -Name make -Value "C:\cygwin\bin\make.exe" -Option AllScope
Set-Alias -Name fortune -Value "C:\cygwin\bin\fortune.exe" -Option AllScope
Set-Alias -Name grep -Value "C:\cygwin\bin\grep.exe" -Option AllScope
Set-Alias -Name xsltproc -Value "C:\cygwin\bin\xsltproc.exe" -Option AllScope
Set-Alias -Name more -Value "C:\msys32\usr\bin\more.exe" -Option AllScope
Set-Alias -Name dotpeek -Value "D:\Users\Administrator\AppData\Local\JetBrains\Installations\dotPeek09\dotpeek64.exe"
Set-Alias -Name angryip -Value "C:\Program Files\Angry IP Scanner\ipscan.exe"
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
	cd "$big\Code"
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

iex fortune
register-chocolatey-functions
# have to register ls later because of stupid chocolatey
Set-Alias -Name ls -Value "$home\bin\ls.exe" -Option AllScope

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$env:PYTHONIOENCODING='utf-8'
Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
refreshenv
