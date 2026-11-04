# Universal Agent Memory v3.0 — Automated Installer (Windows PowerShell)
# Usage:
#   irm https://raw.githubusercontent.com/duychris/universal-agent-memory/main/install.ps1 | iex

param(
    [string]$Lang = "en"
)

$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/duychris/universal-agent-memory.git"
$SkillName = "universal-agent-memory"

$TmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ("uam-" + [System.Guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

try {
    Write-Host "Downloading Universal Agent Memory v3.0..." -ForegroundColor Cyan
    git clone --depth 1 $RepoUrl (Join-Path $TmpDir $SkillName) | Out-Null
    $SrcRoot = Join-Path $TmpDir $SkillName

    if ($Lang -eq "vi" -and (Test-Path (Join-Path $SrcRoot "i18n\vi"))) {
        $SkillSrc = Join-Path $SrcRoot "i18n\vi"
        Write-Host "Installing Vietnamese edition (--Lang vi)..." -ForegroundColor Green
    } else {
        $SkillSrc = $SrcRoot
        Write-Host "Installing International English edition (--Lang en)..." -ForegroundColor Green
    }

    $Targets = @(
        (Join-Path $env:USERPROFILE ".claude\skills\$SkillName"),
        (Join-Path $env:USERPROFILE ".agents\skills\$SkillName"),
        (Join-Path $env:USERPROFILE ".codex\skills\$SkillName"),
        (Join-Path $env:USERPROFILE ".gemini\config\skills\$SkillName")
    )

    foreach ($Dest in $Targets) {
        New-Item -ItemType Directory -Path $Dest -Force | Out-Null
        Copy-Item (Join-Path $SkillSrc "SKILL.md") (Join-Path $Dest "SKILL.md") -Force
        Copy-Item (Join-Path $SkillSrc "references") $Dest -Recurse -Force
        Copy-Item (Join-Path $SkillSrc "templates") $Dest -Recurse -Force
        Copy-Item (Join-Path $SkillSrc "rules") $Dest -Recurse -Force
        Write-Host "Installed Skill -> $Dest" -ForegroundColor Green
    }

    function Upsert-MarkerBlock($RuleFile, $TemplateFile) {
        if (-not (Test-Path $TemplateFile)) { return }
        $Parent = Split-Path -Parent $RuleFile
        if (-not (Test-Path $Parent)) { New-Item -ItemType Directory -Path $Parent -Force | Out-Null }
        if (-not (Test-Path $RuleFile)) { New-Item -ItemType File -Path $RuleFile -Force | Out-Null }

        $Tpl = Get-Content -Path $TemplateFile -Raw -Encoding UTF8
        if ($Tpl -match "(?s)(<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->)") {
            $Block = $Matches[1]
            $Content = Get-Content -Path $RuleFile -Raw -Encoding UTF8
            if ($null -eq $Content) { $Content = "" }
            if ($Content -match "(?s)<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->") {
                $NewContent = [regex]::Replace($Content, "(?s)<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->", $Block)
            } else {
                $NewContent = $Content.TrimEnd() + "`n`n" + $Block + "`n"
            }
            Set-Content -Path $RuleFile -Value $NewContent -Encoding UTF8
            Write-Host "Anchored Global Rules -> $RuleFile" -ForegroundColor Cyan
        }
    }

    Upsert-MarkerBlock (Join-Path $env:USERPROFILE ".claude\CLAUDE.md") (Join-Path $SkillSrc "rules\claude-code.md")
    Upsert-MarkerBlock (Join-Path $env:USERPROFILE ".codex\AGENTS.md") (Join-Path $SkillSrc "rules\codex.md")
    Upsert-MarkerBlock (Join-Path $env:USERPROFILE ".gemini\GEMINI.md") (Join-Path $SkillSrc "rules\gemini.md")

    Write-Host "`nUniversal Agent Memory v3.0 installed successfully!" -ForegroundColor Green
} finally {
    if (Test-Path $TmpDir) { Remove-Item -Recurse -Force $TmpDir }
}
