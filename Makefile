.PHONY: help paper figures icons arxiv clean

help:
	@echo "Available targets:"
	@echo "  paper   - Build paper with latexmk (pdflatex + bibtex)"
	@echo "  figures - Compile Typst figure sources to PDF"
	@echo "  icons   - Compile Typst icon sources to SVG"
	@echo "  arxiv   - Package arXiv upload under submit/ (tex, bbl, used figures)"
	@echo "  clean   - Remove LaTeX build artifacts"

# Build the paper (latexmk handles bibtex/rerun automatically)
paper:
	latexmk -pdf -interaction=nonstopmode paper.tex

# Compile Typst figure sources to PDF
TYPST_FIGURES := $(filter-out %/lib.typ,$(wildcard figures/*.typ))
figures:
	@for src in $(TYPST_FIGURES); do \
		base=$$(basename $$src .typ); \
		echo "Compiling $$base..."; \
		typst compile $$src figures/$$base.pdf; \
	done

# Compile Typst icon sources to SVG (incremental)
ICON_TYP := $(wildcard figures/icons/*.typ)
ICON_SVG := $(ICON_TYP:.typ=.svg)

icons: $(ICON_SVG)

figures/icons/%.svg: figures/icons/%.typ
	@echo "Compiling $<..."
	typst compile --root . --format svg $< $@

# Package an arXiv-ready tarball into submit/
arxiv:
	bash scripts/package-arxiv.sh

# Clean LaTeX build artifacts
clean:
	latexmk -C
	rm -f *.bbl *.blg *.out *.synctex.gz *.fdb_latexmk *.fls
