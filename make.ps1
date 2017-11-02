$customScriptsPath = "$home\custom-scripts"
xcopy /Y /E "$customScriptsPath" ".\custom-scripts"
Copy-Item -Path $profile -Destination ".\" -Force
