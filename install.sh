#!/bin/sh
# Install the Rosé Pine Moon Beamer theme.
#
# Copies the theme .sty files into
#   $(kpsewhich -var-value TEXMFHOME)/tex/latex/beamer/RosePineMoon
# Idempotent and non-destructive: identical files are left alone, and a
# differing existing file is backed up (name.bak.<timestamp>) before being
# replaced. Nothing is ever deleted.

set -eu

SRC_DIR=$(cd "$(dirname "$0")" && pwd)

if ! command -v kpsewhich >/dev/null 2>&1; then
  echo "error: kpsewhich not found; is a TeX distribution installed?" >&2
  exit 1
fi

TEXMFHOME=$(kpsewhich -var-value TEXMFHOME)
if [ -z "$TEXMFHOME" ]; then
  echo "error: could not determine TEXMFHOME" >&2
  exit 1
fi

DEST="$TEXMFHOME/tex/latex/beamer/RosePineMoon"
mkdir -p "$DEST"

stamp=$(date +%Y%m%d%H%M%S)
installed=0
unchanged=0

for src in "$SRC_DIR"/*.sty; do
  [ -f "$src" ] || continue
  name=$(basename "$src")
  dst="$DEST/$name"
  if [ -f "$dst" ]; then
    if cmp -s "$src" "$dst"; then
      unchanged=$((unchanged + 1))
      continue
    fi
    cp -p "$dst" "$dst.bak.$stamp"
    echo "backed up $dst -> $dst.bak.$stamp"
  fi
  cp "$src" "$dst"
  installed=$((installed + 1))
done

echo "Rosé Pine Moon: $installed installed, $unchanged already up to date in $DEST"
echo
echo "(Running texhash is not needed for TEXMFHOME, but it is harmless.)"
echo
echo "The code-listing colours need the 'rosepinemoon' Pygments style for minted:"
echo "  pip install latexminted \"$SRC_DIR\""
echo "See the README (Requirements) for details."
