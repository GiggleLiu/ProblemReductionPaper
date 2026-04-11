.PHONY: help paper figures arxiv clean

help:
	@echo "Available targets:"
	@echo "  paper   - Build paper with latexmk (pdflatex + bibtex)"
	@echo "  figures - Compile Typst figure sources to PDF"
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

# Package an arXiv-ready tarball into submit/
arxiv:
	bash scripts/package-arxiv.sh

# Clean LaTeX build artifacts
clean:
	latexmk -C
	rm -f *.bbl *.blg *.out *.synctex.gz *.fdb_latexmk *.fls
