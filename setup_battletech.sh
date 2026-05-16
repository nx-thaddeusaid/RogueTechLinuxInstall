#!/usr/bin/env bash
set -e

PREFIX="$HOME/Games/BattleTechPrefix"
GAME_DIR="$PREFIX/drive_c/Program Files (x86)/Games/BATTLETECH"
PLUGINS_DIR="$GAME_DIR/BattleTech_Data/Plugins"
SYS32="$PREFIX/drive_c/windows/system32"
LAUNCHER="$HOME/Games/launch_battletech.sh"

echo "Creating 64-bit Wine prefix at $PREFIX..."
mkdir -p "$GAME_DIR"
WINEPREFIX="$PREFIX" WINEARCH=win64 wine wineboot --init

echo "Installing runtime dependencies..."
WINE=wine WINEPREFIX="$PREFIX" WINEARCH=win64 winetricks -q vcrun2019 d3dcompiler_47 corefonts dotnet48

echo "Installing Media Foundation..."
WINE=wine WINEPREFIX="$PREFIX" WINEARCH=win64 winetricks -q mf

echo "Installing DXVK..."
WINE=wine WINEPREFIX="$PREFIX" WINEARCH=win64 winetricks -q dxvk

if [ -f "$HOME/Downloads/RogueLauncher.exe" ]; then
    echo "Copying RogueLauncher.exe from ~/Downloads..."
    cp "$HOME/Downloads/RogueLauncher.exe" "$GAME_DIR/RogueLauncher.exe"
else
    echo "WARNING: RogueLauncher.exe not found in ~/Downloads — skipping."
    echo "  RogueLauncher is distributed via the RogueTech Discord server."
    echo "  Download it there and place it in ~/Downloads/, then re-run this script."
fi

echo "Writing RtLauncherSettings.xml..."
cat > "$GAME_DIR/RtLauncherSettings.xml" << 'EOF'
<?xml version="1.0" ?>
<RogueTechLauncherSettings>
	<Banner>Banner-A</Banner>
	<BattleTechExe>C:/Program Files (x86)/Games/BATTLETECH/BattleTech.exe</BattleTechExe>
	<BorderlessWindowMode>false</BorderlessWindowMode>
	<CabBranch>master</CabBranch>
	<CabDataGitRepoUrl>https://github.com/BattletechModders/Community-Asset-Bundle-Data.git</CabDataGitRepoUrl>
	<CachePath>C:\Program Files (x86)\Games\BATTLETECH\RtlCache\</CachePath>
	<CloseOnRtLaunch>false</CloseOnRtLaunch>
	<FastPatchDefault>false</FastPatchDefault>
	<GitBranch>master</GitBranch>
	<GitRepoUrl>https://github.com/BattletechModders/RogueTech.git</GitRepoUrl>
	<HighDpiMode>false</HighDpiMode>
	<PageFileCheckSupressed>true</PageFileCheckSupressed>
	<SafeLaunchDisabled>false</SafeLaunchDisabled>
	<SecureHash/>
	<ShellInvoke>false</ShellInvoke>
	<SteamLaunch>false</SteamLaunch>
	<Theme>Fusion</Theme>
	<disableReconfPrompts>false</disableReconfPrompts>
	<iThinkIKnowBetter>false</iThinkIKnowBetter>
	<installTarget>C:\Program Files (x86)\Games\BATTLETECH\Mods</installTarget>
	<language>en_US</language>
	<specialAccessPw/>
	<winDir>c:/windows</winDir>
</RogueTechLauncherSettings>
EOF

echo "Symlinking Bink DLLs into system32..."
for dll in bink2w64.dll binkpluginw64.dll; do
    ln -sf "$PLUGINS_DIR/$dll" "$SYS32/$dll"
done

echo "Generating launcher at $LAUNCHER..."
cat > "$LAUNCHER" << EOF
#!/usr/bin/env bash
cd "$GAME_DIR" && WINEPREFIX="$PREFIX" WINEDLLOVERRIDES="bink2w64=n,b;binkpluginw64=n,b;winhttp=n,b" PULSE_LATENCY_MSEC=60 wine "C:/Program Files (x86)/Games/BATTLETECH/RogueLauncher.exe"
EOF
chmod +x "$LAUNCHER"

echo ""
echo "=========================================================="
echo " Setup complete. Next steps:"
echo "=========================================================="
echo ""
echo " 1. Install BattleTech into the Wine prefix:"
echo ""
echo "    FROM STEAM:"
echo "    - Install BATTLETECH via Steam normally, then copy the files:"
echo ""
echo "      cp -r ~/.steam/steam/steamapps/common/BATTLETECH/. \\"
echo "        \"$GAME_DIR/\""
echo ""
echo "    FROM GOG:"
echo "    - Run the GOG installer through Wine:"
echo ""
echo "      WINEPREFIX=\"$PREFIX\" wine ~/Downloads/setup_battletech_*.exe"
echo ""
echo "    - When prompted for an install path, set it to:"
echo ""
echo "      C:\Program Files (x86)\Games\BATTLETECH"
echo ""
echo " 2. Launch RogueTech:"
echo ""
echo "      bash \"$LAUNCHER\""
echo ""
echo " The RogueTech launcher will open. Use it to download and"
echo " install RogueTech mods, then click Launch to start the game."
echo ""
echo " 3. Add to Steam as a non-Steam game (optional):"
echo "    - Open Steam → Games → Add a Non-Steam Game to My Library"
echo "    - Click Browse and navigate to:"
echo ""
echo "        $LAUNCHER"
echo ""
echo "    - Set the name to: RogueTech - BATTLETECH"
echo "    - Click Add Selected Programs"
echo "    - To set artwork: right-click the game in your library"
echo "      → Manage → Set Custom Artwork"
echo "=========================================================="
