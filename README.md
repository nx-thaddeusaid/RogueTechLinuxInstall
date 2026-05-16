# RogueTechLinuxInstall

A script to set up [RogueTech](https://github.com/BattletechModders/RogueTech) (a total overhaul mod for BATTLETECH) on Linux using Wine.

## Prerequisites

Install the following before running the script:

- **Wine** (64-bit) — `wine` must be in your PATH
- **winetricks** — used to install runtime dependencies
- **BATTLETECH** — owned on Steam or GOG
- **RogueLauncher.exe** — distributed via the [RogueTech Discord server](https://discord.gg/roguetech); download it and place it at `~/Downloads/RogueLauncher.exe`

On Debian/Ubuntu:
```bash
sudo apt install wine winetricks
```

On Arch:
```bash
sudo pacman -S wine winetricks
```

## Setup

### Step 1 — Get RogueLauncher.exe

Join the RogueTech Discord and download `RogueLauncher.exe`. Place it in your Downloads folder:

```
~/Downloads/RogueLauncher.exe
```

### Step 2 — Run the setup script

```bash
bash setup_battletech.sh
```

This will:

- Create a 64-bit Wine prefix at `~/Games/BattleTechPrefix`
- Install runtime dependencies via winetricks (`vcrun2019`, `d3dcompiler_47`, `corefonts`, `dotnet48`)
- Install Media Foundation and DXVK
- Copy `RogueLauncher.exe` into the Wine prefix
- Write the RogueTech launcher settings file
- Symlink the Bink audio DLLs
- Generate a launcher script at `~/Games/launch_battletech.sh`

> The script will print a warning and skip copying `RogueLauncher.exe` if it is not found in `~/Downloads/`. You can re-run the script after placing it there.

### Step 3 — Install BATTLETECH game files

After the script finishes, you need to put the base game files into the Wine prefix.

**From Steam:**

```bash
cp -r ~/.steam/steam/steamapps/common/BATTLETECH/. \
  ~/Games/BattleTechPrefix/drive_c/Program\ Files\ \(x86\)/Games/BATTLETECH/
```

**From GOG:**

Run the GOG installer through Wine:

```bash
WINEPREFIX=~/Games/BattleTechPrefix wine ~/Downloads/setup_battletech_*.exe
```

When the installer asks for an install path, set it to:

```
C:\Program Files (x86)\Games\BATTLETECH
```

### Step 4 — Launch RogueTech

```bash
bash ~/Games/launch_battletech.sh
```

The RogueTech Launcher will open. Use it to download and install the RogueTech mod pack, then click **Launch** to start the game.

## Optional — Add to Steam as a Non-Steam Game

1. Open Steam → **Games** → **Add a Non-Steam Game to My Library**
2. Click **Browse** and navigate to `~/Games/launch_battletech.sh`
3. Set the name to `RogueTech - BATTLETECH`
4. Click **Add Selected Programs**
5. To set artwork: right-click the game in your library → **Manage** → **Set Custom Artwork**

## File Locations

| Path | Description |
|------|-------------|
| `~/Games/BattleTechPrefix` | Wine prefix |
| `~/Games/BattleTechPrefix/drive_c/Program Files (x86)/Games/BATTLETECH` | Game install directory |
| `~/Games/launch_battletech.sh` | Generated launch script |
| `~/Downloads/RogueLauncher.exe` | Required before running setup |
