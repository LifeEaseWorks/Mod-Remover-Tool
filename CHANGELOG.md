# Changelog

## v4.0

- **Major rewrite** focused on reliability and multi-game coverage.
- Added **Restore** mode (put mods back from `_BACKUP_MODS`).
- Holster now **preserves full directory structure** → perfect restore.
- Added **Deep Scan** (whitelist) for GTA V and RDR2.
- Auto game-type detection (GTA V, RDR2, Cyberpunk 2077, Elden Ring, UE4SS, Bethesda, Generic).
- Greatly expanded mod file & folder patterns (ASI, ScriptHook family, ReShade, Special K, ENB, OptiScaler, DLSS/FSR/XeSS wrappers, UE4SS, Cyberpunk folders, etc.).
- Permanent delete option with explicit `DELETE` confirmation.
- Better exclusion of official/system folders (BattlEye, EasyAntiCheat, etc.).
- Improved logging and bilingual UI (EN/FR).

## v3.1

- Added detection for `.asi` files, `dwmapi.dll`, UE4SS, SpecialK, extra wrapper DLLs.
- English + French language support with auto-detect and `-Lang` override.
- Added "Not recommended for" section.
- PGP-signed releases and SHA256 checksums.

## v3.0

- Rewritten from the original "Universal Game Mod Cleaner".
- Recursive scan with real exclusion of official folders.
- Preview mode.
- Per-file error handling + timestamped log.
- Backup collisions renamed instead of overwritten.

## v2.1

- Original version: ReShade, OptiScaler, DLSS/FSR/XeSS, ENB, ScriptHookV.
