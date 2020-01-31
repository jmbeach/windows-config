if ([string]::IsNullOrEmpty($env:CMDER_ROOT)) {
    $env:CMDER_ROOT = 'C:\tools\Cmder'
}

Copy-Item .\user_profile.ps1 $env:CMDER_ROOT\config\ -Force
Copy-Item .\prompt-char.txt "$env:CMDER_ROOT\config\prompt-char.txt"
Copy-Item .\user-ConEmu.xml "$env:CMDER_ROOT\"
Copy-Item -re -fo .\visual-studio\code-snippets\* "$env:USERPROFILE\Documents\Visual Studio 2015\Code Snippets\"
Copy-Item -Force .\vscode-config\* $home\AppData\Roaming\Code\User
Copy-Item .\shrug.txt "$HOME\" -Force
Copy-Item icons $HOME

$cwd = (Get-Item .).FullName

# export visual studio settings and copy here https://stackoverflow.com/a/48663477/1834329
$outFileName = "$cwd\visual-studio\vs17-settings.xml"
$filenameEscaped="`"$outFileName`""
$dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.15.0") 
$dte.ExecuteCommand("Tools.ImportandExportSettings", '/import:' + $filenameEscaped)