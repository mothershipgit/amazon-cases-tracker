# Run this script once as Administrator to register the daily task
# Right-click → "Run with PowerShell" (as Administrator)

$action  = New-ScheduledTaskAction `
    -Execute 'powershell.exe' `
    -Argument '-NonInteractive -WindowStyle Hidden -File "C:\AI Workspaces\Claude Code Workspace - MS\projects\Amazon Cases\daily-update.ps1"'

$trigger  = New-ScheduledTaskTrigger -Daily -At '07:00AM'
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Hours 1) -StartWhenAvailable

Register-ScheduledTask `
    -TaskName 'AmazonCasesDailyUpdate' `
    -Action   $action `
    -Trigger  $trigger `
    -Settings $settings `
    -RunLevel Highest `
    -Force

Write-Host "✓ Task 'AmazonCasesDailyUpdate' registered — runs daily at 07:00 AM" -ForegroundColor Green
