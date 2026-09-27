param(
    [string]$Path,
    [string]$Lang
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host
$Host.UI.RawUI.WindowTitle = "MOD REMOVER TOOL v4.0"

# ---------------------------------------------------------------------------
# Language strings
# ---------------------------------------------------------------------------
$Strings = @{
    "en" = @{
        promptPath          = "Drag and drop the game folder here, or paste its path:"
        errorNotFound       = "[ERROR] Folder not found: {0}"
        pressEnterQuit      = "Press Enter to quit"
        analyzing           = "Scanning: {0}"
        modFile             = "  [MOD FILE]   "
        modDir              = "  [MOD FOLDER] "
        noModsFound         = "[OK] No mods detected. The game looks clean!"
        pressEnterClose     = "Press Enter to close"
        itemsDetected       = "{0} item(s) detected."
        whatToDo            = "What do you want to do?"
        optionPreview       = "  [1] Preview only (nothing is changed)"
        optionHolster       = "  [2] Holster mods  -> move to _BACKUP_MODS (keeps structure)"
        optionRestore       = "  [3] Restore mods  <- put everything back from _BACKUP_MODS"
        optionDelete        = "  [4] Permanent delete (mods are erased after confirmation)"
        optionCancel        = "  [5] Cancel"
        noChanges           = "No changes made."
        moved               = " [HOLSTERED] "
        restored            = " [RESTORED]  "
        deleted             = " [DELETED]   "
        failed              = " [FAILED]    "
        doneMsg             = "Done: {0} succeeded, {1} failed."
        logSaved            = "Log saved to: {0}"
        logHeader           = "Mod Remover Tool v4.0 - log from {0}"
        logTarget           = "Target folder: {0}"
        logTotal            = "Total: {0} succeeded, {1} failed"
        logOk               = "OK     - {0} -> {1}"
        logFail             = "FAILED - {0} : {1}"
        supportLine         = "Found this useful? {0}"
        restoreEmpty        = "[INFO] No backup found in _BACKUP_MODS. Nothing to restore."
        confirmDelete       = "Type DELETE (in capitals) to permanently erase the detected mods:"
        confirmDeleteWrong  = "Confirmation failed. Nothing was deleted."
        deepModeAsk         = "Enable Deep Scan for this Rockstar game? (y/N) - catches almost everything not vanilla"
        deepEnabled         = "Deep Scan enabled (whitelist mode)."
        structureNote       = "Backup keeps full folder structure for perfect restore."
        autoDetectHint      = "Tip: common install paths will be suggested if you leave empty."
        gameDetected        = "Detected game type: {0}"
        backupExists        = "Existing backup found in _BACKUP_MODS ({0} items)."
    }
    "fr" = @{
        promptPath          = "Glisse-depose le dossier du jeu ici, ou colle son chemin :"
        errorNotFound       = "[ERREUR] Dossier introuvable : {0}"
        pressEnterQuit      = "Appuie sur Entree pour quitter"
        analyzing           = "Analyse de : {0}"
        modFile             = "  [FICHIER MOD]  "
        modDir              = "  [DOSSIER MOD]  "
        noModsFound         = "[OK] Aucun mod detecte. Le jeu a l'air propre !"
        pressEnterClose     = "Appuie sur Entree pour fermer"
        itemsDetected       = "{0} element(s) detecte(s)."
        whatToDo            = "Que veux-tu faire ?"
        optionPreview       = "  [1] Apercu seulement (ne modifie rien)"
        optionHolster       = "  [2] Holster les mods  -> deplace vers _BACKUP_MODS (garde la structure)"
        optionRestore       = "  [3] Restaurer les mods <- remet tout depuis _BACKUP_MODS"
        optionDelete        = "  [4] Suppression definitive (apres confirmation)"
        optionCancel        = "  [5] Annuler"
        noChanges           = "Aucune modification effectuee."
        moved               = " [HOLSTERE]  "
        restored            = " [RESTAURE]  "
        deleted             = " [SUPPRIME]  "
        failed              = " [ECHEC]     "
        doneMsg             = "Termine : {0} reussi(s), {1} echec(s)."
        logSaved            = "Log enregistre dans : {0}"
        logHeader           = "Mod Remover Tool v4.0 - log du {0}"
        logTarget           = "Dossier cible : {0}"
        logTotal            = "Total : {0} reussi(s), {1} echec(s)"
        logOk               = "OK    - {0} -> {1}"
        logFail             = "ECHEC - {0} : {1}"
        supportLine         = "Cet outil t'a ete utile ? {0}"
        restoreEmpty        = "[INFO] Aucun backup trouve dans _BACKUP_MODS. Rien a restaurer."
        confirmDelete       = "Tape DELETE (en majuscules) pour effacer definitivement les mods detectes :"
        confirmDeleteWrong  = "Confirmation ratee. Rien n'a ete supprime."
        deepModeAsk         = "Activer le Deep Scan pour ce jeu Rockstar ? (o/N) - attrape presque tout ce qui n'est pas vanilla"
        deepEnabled         = "Deep Scan active (mode whitelist)."
        structureNote       = "Le backup conserve toute l'arborescence pour une restauration parfaite."
        autoDetectHint      = "Astuce : des chemins d'installation courants seront proposes si tu laisses vide."
        gameDetected        = "Type de jeu detecte : {0}"
        backupExists        = "Backup existant trouve dans _BACKUP_MODS ({0} elements)."
    }
}

$DonateUrl = "https://liberapay.com/LifeEaseWorks/donate"

$selectedLang = "en"
if ($Lang) {
    $candidate = $Lang.ToLower()
    if ($Strings.ContainsKey($candidate)) { $selectedLang = $candidate }
}
else {
    $systemLang = (Get-Culture).TwoLetterISOLanguageName.ToLower()
    if ($Strings.ContainsKey($systemLang)) { $selectedLang = $systemLang }
}
$T = $Strings[$selectedLang]

Write-Host ""
Write-Host "===================================================================================" -ForegroundColor Cyan
Write-Host "                    --- MOD REMOVER TOOL v4.0 ---" -ForegroundColor Magenta
Write-Host "          Holster / Restore / Deep Scan / Multi-game" -ForegroundColor DarkCyan
Write-Host "===================================================================================" -ForegroundColor Cyan
Write-Host ""

# ---------------------------------------------------------------------------
# Path handling
# ---------------------------------------------------------------------------
if ([string]::IsNullOrWhiteSpace($Path)) {
    Write-Host $T.promptPath -ForegroundColor White
    Write-Host $T.autoDetectHint -ForegroundColor DarkGray
    $rawPath = Read-Host " > "
    $Path = $rawPath.Trim('"')
}

$targetDir = $Path.Trim('"')

if (-not (Test-Path -Path $targetDir -PathType Container)) {
    Write-Host ($T.errorNotFound -f $targetDir) -ForegroundColor Red
    Read-Host $T.pressEnterQuit
    exit 1
}

$backupDir = Join-Path $targetDir "_BACKUP_MODS"
$logFile   = Join-Path $targetDir ("_BACKUP_MODS_log_{0}.txt" -f (Get-Date -Format "yyyyMMdd_HHmmss"))

# ---------------------------------------------------------------------------
# Official / system folders that must NEVER be scanned or touched
# ---------------------------------------------------------------------------
$officialDirs = @(
    "update", "x64", "BattlEye", "EasyAntiCheat", "Redistributables", "D3D12-REDIST",
    ".egstore", "ReadMe", "common", "data", "movies", "sfx", "_BACKUP_MODS",
    "bin", "engine", "r6", "archive", "red4ext", "plugins", "cyber_engine_tweaks",
    "UE4SS", "Mods", "mod", "BepInEx", "MelonLoader", "Doorstop_libs",
    "steamapps", "shadercache", "crashdumps", "logs", "support", "licenses"
)

# ---------------------------------------------------------------------------
# Expanded mod file patterns (works on a very large number of games)
# ---------------------------------------------------------------------------
$modFilePatterns = @(
    # Injectors / ASI / Script hooks
    "*.asi", "dinput8.dll", "version.dll", "winmm.dll", "dsound.dll",
    "wininet.dll", "winhttp.dll", "dwmapi.dll", "xinput1_1.dll", "xinput1_2.dll",
    "xinput1_3.dll", "xinput1_4.dll", "xinput9_1_0.dll",

    # ScriptHook family
    "ScriptHookV.dll", "ScriptHookVDotNet*.dll", "ScriptHookRDR2.dll",
    "ScriptHookRDR2DotNet*.dll", "NativeTrainer.asi", "TrainerV.asi",

    # ReShade / Special K / ENB
    "dxgi.dll", "ReShade64.dll", "ReShade32.dll", "ReShade.ini", "ReShade.log",
    "ReShadePreset.ini", "SpecialK32.dll", "SpecialK64.dll", "SpecialK.ini",
    "enbseries.ini", "enblocal.ini", "d3d11.dll", "d3d10.dll", "d3d9.dll",
    "d3dcompiler_46e.dll", "d3dcompiler_47e.dll",

    # Upscalers / OptiScaler / DLSS / FSR / XeSS wrappers
    "OptiScaler.dll", "OptiScaler.ini", "OptiScaler.log",
    "nvngx_dlss.dll", "nvngx_dlssg.dll", "nvngx_dlssd.dll",
    "amd_fidelityfx_*.dll", "libxess*.dll", "libxell.dll",
    "dlssg_to_fsr3_amd_is_better.dll", "fakenvapi.*",
    "fsr2.dll", "fsr3.dll", "xess.dll",

    # UE4SS / Unreal
    "UE4SS.dll", "UE4SS-settings.ini",

    # Other common injectors / loaders
    "bink2w64.dll.bak", "winmm.dll.bak", "version.dll.bak",
    "ModLoader.asi", "ScriptHook.dll", "asiloader.dll",
    "Ultimate-ASI-Loader*.dll", "dinput8.dll.bak"
)

# Known mod folders (name match)
$modDirPatterns = @(
    "reshade-shaders", "OptiScaler", "Luma", "D3D12_OptiScaler", "Licenses",
    "UE4SS", "scripts", "plugins", "mods", "mod", "lml", "Lenny's Mod Loader",
    "MenyooStuff", "lspdfr", "RagePluginHook", "OpenIV", "asi", "trainers",
    "enbseries", "ReShade", "SpecialK", "BepInEx", "MelonLoader",
    "cyber_engine_tweaks", "red4ext", "archive/pc/mod", "r6/scripts", "r6/tweaks"
)

# ---------------------------------------------------------------------------
# Vanilla root lists for Deep Scan (Rockstar)
# ---------------------------------------------------------------------------
$vanillaGTA = @(
    "GTA5.exe", "GTAVLauncher.exe", "PlayGTAV.exe", "GTAVLanguageSelect.exe",
    "bink2w64.dll", "d3dcompiler_46.dll", "d3dcsx_46.dll",
    "GFSDK_ShadowLib.win64.dll", "GFSDK_TXAA.win64.dll", "GFSDK_TXAA_AlphaResolve.win64.dll",
    "GPUPerfAPIDX11-x64.dll", "NvPmApi.Core.win64.dll", "steam_api64.dll",
    "version.txt", "index.bin", "installscript.vdf",
    "common.rpf", "x64a.rpf", "x64b.rpf", "x64c.rpf", "x64d.rpf", "x64e.rpf",
    "x64f.rpf", "x64g.rpf", "x64h.rpf", "x64i.rpf", "x64j.rpf", "x64k.rpf",
    "x64l.rpf", "x64m.rpf", "x64n.rpf", "x64o.rpf", "x64p.rpf", "x64q.rpf",
    "x64r.rpf", "x64s.rpf", "x64t.rpf", "x64u.rpf", "x64v.rpf", "x64w.rpf",
    "update", "x64", "Redistributables", "ReadMe", "BattlEye", ".egstore"
)

$vanillaRDR2 = @(
    "RDR2.exe", "PlayRDR2.exe", "bink2w64.dll", "amd_ags_x64.dll",
    "oo2core_5_win64.dll", "dxilconv7.dll", "steam_api64.dll",
    "anim_0.rpf", "appdata0_update.rpf", "common_0.rpf", "data_0.rpf",
    "hd_0.rpf", "levels_0.rpf", "levels_1.rpf", "levels_2.rpf", "levels_3.rpf",
    "levels_4.rpf", "levels_5.rpf", "levels_6.rpf", "levels_7.rpf",
    "movies_0.rpf", "packs_0.rpf", "packs_1.rpf", "rowpack_0.rpf",
    "shaders_x64.rpf", "textures_0.rpf", "textures_1.rpf", "update.rpf",
    "x64", "Redistributables", "12on7", ".egstore"
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
function Test-UnderExcludedDir {
    param([string]$FullPath, [string]$Root, [string[]]$Excluded)
    $relative = $FullPath.Substring($Root.Length).TrimStart('\', '/')
    if ([string]::IsNullOrEmpty($relative)) { return $false }
    $parts = $relative.Split([char[]]@('\', '/'))
    return $Excluded -contains $parts[0]
}

function Get-RelativePath {
    param([string]$FullPath, [string]$Root)
    return $FullPath.Substring($Root.Length).TrimStart('\', '/')
}

function Detect-GameType {
    param([string]$Dir)
    if (Test-Path (Join-Path $Dir "GTA5.exe"))              { return "GTA V" }
    if (Test-Path (Join-Path $Dir "RDR2.exe"))              { return "RDR2" }
    if (Test-Path (Join-Path $Dir "Cyberpunk2077.exe"))     { return "Cyberpunk 2077" }
    if (Test-Path (Join-Path $Dir "eldenring.exe"))         { return "Elden Ring" }
    $name = (Split-Path $Dir -Leaf).ToLower()
    if ($name -match "skyrim|fallout")                      { return "Bethesda" }
    if ((Test-Path (Join-Path $Dir "UE4SS.dll")) -or (Test-Path (Join-Path $Dir "UE4SS"))) { return "Unreal Engine (UE4SS)" }
    return "Generic / Multi-game"
}

$gameType = Detect-GameType $targetDir
Write-Host ($T.gameDetected -f $gameType) -ForegroundColor Cyan
Write-Host $T.structureNote -ForegroundColor DarkGray
Write-Host ""

# ---------------------------------------------------------------------------
# Deep Scan decision for Rockstar games
# ---------------------------------------------------------------------------
$useDeep = $false
if ($gameType -in @("GTA V", "RDR2")) {
    $answer = Read-Host $T.deepModeAsk
    if ($answer -match '^[oyY]') {
        $useDeep = $true
        Write-Host $T.deepEnabled -ForegroundColor Green
    }
}

# ---------------------------------------------------------------------------
# SCAN
# ---------------------------------------------------------------------------
Write-Host ($T.analyzing -f $targetDir) -ForegroundColor DarkGray
Write-Host ""

$detectedItems = New-Object System.Collections.Generic.List[System.IO.FileSystemInfo]
$seen = @{}

function Add-Detected {
    param($Item)
    if (-not $seen.ContainsKey($Item.FullName)) {
        $seen[$Item.FullName] = $true
        $detectedItems.Add($Item)
        $rel = Get-RelativePath $Item.FullName $targetDir
        if ($Item.PSIsContainer) {
            Write-Host $T.modDir -NoNewline -ForegroundColor Red
        } else {
            Write-Host $T.modFile -NoNewline -ForegroundColor Red
        }
        Write-Host $rel -ForegroundColor Yellow
    }
}

# 1) Pattern-based scan (always)
foreach ($pattern in $modFilePatterns) {
    Get-ChildItem -Path $targetDir -Filter $pattern -File -Recurse -ErrorAction SilentlyContinue |
        Where-Object { -not (Test-UnderExcludedDir $_.FullName $targetDir $officialDirs) } |
        ForEach-Object { Add-Detected $_ }
}

foreach ($dirPattern in $modDirPatterns) {
    Get-ChildItem -Path $targetDir -Filter $dirPattern -Directory -Recurse -ErrorAction SilentlyContinue |
        Where-Object { -not (Test-UnderExcludedDir $_.FullName $targetDir $officialDirs) } |
        ForEach-Object { Add-Detected $_ }
}

# 2) Deep Scan (Rockstar only)
if ($useDeep) {
    $vanilla = if ($gameType -eq "GTA V") { $vanillaGTA } else { $vanillaRDR2 }
    $rootItems = Get-ChildItem -Path $targetDir -Force -ErrorAction SilentlyContinue
    foreach ($item in $rootItems) {
        if ($item.Name -eq "_BACKUP_MODS") { continue }
        if ($vanilla -contains $item.Name) { continue }
        if ($item.PSIsContainer -and ($officialDirs -contains $item.Name)) { continue }
        Add-Detected $item
    }
}

Write-Host ""

# Check existing backup
$backupCount = 0
if (Test-Path $backupDir) {
    $backupCount = (Get-ChildItem -Path $backupDir -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object).Count
    if ($backupCount -gt 0) {
        Write-Host ($T.backupExists -f $backupCount) -ForegroundColor DarkCyan
    }
}

if ($detectedItems.Count -eq 0 -and $backupCount -eq 0) {
    Write-Host $T.noModsFound -ForegroundColor Green
    Write-Host ""
    Write-Host ($T.supportLine -f $DonateUrl) -ForegroundColor DarkGray
    Read-Host $T.pressEnterClose
    exit 0
}

if ($detectedItems.Count -gt 0) {
    Write-Host ($T.itemsDetected -f $detectedItems.Count) -ForegroundColor White
}

Write-Host ""
Write-Host $T.whatToDo -ForegroundColor White
Write-Host $T.optionPreview
Write-Host $T.optionHolster
Write-Host $T.optionRestore
Write-Host $T.optionDelete
Write-Host $T.optionCancel
$mode = Read-Host " > "

# ---------------------------------------------------------------------------
# ACTIONS
# ---------------------------------------------------------------------------
$logLines = New-Object System.Collections.Generic.List[string]
$logLines.Add($T.logHeader -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'))
$logLines.Add($T.logTarget -f $targetDir)
$logLines.Add("Game type: $gameType | Deep: $useDeep")
$logLines.Add("")

$successCount = 0
$failCount = 0

switch ($mode) {
    "1" { # Preview
        Write-Host ""
        Write-Host $T.noChanges -ForegroundColor Gray
    }
    "2" { # Holster (move with structure)
        if ($detectedItems.Count -eq 0) {
            Write-Host $T.noModsFound -ForegroundColor Green
            break
        }
        if (-not (Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        }
        foreach ($item in $detectedItems) {
            $rel = Get-RelativePath $item.FullName $targetDir
            $dest = Join-Path $backupDir $rel
            $destParent = Split-Path $dest -Parent
            try {
                if (-not (Test-Path $destParent)) {
                    New-Item -ItemType Directory -Path $destParent -Force | Out-Null
                }
                if (Test-Path $dest) {
                    $ts = Get-Date -Format "yyyyMMdd_HHmmss"
                    $dest = "$dest.$ts.bak"
                }
                Move-Item -Path $item.FullName -Destination $dest -Force -ErrorAction Stop
                Write-Host $T.moved -NoNewline -ForegroundColor Yellow
                Write-Host " $rel"
                $logLines.Add($T.logOk -f $rel, $dest)
                $successCount++
            }
            catch {
                Write-Host $T.failed -NoNewline -ForegroundColor Red
                Write-Host " $rel ($($_.Exception.Message))"
                $logLines.Add($T.logFail -f $rel, $_.Exception.Message)
                $failCount++
            }
        }
    }
    "3" { # Restore
        if (-not (Test-Path $backupDir)) {
            Write-Host $T.restoreEmpty -ForegroundColor Yellow
            break
        }
        $toRestore = Get-ChildItem -Path $backupDir -Recurse -Force -ErrorAction SilentlyContinue |
            Where-Object { -not $_.PSIsContainer }
        if ($toRestore.Count -eq 0) {
            Write-Host $T.restoreEmpty -ForegroundColor Yellow
            break
        }
        foreach ($item in $toRestore) {
            $rel = Get-RelativePath $item.FullName $backupDir
            $dest = Join-Path $targetDir $rel
            $destParent = Split-Path $dest -Parent
            try {
                if (-not (Test-Path $destParent)) {
                    New-Item -ItemType Directory -Path $destParent -Force | Out-Null
                }
                if (Test-Path $dest) {
                    $ts = Get-Date -Format "yyyyMMdd_HHmmss"
                    Move-Item -Path $dest -Destination "$dest.$ts.bak" -Force -ErrorAction SilentlyContinue
                }
                Move-Item -Path $item.FullName -Destination $dest -Force -ErrorAction Stop
                Write-Host $T.restored -NoNewline -ForegroundColor Green
                Write-Host " $rel"
                $logLines.Add($T.logOk -f $rel, $dest)
                $successCount++
            }
            catch {
                Write-Host $T.failed -NoNewline -ForegroundColor Red
                Write-Host " $rel ($($_.Exception.Message))"
                $logLines.Add($T.logFail -f $rel, $_.Exception.Message)
                $failCount++
            }
        }
        # Clean empty dirs in backup
        Get-ChildItem -Path $backupDir -Recurse -Directory -ErrorAction SilentlyContinue |
            Sort-Object FullName -Descending |
            Where-Object { (Get-ChildItem $_.FullName -Force -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0 } |
            Remove-Item -Force -ErrorAction SilentlyContinue
    }
    "4" { # Permanent delete
        if ($detectedItems.Count -eq 0) {
            Write-Host $T.noModsFound -ForegroundColor Green
            break
        }
        Write-Host ""
        $confirm = Read-Host $T.confirmDelete
        if ($confirm -ne "DELETE") {
            Write-Host $T.confirmDeleteWrong -ForegroundColor Yellow
            break
        }
        foreach ($item in $detectedItems) {
            $rel = Get-RelativePath $item.FullName $targetDir
            try {
                Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction Stop
                Write-Host $T.deleted -NoNewline -ForegroundColor Magenta
                Write-Host " $rel"
                $logLines.Add($T.logOk -f $rel, "DELETED")
                $successCount++
            }
            catch {
                Write-Host $T.failed -NoNewline -ForegroundColor Red
                Write-Host " $rel ($($_.Exception.Message))"
                $logLines.Add($T.logFail -f $rel, $_.Exception.Message)
                $failCount++
            }
        }
    }
    default {
        Write-Host ""
        Write-Host $T.noChanges -ForegroundColor Gray
    }
}

if ($successCount -gt 0 -or $failCount -gt 0) {
    $logLines.Add("")
    $logLines.Add($T.logTotal -f $successCount, $failCount)
    $logDir = Split-Path $logFile -Parent
    if (-not (Test-Path $logDir)) { New-Item -ItemType Directory -Path $logDir -Force | Out-Null }
    Add-Content -Path $logFile -Value $logLines -Encoding UTF8

    Write-Host ""
    Write-Host ($T.doneMsg -f $successCount, $failCount) -ForegroundColor Green
    Write-Host ($T.logSaved -f $logFile) -ForegroundColor DarkGray
}

Write-Host ($T.supportLine -f $DonateUrl) -ForegroundColor DarkGray
Read-Host $T.pressEnterClose
