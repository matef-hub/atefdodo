# Run from a local clone of matef-hub/atefdodo in Windows PowerShell 7+
# Required: GitHub CLI (gh) signed in as matef-hub with repository and profile write permissions.
# Only public profile metadata and README are written. No credentials are stored by this script.
# Pins cannot currently be updated by GitHub's public REST/GraphQL APIs.
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
$owner = 'matef-hub'
$profileRepo = "$owner/$owner"
$sourceRepo = "$owner/atefdodo"
$readmePath = Join-Path (Split-Path $PSScriptRoot -Parent) 'README.md'

function Require-Gh {
  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI not installed. Install from https://cli.github.com/ and run 'gh auth login'."
  }
  & gh auth status | Out-Null
  if ($LASTEXITCODE -ne 0) { throw "Run 'gh auth login' with repository/profile permissions." }
  $login = (& gh api user --jq '.login').Trim()
  if ($LASTEXITCODE -ne 0 -or $login -ne $owner) {
    throw "Authenticated user '$login' is not '$owner'; stopping."
  }
}
function Api-Json([string]$method, [string]$path, $payload) {
  $json = $payload | ConvertTo-Json -Depth 12 -Compress
  $result = $json | & gh api -X $method $path -H 'Accept: application/vnd.github+json' --input -
  if ($LASTEXITCODE -ne 0) { throw "GitHub API failed: $method $path" }
  return $result | ConvertFrom-Json
}
function Repo-Exists([string]$name) {
  $null = & gh repo view $name --json name 2>$null
  return $LASTEXITCODE -eq 0
}
Require-Gh
if (-not (Test-Path -LiteralPath $readmePath)) { throw "Local README missing: $readmePath" }
Write-Host "Verified GitHub user: $owner"

# 1. Create the special public profile README repository if absent.
if (-not (Repo-Exists $profileRepo)) {
  & gh repo create $profileRepo --public --description 'Mohamed Atef — Egyptian Lawyer, Legal Tech & Applied AI' --add-readme
  if ($LASTEXITCODE -ne 0) { throw "Failed to create $profileRepo" }
  Write-Host "Created $profileRepo"
} else {
  Write-Host "Found existing $profileRepo"
}

# 2. Put the portfolio README at the repository root.
$raw = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
$base64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($raw))
$existingSha = (& gh api "repos/$profileRepo/contents/README.md" --jq '.sha' 2>$null)
$payload = @{
  message = 'docs(profile): publish original legal-tech portfolio'
  content = $base64
}
if ($LASTEXITCODE -eq 0 -and -not [string]::IsNullOrWhiteSpace($existingSha)) {
  $payload['sha'] = $existingSha.Trim()
}
$null = Api-Json 'PUT' "repos/$profileRepo/contents/README.md" $payload
Write-Host "Published profile README."

# 3. Update the account's public professional description.
$null = Api-Json 'PATCH' 'user' @{
  name = 'Mohamed Atef'
  bio = 'Egyptian lawyer building legal research, judicial workflows and AI-assisted legal systems | Arabic NLP · Android · Laravel'
  blog = 'https://ateflaw.com/'
}
Write-Host "Updated professional bio and site."

# 4. Correct project descriptions and topics. Restricted/private repositories are not modified.
$projects = @(
  @{name='ahkam-app'; desc='Egyptian case-law research and Arabic-aware judgment search'; topics=@('legal-tech','egyptian-law','arabic-search','case-law')},
  @{name='agenda'; desc='Arabic Flutter judicial agenda for hearings and legal office tasks'; topics=@('flutter','judicial-agenda','egyptian-law','sqlite')},
  @{name='Egyptian-Legal-Deadlines-Calculator'; desc='Android-first Egyptian procedural deadline calculator with reviewable legal rules'; topics=@('android','kotlin','legal-deadlines','egyptian-law')},
  @{name='SmartLawyer'; desc='Native Kotlin and Jetpack Compose legal practice management prototype'; topics=@('android','kotlin','jetpack-compose','legal-tech')},
  @{name='Legal-management-666'; desc='Laravel-based legal operations for documents, contracts and office workflows'; topics=@('laravel','php','legal-management','vuexy')},
  @{name='smart-lawyer-ai-training'; desc='Structured Egyptian legal text and Arabic NLP research experiments'; topics=@('arabic-nlp','legal-tech','egyptian-law','applied-ai')}
)
foreach ($project in $projects) {
  $repoName = "$owner/$($project.name)"
  if (-not (Repo-Exists $repoName)) { Write-Warning "Missing $repoName; skipped."; continue }
  $null = Api-Json 'PATCH' "repos/$repoName" @{description = $project.desc}
  $null = Api-Json 'PUT' "repos/$repoName/topics" @{names = $project.topics}
  Write-Host "Updated metadata: $repoName"
}

# 5. Enable GitHub Pages for the repository with the /docs static portfolio, using Actions.
try {
  $null = & gh api "repos/$sourceRepo/pages" --jq '.html_url' 2>$null
  if ($LASTEXITCODE -ne 0) {
    $null = Api-Json 'POST' "repos/$sourceRepo/pages" @{build_type='workflow'}
    Write-Host "Enabled GitHub Pages."
  } else {
    Write-Host "GitHub Pages already exists. Check Settings > Pages > Source = GitHub Actions."
  }
  & gh workflow run portfolio.yml --repo $sourceRepo
  if ($LASTEXITCODE -ne 0) { Write-Warning "Could not start workflow; trigger manually from Actions." }
} catch {
  Write-Warning "Pages could not be enabled through current CLI permissions. Use repository Settings > Pages > GitHub Actions."
}

Write-Host ""
Write-Host "Profile source: https://github.com/$profileRepo"
Write-Host "Portfolio Pages (after successful deployment): https://$owner.github.io/atefdodo/"
Write-Host "Remaining UI-only step: GitHub profile > Customize your pins > choose six featured repositories > Save."
