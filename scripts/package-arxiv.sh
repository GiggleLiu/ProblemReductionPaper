#!/usr/bin/env bash
# Package an arXiv-ready tarball into submit/.
# Includes: main.tex, checklist.tex, main.bbl, neurips_2026.sty,
# and only the figures referenced by \includegraphics.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/submit"
STAGE="$OUT/arxiv"

cd "$ROOT"

echo "==> Building paper to refresh main.bbl"
latexmk -pdf -interaction=nonstopmode main.tex >/dev/null

if [[ ! -f main.bbl ]]; then
  echo "error: main.bbl not found after build" >&2
  exit 1
fi

echo "==> Staging in $STAGE"
rm -rf "$STAGE"
mkdir -p "$STAGE/figures"

echo "==> Generating arXiv variant of main.tex (preprint mode, no checklist)"
# 1. Comment out L10:  \usepackage{neurips_2026}
# 2. Uncomment L45:    \usepackage[preprint]{neurips_2026}
# 3. Drop the \input{checklist.tex} line(s) from the body
# 4. Replace the ARXIV-FOOTNOTE-MARKER with a footnote that names equal-contribution
#    authors and the corresponding author. Kept out of main.tex so the anonymous
#    submission build never renders identifying information.
sed -E \
  -e 's|^\\usepackage\{neurips_2026\}|% \\usepackage{neurips_2026}|' \
  -e 's|^%[[:space:]]*\\usepackage\[preprint\]\{neurips_2026\}|\\usepackage[preprint]{neurips_2026}|' \
  -e '/^\\input\{checklist\.tex\}/d' \
  -e '/%% ARXIV-FOOTNOTE-MARKER/{
    s|.*|\\begingroup\
  \\renewcommand\\thefootnote{}%\
  \\footnotetext{\\textsuperscript{*}Equal contribution.\\quad \\textsuperscript{$\\dagger$}Corresponding author: \\texttt{jinguoliu@hkust-gz.edu.cn}.}%\
  \\addtocounter{footnote}{-1}%\
\\endgroup|
  }' \
  -e '/%% ARXIV-CODE-URL-MARKER/{
    s|.*|  The source code is available at \\url{https://github.com/CodingThrust/problem-reductions}.|
  }' \
  main.tex > "$STAGE/main.tex"

cp main.bbl        "$STAGE/main.bbl"
cp neurips_2026.sty "$STAGE/neurips_2026.sty"

echo "==> Extracting referenced figures"
mapfile -t FIGS < <(
  grep -hoE '\\includegraphics(\[[^]]*\])?\{figures/[^}]+\}' "$STAGE/main.tex" \
    | sed -E 's/.*\{figures\/([^}]+)\}/\1/' \
    | sort -u
)

if [[ ${#FIGS[@]} -eq 0 ]]; then
  echo "error: no figures found in staged main.tex" >&2
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
