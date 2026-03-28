# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Academic paper about using AI coding agents to build a verified library of NP-hard problem reductions. The paper is written in LaTeX (IEEE conference format) with figures authored in Typst. The subject Rust library is included as a git submodule at `problem-reductions/` (upstream: `CodingThrust/problem-reductions`). Before any any paper edits, you must read the `paper.tex` file and understand the project structure and conventions.

**Paper title:** "Grand Assembly of Computational Hard Problems: The Art of Agentic Coding"

## Build Commands

```bash
make paper      # Build PDF with latexmk (pdflatex + bibtex, handles reruns)
make figures    # Compile all Typst figures (figures/*.typ → figures/*.pdf)
make clean      # Remove LaTeX build artifacts
```

To compile a single Typst figure:
```bash
typst compile figures/<name>.typ figures/<name>.pdf
```

## Architecture

- **paper.tex** — Single-file LaTeX source (IEEE `\documentclass[conference]{IEEEtran}`). ~60K chars, all sections in one file.
- **references.bib** — BibTeX bibliography.
- **figures/** — Typst sources (`.typ`) that compile to PDF. All figures import `figures/lib.typ` for shared theme (palette, strokes, arrow presets). Uses `@preview/cetz:0.4.2` for drawing.
- **data/** — Supporting data: `git-mining-results.json` (PR history from GitHub), `graph-metrics.json`, `peer-review-round1.md`.
- **problem-reductions/** — Git submodule of the Rust library this paper studies. Use `git submodule update --init` to populate after a fresh clone.
- **scripts/mine-git-history.py** — Fetches merged PRs from `CodingThrust/problem-reductions` via `gh` CLI, classifies by type/phase/author.
- **paper-redesign-spec.md** — Redesign specification with section structure, figure specs, and framing decisions.
- **writing-guidelines.md** — Writing style rules derived from "Attention Is All You Need". Key principles: lead with the answer, one idea per sentence, define before use, cut ruthlessly.

## Paper Structure (Sections)

1. Introduction — Problem, bridging via reduction graph, challenge (bridge problem concept + prior work survey), contributions
2. Case Study: The Reduction Graph — Reduction definition, graph structure, emergent compositionality, round-trip testing
3. Methodology — No-code pipeline, skills, verification stack, why Rust
4. Evidence — Development metrics, quality gate, case studies
5. Related Work
6. Discussion/Conclusion — Limitations, generalization to other domains, future work

## Key Conventions

- Figures are Typst, not TikZ. The `lib.typ` shared module defines colors, strokes, and arrow styles — use it in all new figures.
- The `.gitignore` excludes `paper.pdf` and all LaTeX intermediates. Figure PDFs (in `figures/`) are tracked in git.

## Writing Style

All prose in `paper.tex` must follow these rules (from `writing-guidelines.md`):

1. **Start from what the reader knows.** Open each section with a familiar concept, then pivot to the gap. Never open with jargon or the technical contribution.
2. **Define every concept before using it.** Spell out abbreviations on first use. Explain in words before writing math. The math follows the intuition, never the reverse.
3. **One idea per sentence.** Short, declarative sentences. No hedging ("it should be noted that", "it is worth mentioning that") — just state the fact.
4. **Lead with the answer, not the reasoning.** Conclusion first, then evidence. The reader should know where you're going before you take them there.
5. **Describe the thing, then justify it.** The reader needs to understand *what* before they can appreciate *why*.
6. **Anchor every abstraction with a concrete example.** "Emergent compositionality" → the Factoring → CircuitSAT → ILP story. When introducing a pattern, immediately show one instance.
7. **Sections are self-contained units.** Re-introduce key terms briefly when they reappear. Avoid forward references to undefined concepts.
8. **Tables and figures earn their space.** Every figure is referenced in text, has a story-telling caption, and conveys something that prose alone cannot. No orphaned figures.
9. **The abstract is a standalone document.** No undefined abbreviations, no forward references, no citations. Problem → approach → result → significance.
10. **Cut ruthlessly.** Delete "In this section, we describe...", "It is important to note that...", "As mentioned above...", and any sentence that restates what was just said.

## Typst writing guidelines
[.claude/rules/typst-drawing.md](.claude/rules/typst-drawing.md)