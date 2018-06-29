Copy-Item "$env:CMDER_ROOT/config/user-profile.ps1" .
Copy-Item -re -fo $home\custom-scripts .\
