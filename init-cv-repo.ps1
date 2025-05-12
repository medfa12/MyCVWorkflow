param(
    [string]$RepoName = ".",      # use current folder
    [switch]$SetupRemote,
    [string]$RemoteUrl
)

# ---------- prerequisites ----------
if (-not (Get-Command git -EA SilentlyContinue)) {
    Write-Error "Git not in PATH"; exit 1
}
if (-not (Get-Command pandoc -EA SilentlyContinue)) {
    Write-Error "Pandoc not in PATH"; exit 1
}

# ---------- repo initialisation ----------
if (-not (Test-Path ".git")) {
    git init | Out-Null
}

# ---------- local DOCX build ----------
pandoc resume_us.md -o resume_us.docx --from gfm
pandoc cv_eu.md     -o cv_eu.docx    --from gfm

# ---------- first commit ----------
git add .
git commit -m "Initial CV workflow" | Out-Null

# ---------- optional remote ----------
if ($SetupRemote) {
    if ([string]::IsNullOrWhiteSpace($RemoteUrl)) {
        Write-Error "-SetupRemote needs -RemoteUrl <url>"
    } else {
        git remote add origin $RemoteUrl
        git branch -M main
        git push -u origin main
    }
}

Write-Host "`n✔ Done.  DOCX files generated:"
Get-ChildItem *.docx
