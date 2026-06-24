#!/usr/bin/env bash
set -euo pipefail

port="${PORT:-8099}"
seed_root="/seed_esphome"

# Shared path mode via env var (default: independent)
use_esphome_shared_path="${USE_ESPHOME_SHARED_PATH:-0}"

if [ "$use_esphome_shared_path" = "1" ]; then
  target_dir="/config/esphome"
  pio_cache_fallback_base="/config/.esphome/platformio"
  storage_mode="shared_esphome"
else
  target_dir="/config/ecd"
  pio_cache_fallback_base="/config/.ecd/platformio"
  storage_mode="independent_ecd"
fi

project_dir="${target_dir}/esp_projects"
asset_root="${target_dir}/esp_assets"

if [ -d /cache ]; then
  pio_cache_base="/cache/platformio"
else
  pio_cache_base="$pio_cache_fallback_base"
fi

export TARGET_DIR="$target_dir"
export PROJECT_DIR="$project_dir"
export PORT="$port"
export ASSET_ROOT="$asset_root"
export SEED_ROOT="$seed_root"
export ESPHOME_DATA_DIR="/data/esphome"
export WEB_ROOT="/web"
export PATH="/opt/designer-venv/bin:$PATH"
export ESPHOME_BIN="esphome"
export ESPHOME_IS_HA_ADDON=false
export PLATFORMIO_PLATFORMS_DIR="${pio_cache_base}/platforms"
export PLATFORMIO_PACKAGES_DIR="${pio_cache_base}/packages"
export PLATFORMIO_CACHE_DIR="${pio_cache_base}/cache"
export HOME="/root"

mkdir -p "$pio_cache_base"
mkdir -p "$target_dir"
mkdir -p "$project_dir"
mkdir -p "$asset_root"
mkdir -p "$asset_root/fonts"
mkdir -p "$asset_root/images"
mkdir -p "$asset_root/audio"
mkdir -p /data/jobs
mkdir -p /data/esphome

# Seed initial files if target is empty
if [ ! -f "$target_dir/secrets.yaml" ]; then
  cp "$seed_root/secrets.yaml" "$target_dir/secrets.yaml" 2>/dev/null || true
fi
if [ ! -f "$asset_root/fonts.json" ]; then
  cp "$seed_root/esp_assets/fonts.json" "$asset_root/fonts.json" 2>/dev/null || true
fi
if [ ! -f "$asset_root/images.json" ]; then
  cp "$seed_root/esp_assets/images.json" "$asset_root/images.json" 2>/dev/null || true
fi
if [ ! -f "$asset_root/audio.json" ]; then
  cp "$seed_root/esp_assets/audio.json" "$asset_root/audio.json" 2>/dev/null || true
fi
if [ ! -f "$asset_root/gfonts.json" ]; then
  cp "$seed_root/esp_assets/gfonts.json" "$asset_root/gfonts.json" 2>/dev/null || true
fi
if [ ! -f "$asset_root/mdi_glyph_substitutions.yaml" ]; then
  cp "$seed_root/esp_assets/mdi_glyph_substitutions.yaml" "$asset_root/mdi_glyph_substitutions.yaml" 2>/dev/null || true
fi
if [ ! -f "$asset_root/fonts/materialdesignicons-webfont.ttf" ]; then
  cp "$seed_root/esp_assets/fonts/materialdesignicons-webfont.ttf" "$asset_root/fonts/materialdesignicons-webfont.ttf" 2>/dev/null || true
fi

echo "[info] Starting esp-config-designer API (standalone mode)"
echo "[info] run.sh version: 1.2.3"
echo "[info] ESPHome: $(esphome version 2>/dev/null || echo unknown)"
echo "[info] Storage mode: $storage_mode"
echo "[info] PlatformIO packages dir: $PLATFORMIO_PACKAGES_DIR"
echo "[info] Target dir: $target_dir"
echo "[info] Project dir: $project_dir"
echo "[info] Port: $port"

exec /opt/designer-venv/bin/python /server.py
