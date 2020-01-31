if ([string]::IsNullOrEmpty($env:CMDER_ROOT)) {
    $env:CMDER_ROOT = 'C:\tools\Cmder'
}

Copy-Item "$env:CMDER_ROOT/config/user_profile.ps1" .
Copy-Item "$env:CMDER_ROOT\config\prompt-char.txt" .
Copy-Item "$env:CMDER_ROOT\config\user-ConEmu.xml" .
Copy-Item -re -fo "$env:USERPROFILE\Documents\Visual Studio 2017\Code Snippets\*" .\visual-studio\code-snippets

$cwd = (Get-Item .).FullName

# export visual studio settings and copy here https://stackoverflow.com/a/48663477/1834329
$outFileName = "$cwd\visual-studio\vs15-settings.xml"
$filenameEscaped="`"$outFileName`""
$dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.14.0") 
$dte.ExecuteCommand("Tools.ImportandExportSettings", '/export:'+$filenameEscaped)

# get vs code settings and copy here
if (![System.IO.Directory]::Exists("$cwd\vscode-config"))
{
    mkdir ".\vscode-config"
}

$codeFolder = "$home\AppData\Roaming\Code\User";
Copy-Item "$codeFolder\settings.json","$codeFolder\keybindings.json" ".\vscode-config"
Copy-Item -Recurse "$codeFolder\snippets" ".\vscode-snippets"