function Get-GitCurrentBranch() {
    [string]$branchLine = git branch | select-string -SimpleMatch '*'
    return $branchLine.Replace("*", "").Trim()
}

function Set-GitUpstreamMatch($remote) {
    if ($remote -eq $null -or $remote -eq "") {
        $remote = "origin"
    }

    $currentBranch = Get-GitCurrentBranch
    git branch --set-upstream-to=$remote/$currentBranch
}