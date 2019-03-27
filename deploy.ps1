Copy-Item .\user-profile.ps1 $env:CMDER_ROOT\config\ -Force
Copy-Item .\prompt-char.txt "$env:CMDER_ROOT\config\prompt-char.txt"
Copy-Item -re -fo .\custom-scripts\* $home\custom-scripts
Copy-Item .\user-ConEmu.xml "$env:CMDER_ROOT\"
Copy-Item -re -fo .\visual-studio\code-snippets\* "$env:USERPROFILE\Documents\Visual Studio 2017\Code Snippets\"

$cwd = (Get-Item .).FullName

# export visual studio settings and copy here https://stackoverflow.com/a/48663477/1834329
$outFileName = "$cwd\visual-studio\vs17-settings.xml"
$filenameEscaped="`"$outFileName`""
$dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.15.0") 
$dte.ExecuteCommand("Tools.ImportandExportSettings", '/import:' + $filenameEscaped)