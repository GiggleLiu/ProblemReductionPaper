#!/usr/bin/env bash
# Package an arXiv-ready tarball into submit/.
# Includes: paper.tex, paper.bbl, and only the figures referenced by \includegraphics.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/submit"
STAGE="$OUT/arxiv"

cd "$ROOT"

echo "==> Building paper to refresh paper.bbl"
latexmk -pdf -interaction=nonstopmode paper.tex >/dev/null

if [[ ! -f paper.bbl ]]; then
  echo "error: paper.bbl not found after build" >&2
  exit 1
fi

echo "==> Staging in $STAGE"
rm -rf "$STAGE"
mkdir -p "$STAGE/figures"

cp paper.tex "$STAGE/paper.tex"
cp paper.bbl "$STAGE/paper.bbl"

echo "==> Extracting referenced figures"
mapfile -t FIGS < <(
  grep -oE '\\includegraphics(\[[^]]*\])?\{figures/[^}]+\}' paper.tex \
    | sed -E 's/.*\{figures\/([^}]+)\}/\1/' \
    | sort -u
)

if [[ ${#FIGS[@]} -eq 0 ]]; then
  echo "error: no figures found in paper.tex" >&2
  exit 1
fi

for f in "${FIGS[@]}"; do
  src="figures/$f"
  if [[ ! -f "$src" ]]; then
    echo "error: missing figure $src" >&2
    exit 1
  fi
  cp "$src" "$STAGE/figures/$f"
  echo "  + $f"
done

echo "==> Creating tarball"
TAR="$OUT/arxiv.tar.gz"
rm -f "$TAR"
tar -C "$STAGE" -czf "$TAR" .

echo
echo "Staged dir: $STAGE"
echo "Tarball:    $TAR"
echo "Contents:"
tar -tzf "$TAR" | sed 's/^/  /'
