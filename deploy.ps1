Copy-Item .\user-profile.ps1 $env:CMDER_ROOT\config\ -Force
Copy-Item .\prompt-char.txt "$env:CMDER_ROOT\config\prompt-char.txt"
Copy-Item -re .\custom-scripts $home
Copy-Item .\user-ConEmu.xml "$env:CMDER_ROOT\"
Copy-Item .\visual-studio\code-snippets\* "$env:USERPROFILE\Documents\Visual Studio 2017\Code Snippets\"