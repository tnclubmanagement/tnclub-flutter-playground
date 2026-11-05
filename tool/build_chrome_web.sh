#!/bin/sh
set -eu

# Build a clean release before pruning generated renderer variants.
flutter clean
flutter pub get
flutter build web --release --no-source-maps --no-wasm-dry-run

canvas_kit_dir="build/web/canvaskit"

# Current Chrome uses only the Chromium CanvasKit variant. The other variants
# and symbol files are not needed by this deployment.
find "$canvas_kit_dir" -type f -name '*.symbols' -delete
rm -f \
  "$canvas_kit_dir/canvaskit.js" \
  "$canvas_kit_dir/canvaskit.wasm" \
  "$canvas_kit_dir/skwasm.js" \
  "$canvas_kit_dir/skwasm.wasm" \
  "$canvas_kit_dir/skwasm_heavy.js" \
  "$canvas_kit_dir/skwasm_heavy.wasm" \
  "$canvas_kit_dir/wimp.js" \
  "$canvas_kit_dir/wimp.wasm"
rm -rf "$canvas_kit_dir/webparagraph"

echo "Chrome web build ready: $PWD/build/web"
du -sh build/web
