#!/usr/bin/env bash
# =====================================================================
# Antigravity Process Architect - One-Click Installer (macOS / Linux)
# Developed by: Dr. Eng. Ahmed Adel (Dr.PMO)
# =====================================================================

set -e

echo ""
echo "=========================================================="
echo "  Process Architect for Google Antigravity - تثبيت المهارة"
echo "  Developed by: Dr. Eng. Ahmed Adel (Dr.PMO)"
echo "=========================================================="
echo ""

# 1. Check Node.js
echo "[1/4] Checking Node.js prerequisite..."
if ! command -v node &> /dev/null; then
    echo "  [ERROR] Node.js is not installed! Please install Node.js (>=18) from https://nodejs.org/"
    exit 1
fi
echo "  [OK] Found Node.js: $(node -v)"

# 2. Setup target directory
SKILL_DIR="$HOME/.gemini/config/skills/process-architect"
echo "[2/4] Setting up Antigravity skill directory: $SKILL_DIR"
rm -rf "$SKILL_DIR"
mkdir -p "$SKILL_DIR"

# 3. Download and unpack
echo "[3/4] Downloading Process Architect package..."
TEMP_ZIP=$(mktemp /tmp/antigravity-pa.XXXXXX.zip)
TEMP_DIR=$(mktemp -d /tmp/antigravity-pa-extract.XXXXXX)

curl -fsSL "https://github.com/drengahmedadel-gov/antigravity-process-architect/archive/refs/heads/main.zip" -o "$TEMP_ZIP"
unzip -q "$TEMP_ZIP" -d "$TEMP_DIR"
cp -r "$TEMP_DIR"/antigravity-process-architect-main/process-architect/* "$SKILL_DIR"/

rm -f "$TEMP_ZIP"
rm -rf "$TEMP_DIR"
echo "  [OK] Package files extracted successfully."

# 4. Verification
echo "[4/4] Verifying engine components..."
node "$SKILL_DIR/bin/archify.mjs" doctor > /dev/null 2>&1
echo "  [OK] All engine gates verified and ready."

echo ""
echo "=========================================================="
echo "  Installation complete! Process Architect is ready."
echo "  Open Antigravity and ask to diagram any SOP or workflow."
echo "=========================================================="
echo ""
