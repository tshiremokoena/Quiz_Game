<#
Initializes a local git repository, makes the first commit, and prints next steps to push to GitHub.
Usage:
  .\init_repo.ps1
#>

Write-Host 'Initializing local git repository...' -ForegroundColor Cyan
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Host 'git not found in PATH. Please install Git and rerun the script.' -ForegroundColor Red
  exit 1
}

Set-Location -Path (Join-Path $PSScriptRoot '..')

if (-not (Test-Path -Path '.git')) {
  git init
  git add -A
  git commit -m "Initial commit: quiz game scaffold"
  Write-Host 'Repository initialized and initial commit created.' -ForegroundColor Green
} else {
  Write-Host 'Repository already initialized.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Next steps to push to GitHub:' -ForegroundColor Cyan
Write-Host '1) Create a repository on GitHub (do not initialize with README or .gitignore)'
Write-Host '2) Add the remote (replace URL):'
Write-Host "   git remote add origin https://github.com/<your-user>/<your-repo>.git"
Write-Host "3) Push to main branch: git branch -M main; git push -u origin main"

Write-Host ''
Write-Host 'After pushing, go to the repository Actions tab to run the workflow or wait for it to trigger on push.'
