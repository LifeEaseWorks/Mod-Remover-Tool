# Mod Remover Tool v4.0

A solid Windows PowerShell utility that detects common mod/wrapper files and folders
(ReShade, OptiScaler, DLSS/FSR/XeSS wrappers, ENB, ScriptHook, ASI loaders, UE4SS, etc.)
in a game folder and lets you **holster** (move), **restore**, or permanently delete them
without touching official game files.

Inspired by specialized tools for GTA V and RDR2, but designed to work reliably across
a much wider range of PC games.

## Major features (v4.0)

- **Holster** → moves detected mods into `_BACKUP_MODS` while **keeping the full folder structure** (perfect restore later)
- **Restore** → puts everything back exactly where it was
- **Preview** → see what would be affected before any change
- **Permanent delete** → only after typing `DELETE` in capitals
- **Deep Scan** (GTA V & RDR2) → whitelist mode that treats almost anything not vanilla as a mod
- **Auto game detection** (GTA V, RDR2, Cyberpunk 2077, Elden Ring, Unreal Engine titles with UE4SS, Bethesda titles, generic)
- Expanded pattern list covering many engines and popular injectors
- Bilingual UI (English / French) with auto-detection from Windows language
- Detailed timestamped log of every action
- Drag-and-drop support via `LANCER_CLEANER.bat`

## Usage

1. Keep `LANCER_CLEANER.bat` and `mod_cleaner.ps1` in the same folder.
2. Either:
   - drag your game folder onto `LANCER_CLEANER.bat`, or
   - double-click `LANCER_CLEANER.bat` and paste the game folder path.
3. The tool detects the game type and offers Deep Scan on Rockstar titles.
4. Choose:
   - **[1] Preview** – safe, shows what would be moved
   - **[2] Holster** – move mods to `_BACKUP_MODS` (structure preserved)
   - **[3] Restore** – put mods back from the backup
   - **[4] Permanent delete** – erase after confirmation
   - **[5] Cancel**

## Language

On-screen text is available in English and French.  
It picks the language automatically from your Windows system language.  
You can force it:

```powershell
powershell -File mod_cleaner.ps1 -Lang fr
powershell -File mod_cleaner.ps1 -Lang en
```

## What games this works well on

### Excellent (Deep Scan + patterns)
| Game              | Notes                                      |
|-------------------|--------------------------------------------|
| **GTA V**         | Deep Scan recommended for Online cleanup   |
| **Red Dead Redemption 2** | Deep Scan recommended for Online / clean state |

### Very good (pattern-based, covers the vast majority of injectors)
| Category                          | Examples / Coverage                                      |
|-----------------------------------|----------------------------------------------------------|
| **ReShade / Special K / ENB**     | Almost every DX9/10/11/12 game                           |
| **ASI Loader + ScriptHook**       | GTA series, RDR2, Mafia, Watch Dogs, Sleeping Dogs, Just Cause, Saints Row, Yakuza, etc. |
| **OptiScaler / DLSS / FSR / XeSS wrappers** | Most modern DirectX 11/12 titles                  |
| **UE4SS (Unreal Engine 4/5)**     | Huge number of current UE games                          |
| **Cyberpunk 2077**                | CET, red4ext, archive/pc/mod, r6/scripts & tweaks        |
| **Elden Ring / FromSoftware**     | Common injectors + upscalers                             |
| **Generic multi-game**            | Any title that uses the above injection systems          |

### Limited / not the right tool
- **Bethesda titles** (Skyrim, Fallout 4/76, Starfield…) managed by Vortex / MO2 → use the mod manager instead. This tool only catches ENB/ReShade/SKSE-style injectors in the root.
- **Sims 4** `.package` files, Minecraft jars, etc. → completely different systems.
- Very old DirectX 9 games that ship legitimate `xinput1_3.dll` / `dinput8.dll` as compatibility shims (always run Preview first).

## Not recommended for

- Games with **active anti-cheat** while the service is running (close the game + anti-cheat first).
- Any folder you haven’t checked in **Preview** mode yet, especially unusual or very old titles.

## Safety design

- Official / system folders (`update`, `x64`, `BattlEye`, `EasyAntiCheat`, `Redistributables`, etc.) are never scanned or touched.
- Backup keeps the **full relative path** so restore is exact.
- Nothing is ever deleted without explicit confirmation (`DELETE`).
- Every action is logged with timestamp.

## Security and integrity

This project is not yet code-signed.  
Every release includes a `SHA256SUMS.txt` file. Verify with:

```powershell
Get-FileHash .\mod_cleaner.ps1 -Algorithm SHA256
```

## PGP signature

Releases are signed. Public key is in `PUBLIC_KEY.asc`.

Fingerprint: `5B38 1153 E7E1 6D36 FB92  5C7C C73C 0F9A B979 17B9`

## Disclaimer

Always keep your own backup of important game files.  
This tool matches by name patterns (and optional whitelist on Rockstar titles).  
Review the list (or use Preview) before confirming any move or delete.

## License

MIT — see [LICENSE](LICENSE).

## Support

[![Donate using Liberapay](https://img.shields.io/badge/Liberapay-donate-F6C915?style=flat&logo=liberapay&logoColor=black)](https://liberapay.com/LifeEaseWorks/donate)
