Copy-Item "$env:CMDER_ROOT/config/user-profile.ps1" .
Copy-Item -re -fo $home\custom-scripts .\
Copy-Item "$env:CMDER_ROOT\config\prompt-char.txt" .
Copy-Item "$env:CMDER_ROOT\config\user-ConEmu.xml" .
Copy-Item -re -fo "$env:USERPROFILE\Documents\Visual Studio 2017\Code Snippets\*" .\visual-studio\code-snippets

$cwd = (Get-Item .).FullName

# export visual studio settings and copy here https://stackoverflow.com/a/48663477/1834329
$outFileName = "$cwd\visual-studio\vs17-settings.xml"
$filenameEscaped="`"$outFileName`""
$dte = [System.Runtime.InteropServices.Marshal]::GetActiveObject("VisualStudio.DTE.15.0") 
$dte.ExecuteCommand("Tools.ImportandExportSettings", '/export:'+$filenameEscaped)