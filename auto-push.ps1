# Auto-push script for Git
# This script watches for file changes and automatically commits and pushes

$workspacePath = "c:\Users\HP\OneDrive\Desktop\gitpush_sth ke sth"
Set-Location $workspacePath

Write-Host "Starting auto-push monitor..." -ForegroundColor Green
Write-Host "Any changes to files will be automatically committed and pushed to GitHub"
Write-Host "Press Ctrl+C to stop monitoring"
Write-Host ""

# Initialize the file watcher
$watcher = New-Object System.IO.FileSystemWatcher -Property @{
    Path = $workspacePath
    Filter = "*"
    IncludeSubdirectories = $true
    NotifyFilter = [System.IO.NotifyFilters]::LastWrite
}

# Get current status to skip temporary changes
git add -A
$lastCommit = git rev-parse HEAD 2>$null

# Function to handle file changes
$onChanged = {
    param($source, $eventArgs)
    
    # Ignore .git folder and temporary files
    if ($eventArgs.FullPath -match '\.git|\.tmp|\.lock' -or $eventArgs.Name -like '*.tmp') {
        return
    }
    
    # Small delay to ensure file is fully written
    Start-Sleep -Milliseconds 500
    
    # Check if there are actual changes
    $status = git status --porcelain
    if ($status) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Changes detected in: $($eventArgs.Name)" -ForegroundColor Yellow
        
        # Stage all changes
        git add -A
        
        # Create commit with timestamp
        $commitMessage = "Auto-commit: Changes to $($eventArgs.Name) on $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
        git commit -m $commitMessage
        
        # Push to GitHub
        git push -u origin main 2>$null
        if ($?) {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Successfully pushed changes!" -ForegroundColor Green
        } else {
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')] Push failed - make sure repository is set up on GitHub" -ForegroundColor Red
            Write-Host "Run: git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git" -ForegroundColor Cyan
        }
    }
}

# Register the event
Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $onChanged | Out-Null

# Keep the script running
while ($true) {
    Start-Sleep -Seconds 1
}
