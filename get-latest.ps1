Copy-Item "$env:CMDER_ROOT/config/user-profile.ps1" .
Copy-Item -re -fo $home\custom-scripts .\
Copy-Item "$env:CMDER_ROOT\config\prompt-char.txt" .
Copy-Item "$env:CMDER_ROOT\config\user-ConEmu.xml" .
Copy-Item -re -fo "$env:USERPROFILE\Documents\Visual Studio 2017\Code Snippets\*" .\visual-studio\code-snippets