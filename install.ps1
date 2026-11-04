# Universal Agent Memory v3.0 — Automated Installer (Windows PowerShell)
# Usage:
#   # Option 1 (Recommended — Download, inspect, and run with parameters):
#   Invoke-WebRequest -Uri "https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.ps1" -OutFile "install.ps1"
#   .\install.ps1 -Lang vi -Platform all
#
#   # Option 2 (One-liner):
#   irm https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.ps1 | iex
#   & ([scriptblock]::Create((irm https://raw.githubusercontent.com/duychris/universal-agent-memory/v3.0.0/install.ps1))) -Lang vi

param(
    [string]$Lang = "en",
    [string]$Platform = "all",
    [string]$Ref = "main",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

if ($Lang -ne "en" -and $Lang -ne "vi") {
    throw "Unsupported -Lang '$Lang'. Allowed values: en, vi."
}

$WantClaude = $false
$WantCodex = $false
$WantGemini = $false
$WantAntigravity = $false

foreach ($p in ($Platform -split ",")) {
    $cleanP = $p.Trim().ToLowerInvariant()
    switch ($cleanP) {
        "all" {
            $WantClaude = $true
            $WantCodex = $true
            $WantGemini = $true
            $WantAntigravity = $true
        }
        "claude" { $WantClaude = $true }
        "codex" { $WantCodex = $true }
        "gemini" { $WantGemini = $true }
        "antigravity" { $WantAntigravity = $true }
        default {
            throw "Unsupported platform '$p'. Allowed values: all, claude, codex, gemini, antigravity."
        }
    }
}

$HomeDir = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }
if (-not $HomeDir -or -not (Test-Path -LiteralPath $HomeDir)) {
    throw "Could not resolve a valid user home directory (`$env:USERPROFILE or `$HOME)."
}

$RepoUrl = if ($env:UAM_REPO_URL) { $env:UAM_REPO_URL } else { "https://github.com/duychris/universal-agent-memory.git" }
$SkillName = "universal-agent-memory"
$Timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
$TmpDir = $null

try {
    if ($PSScriptRoot -and (Test-Path -LiteralPath (Join-Path $PSScriptRoot "SKILL.md"))) {
        $SrcRoot = $PSScriptRoot
    } else {
        if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
            throw "'git' is required to download Universal Agent Memory when running remotely, but was not found in PATH."
        }
        $TmpDir = Join-Path ([System.IO.Path]::GetTempPath()) ("uam-" + [System.Guid]::NewGuid().ToString("N"))
        New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

        Write-Host "Downloading Universal Agent Memory ($Ref) from $RepoUrl ..." -ForegroundColor Cyan
        $CloneTarget = Join-Path $TmpDir $SkillName
        & git clone --depth 1 --branch $Ref $RepoUrl $CloneTarget 2>&1 | Out-Null
        if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath (Join-Path $CloneTarget "SKILL.md"))) {
            throw "Failed to clone $RepoUrl (ref: $Ref, exit code: $LASTEXITCODE). Check network connectivity and git ref."
        }
        $SrcRoot = $CloneTarget
    }

    if ($Lang -eq "vi") {
        $SkillSrc = Join-Path $SrcRoot "i18n\vi"
        Write-Host "Selected Vietnamese edition (-Lang vi)" -ForegroundColor Green
    } else {
        $SkillSrc = $SrcRoot
        Write-Host "Selected International English edition (-Lang en)" -ForegroundColor Green
    }

    # Preflight: Verify all required source files exist before touching user directories
    $RequiredItems = @(
        (Join-Path $SkillSrc "SKILL.md"),
        (Join-Path $SkillSrc "README.md"),
        (Join-Path $SkillSrc "HDSD.md"),
        (Join-Path $SkillSrc "RELEASE-NOTES.md"),
        (Join-Path $SkillSrc "TEST-CASES.md"),
        (Join-Path $SrcRoot "LICENSE"),
        (Join-Path $SkillSrc "references"),
        (Join-Path $SkillSrc "rules"),
        (Join-Path $SkillSrc "templates"),
        (Join-Path $SkillSrc "examples")
    )
    foreach ($item in $RequiredItems) {
        if (-not (Test-Path -LiteralPath $item)) {
            throw "Source package is incomplete; missing required path: $item"
        }
    }

    $SkillTargets = New-Object System.Collections.Generic.List[string]
    $RuleTargets = New-Object System.Collections.Generic.List[hashtable]

    function Add-SkillTarget([string]$Path) {
        if (-not $SkillTargets.Contains($Path)) {
            $SkillTargets.Add($Path)
        }
    }

    function Add-RuleTarget([string]$RuleFile, [string]$TemplateFile) {
        foreach ($existing in $RuleTargets) {
            if ($existing.RuleFile -eq $RuleFile) { return }
        }
        $RuleTargets.Add(@{ RuleFile = $RuleFile; TemplateFile = $TemplateFile })
    }

    if ($WantClaude) {
        Add-SkillTarget (Join-Path $HomeDir ".claude\skills\$SkillName")
        Add-RuleTarget (Join-Path $HomeDir ".claude\CLAUDE.md") (Join-Path $SkillSrc "rules\claude-code.md")
    }
    if ($WantCodex) {
        Add-SkillTarget (Join-Path $HomeDir ".agents\skills\$SkillName")
        Add-RuleTarget (Join-Path $HomeDir ".codex\AGENTS.md") (Join-Path $SkillSrc "rules\codex.md")
    }
    if ($WantGemini) {
        Add-SkillTarget (Join-Path $HomeDir ".agents\skills\$SkillName")
        Add-RuleTarget (Join-Path $HomeDir ".gemini\GEMINI.md") (Join-Path $SkillSrc "rules\gemini.md")
    }
    if ($WantAntigravity) {
        Add-SkillTarget (Join-Path $HomeDir ".gemini\config\skills\$SkillName")
        Add-RuleTarget (Join-Path $HomeDir ".gemini\GEMINI.md") (Join-Path $SkillSrc "rules\gemini.md")
    }

    # Preflight: Validate marker integrity in all target Global Rules files BEFORE modifying anything
    $BeginMarker = "<!-- UAM-V3:BEGIN -->"
    $EndMarker = "<!-- UAM-V3:END -->"

    foreach ($rt in $RuleTargets) {
        $rFile = $rt.RuleFile
        $tFile = $rt.TemplateFile
        if (-not (Test-Path -LiteralPath $tFile)) {
            throw "Missing rule template file: $tFile"
        }
        $tplContent = [System.IO.File]::ReadAllText($tFile, [System.Text.Encoding]::UTF8)
        $tplBeginCount = ([regex]::Matches($tplContent, [regex]::Escape($BeginMarker))).Count
        $tplEndCount = ([regex]::Matches($tplContent, [regex]::Escape($EndMarker))).Count
        if ($tplBeginCount -ne 1 -or $tplEndCount -ne 1 -or $tplContent.IndexOf($BeginMarker) -gt $tplContent.IndexOf($EndMarker)) {
            throw "Malformed UAM-V3 markers in template: $tFile"
        }

        if (Test-Path -LiteralPath $rFile) {
            $existingContent = [System.IO.File]::ReadAllText($rFile, [System.Text.Encoding]::UTF8)
            $bCount = ([regex]::Matches($existingContent, [regex]::Escape($BeginMarker))).Count
            $eCount = ([regex]::Matches($existingContent, [regex]::Escape($EndMarker))).Count
            if ($bCount -ne $eCount) {
                throw "Unbalanced UAM-V3 markers in $rFile (BEGIN=$bCount, END=$eCount). Aborting without modifying any files."
            }
            if ($bCount -gt 1) {
                throw "Duplicate UAM-V3 marker blocks ($bCount blocks) found in $rFile. Aborting without modifying any files."
            }
            if ($bCount -eq 1 -and $existingContent.IndexOf($BeginMarker) -gt $existingContent.IndexOf($EndMarker)) {
                throw "Inverted UAM-V3 markers (END appears before BEGIN) in $rFile. Aborting without modifying any files."
            }
        }
    }

    # Build managed files map (relative path -> absolute source path)
    $ManagedFiles = @{}
    $TopFiles = @("SKILL.md", "README.md", "HDSD.md", "RELEASE-NOTES.md", "TEST-CASES.md")
    if ($Lang -eq "en" -and (Test-Path -LiteralPath (Join-Path $SkillSrc "README.vi.md"))) {
        $TopFiles += "README.vi.md"
    }
    foreach ($tf in $TopFiles) {
        $ManagedFiles[$tf] = (Join-Path $SkillSrc $tf)
    }
    $ManagedFiles["LICENSE"] = (Join-Path $SrcRoot "LICENSE")

    foreach ($sub in @("references", "rules", "templates", "examples")) {
        $subDir = Join-Path $SkillSrc $sub
        Get-ChildItem -LiteralPath $subDir -Recurse -File | ForEach-Object {
            $rel = $_.FullName.Substring($SkillSrc.Length).TrimStart('\', '/')
            $ManagedFiles[$rel] = $_.FullName
        }
    }

    foreach ($Dest in $SkillTargets) {
        $DestExists = Test-Path -LiteralPath $Dest
        $ModifiedExisting = New-Object System.Collections.Generic.List[string]
        $CustomFiles = New-Object System.Collections.Generic.List[string]

        if ($DestExists) {
            Get-ChildItem -LiteralPath $Dest -Recurse -File | ForEach-Object {
                $relDst = $_.FullName.Substring($Dest.Length).TrimStart('\', '/')
                if ($ManagedFiles.ContainsKey($relDst)) {
                    $srcHash = (Get-FileHash -LiteralPath $ManagedFiles[$relDst] -Algorithm SHA256).Hash
                    $dstHash = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
                    if ($srcHash -ne $dstHash) {
                        $ModifiedExisting.Add($relDst)
                    }
                } else {
                    $CustomFiles.Add($relDst)
                }
            }
        }

        if ($DryRun) {
            if (-not $DestExists) {
                Write-Host "[DRY-RUN] Would create and install Skill ($($ManagedFiles.Count) files) -> $Dest" -ForegroundColor Yellow
            } elseif ($ModifiedExisting.Count -gt 0) {
                Write-Host "[DRY-RUN] Would backup $($ModifiedExisting.Count) modified file(s) to $Dest.uam-backup-$Timestamp and update Skill -> $Dest" -ForegroundColor Yellow
            } else {
                Write-Host "[DRY-RUN] Skill already up to date (0 file changes) -> $Dest" -ForegroundColor Yellow
            }
            if ($CustomFiles.Count -gt 0) {
                Write-Host "[DRY-RUN] Would preserve $($CustomFiles.Count) custom user file(s) in $Dest" -ForegroundColor Cyan
            }
            continue
        }

        if ($DestExists -and $ModifiedExisting.Count -gt 0) {
            $BackupDir = "$Dest.uam-backup-$Timestamp"
            foreach ($rel in $ModifiedExisting) {
                $srcToBak = Join-Path $Dest $rel
                $dstBak = Join-Path $BackupDir $rel
                $bakParent = Split-Path -Parent $dstBak
                if (-not (Test-Path -LiteralPath $bakParent)) {
                    New-Item -ItemType Directory -Path $bakParent -Force | Out-Null
                }
                Copy-Item -LiteralPath $srcToBak -Destination $dstBak -Force
            }
            Write-Host "Backed up $($ModifiedExisting.Count) modified Skill file(s) -> $BackupDir" -ForegroundColor Cyan
        }

        foreach ($kv in $ManagedFiles.GetEnumerator()) {
            $dstFile = Join-Path $Dest $kv.Key
            $dstParent = Split-Path -Parent $dstFile
            if (-not (Test-Path -LiteralPath $dstParent)) {
                New-Item -ItemType Directory -Path $dstParent -Force | Out-Null
            }
            Copy-Item -LiteralPath $kv.Value -Destination $dstFile -Force
        }

        if (-not $DestExists) {
            Write-Host "Installed Skill ($($ManagedFiles.Count) files) -> $Dest" -ForegroundColor Green
        } elseif ($ModifiedExisting.Count -gt 0) {
            Write-Host "Updated Skill ($($ModifiedExisting.Count) file(s) updated) -> $Dest" -ForegroundColor Green
        } else {
            Write-Host "Skill already up to date -> $Dest" -ForegroundColor Green
        }

        if ($CustomFiles.Count -gt 0) {
            Write-Host "Preserved $($CustomFiles.Count) custom user file(s) in $Dest" -ForegroundColor Cyan
        }
    }

    $LegacyCodexSkill = Join-Path $HomeDir ".codex\skills\$SkillName"
    if ($WantCodex -and (Test-Path -LiteralPath $LegacyCodexSkill)) {
        Write-Host "WARNING: Detected legacy duplicate skill directory at $LegacyCodexSkill." -ForegroundColor Yellow
        Write-Host "OpenAI Codex uses $(Join-Path $HomeDir ".agents\skills\$SkillName") as the canonical user skill path." -ForegroundColor Yellow
    }

    $Utf8NoBom = New-Object System.Text.UTF8Encoding($false)

    foreach ($rt in $RuleTargets) {
        $RuleFile = $rt.RuleFile
        $TemplateFile = $rt.TemplateFile
        $Tpl = [System.IO.File]::ReadAllText($TemplateFile, [System.Text.Encoding]::UTF8)
        if ($Tpl -match "(?s)(<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->)") {
            $Block = $Matches[1]
            $FileExisted = Test-Path -LiteralPath $RuleFile
            $Content = if ($FileExisted) { [System.IO.File]::ReadAllText($RuleFile, [System.Text.Encoding]::UTF8) } else { "" }

            if ($Content -match "(?s)<!-- UAM-V3:BEGIN -->.*?<!-- UAM-V3:END -->") {
                $bIdx = $Content.IndexOf($BeginMarker)
                $eIdx = $Content.IndexOf($EndMarker) + $EndMarker.Length
                $NewContent = $Content.Substring(0, $bIdx) + $Block + $Content.Substring($eIdx)
            } else {
                if ($Content.Length -gt 0) {
                    $Sep = if ($Content.EndsWith("`n`n") -or $Content.EndsWith("`r`n`r`n")) { "" } elseif ($Content.EndsWith("`n")) { "`n" } else { "`n`n" }
                    $NewContent = $Content + $Sep + $Block + "`n"
                } else {
                    $NewContent = $Block + "`n"
                }
            }

            if ($FileExisted -and $NewContent -eq $Content) {
                if ($DryRun) {
                    Write-Host "[DRY-RUN] Global Rules already up to date (no changes) -> $RuleFile" -ForegroundColor Yellow
                } else {
                    Write-Host "Global Rules already up to date -> $RuleFile" -ForegroundColor Green
                }
                continue
            }

            if ($DryRun) {
                if ($FileExisted -and $Content.Trim().Length -gt 0) {
                    Write-Host "[DRY-RUN] Would backup $RuleFile -> $RuleFile.uam-backup-$Timestamp and update UAM-V3 block" -ForegroundColor Yellow
                } else {
                    Write-Host "[DRY-RUN] Would create Global Rules with UAM-V3 block -> $RuleFile" -ForegroundColor Yellow
                }
                continue
            }

            $Parent = Split-Path -Parent $RuleFile
            if (-not (Test-Path -LiteralPath $Parent)) {
                New-Item -ItemType Directory -Path $Parent -Force | Out-Null
            }
            if ($FileExisted -and $Content.Trim().Length -gt 0) {
                $BackupPath = "$RuleFile.uam-backup-$Timestamp"
                Copy-Item -LiteralPath $RuleFile -Destination $BackupPath -Force
                Write-Host "Backed up existing Global Rules -> $BackupPath" -ForegroundColor Cyan
            }

            [System.IO.File]::WriteAllText($RuleFile, $NewContent, $Utf8NoBom)
            Write-Host "Anchored Global Rules -> $RuleFile" -ForegroundColor Cyan
        }
    }

    if ($DryRun) {
        Write-Host "`nDry-run complete. No files were created or modified." -ForegroundColor Yellow
    } else {
        Write-Host "`nUniversal Agent Memory v3.0 setup complete!" -ForegroundColor Green
    }
} finally {
    if ($TmpDir -and (Test-Path -LiteralPath $TmpDir)) {
        Remove-Item -LiteralPath $TmpDir -Recurse -Force
    }
}
