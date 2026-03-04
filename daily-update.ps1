# Amazon Cases Tracker — Daily Automation Script
# Runs at 7:00 AM via Windows Task Scheduler
# Checks Missive for new case emails, updates HTML dashboard, pushes to GitHub

$WorkspaceDir = "C:\AI Workspaces\Claude Code Workspace - MS"
$CasesDir     = "C:\AI Workspaces\Claude Code Workspace - MS\projects\Amazon Cases"
$LogFile      = "C:\AI Workspaces\Claude Code Workspace - MS\projects\Amazon Cases\daily-update.log"
$ClaudePath   = "C:\Users\tommi\.local\bin\claude.exe"

function Log($msg) {
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$ts  $msg" | Tee-Object -FilePath $LogFile -Append
}

Log "=== Daily Amazon Cases Update START ==="

# 1. Pull latest from GitHub (in case colleague pushed changes)
Log "Pulling latest from GitHub..."
Set-Location $CasesDir
git pull origin main 2>&1 | ForEach-Object { Log $_ }

# 2. Run Claude Code — check Missive, update cases_core.md, regenerate HTML
Log "Running Claude Code — Missive check + HTML update..."
$Prompt = @"
Use the missive-reader skill to check for new Amazon case emails.
Update cases_core.md and regenerate amazon-cases-tracker.html.
Work in the directory: $CasesDir
"@

Set-Location $WorkspaceDir
& $ClaudePath --print $Prompt 2>&1 | ForEach-Object { Log $_ }

# 3. Stage, commit, push any changes
Log "Checking for changes to push..."
Set-Location $CasesDir
$changes = git status --porcelain
if ($changes) {
    $date = Get-Date -Format "yyyy-MM-dd"
    git add cases_core.md amazon-cases-tracker.html
    git commit -m "Daily update $date — new cases + HTML refresh" 2>&1 | ForEach-Object { Log $_ }
    git push origin main 2>&1 | ForEach-Object { Log $_ }
    Log "Pushed to GitHub."
} else {
    Log "No changes — nothing to push."
}

Log "=== Daily Amazon Cases Update END ==="
