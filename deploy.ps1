if ([string]::IsNullOrEmpty($env:CMDER_ROOT)) {
    $env:CMDER_ROOT = 'C:\tools\Cmder'
}

$codeSettingsPath = "$home\AppData\Roaming\Code\User";
if ($IsLinux) {
    $codeSettingsPath = "$HOME/.config/Code/User"
}


if ($IsWindows) {
    Copy-Item .\user_profile.ps1 $env:CMDER_ROOT\config\ -Force
    Copy-Item .\prompt-char.txt "$env:CMDER_ROOT\config\prompt-char.txt"
    Copy-Item .\user-ConEmu.xml "$env:CMDER_ROOT\"
    Copy-Item -re -fo .\visual-studio\code-snippets\* "$env:USERPROFILE\Documents\Visual Studio 2015\Code Snippets\";
    Copy-Item .\shrug.txt "$HOME\" -Force
    Copy-Item icons $HOME
    Copy-Item .\ConEmu.xml "C:\tools\cmder\vendor\conemu-maximus5\ConEmu.xml"
}

Copy-Item -Force .\vscode-config\keybindings.json $codeSettingsPath
Copy-Item -Force -Recurse .\vscode-snippets\* $codeSettingsPath;
