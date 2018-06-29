function Hide-VsWindows {
    Get-Process *.vshost | ForEach-Object {
        try {
            $_.MainWindowHandle | Move-Window (Get-Desktop 2) | Out-Null
        } catch {}
    }
}

function Show-VsWindows {
    Get-Process *.vshost | ForEach-Object {
        try {
            $_.MainWindowHandle | Move-Window (Get-Desktop 0) | Out-Null
        } catch {}
    }
}