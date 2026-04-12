# Session Log: paper-read-aloud Skill Design

**Date:** 2026-04-12  
**Skill:** `superpowers:brainstorming`  
**Outcome:** Skill file created at `.claude/skills/paper-read-aloud/SKILL.md`

---

## User

> brainstorm: build a skill, read paper paragraph by paragraph (with text to audio), after each paragraph, stop, report issue, and propose ways to fix and wait for reply.

## Agent

Invoked `Skill("superpowers:brainstorming")` to start the brainstorming process.

Created `TaskCreate`: "Explore project context for paper-reading skill"

Launched `Agent(subagent_type=Explore)`: explored existing skills (`paper-revision`, `paper-writing-review`, `test-writing`), macOS `say` command capabilities, and `paper.tex` structure.

**Findings summary:**
- Skills are Markdown with YAML frontmatter, versioned, reusable
- `paper-revision` (v2.6) combines full-context editor with naive-reader subagent
- `test-writing` (v1.0) standardizes first-time reader simulation
- `paper-writing-review` is a local variant for section-by-section polish
- macOS `say` is available natively with many voices and options
- `paper.tex` is 763 lines, IEEE conference format

Then asked:

> **What role should Claude play after each paragraph?** Options:
> - **A) Naive reader** — flags confusion, undefined terms, logical gaps
> - **B) Writing coach** — focuses on prose quality: wordiness, passive voice, rhythm
> - **C) Both combined**
> - **D) Minimal / user-driven** — Claude just reads aloud and pauses; user raises issues

## User

> A

## Agent

> Got it — **naive reader** mode.
>
> **How should the audio work?**
> - **A) macOS `say` command** — built-in, no dependencies, reads each paragraph aloud through speakers. Simple but robotic voice.
> - **B) Audio file generation** — `say -o output.aiff` saves each paragraph as an audio file.
> - **C) No actual audio — just the "read aloud" metaphor** — Claude processes paragraph-by-paragraph with pauses, but user reads silently.

## User

> A

## Agent

> Good — macOS `say` for actual audio.
>
> **What should happen when you want to act on an issue?**
> - **A) Fix menu** — Claude proposes 2-3 fix options per issue, you pick one (or skip), Claude applies the edit, then moves to the next paragraph
> - **B) Discussion first** — Claude reports issues, you discuss back and forth until satisfied, then say "next" to advance
> - **C) Batch at end** — Claude reports issues but doesn't fix yet — just logs them. After the full read-through, you go back and fix in bulk

## User

> A

## Agent

> Good — fix menu with options per issue, apply inline, then advance.
>
> **What's the unit of "paragraph" for LaTeX?**
> - **A) Blank-line delimited** — standard LaTeX paragraph breaks. Lists, code blocks, and math environments are each treated as their own unit.
> - **B) Subsection-level** — read everything between `\subsection{}` headers as one chunk.
> - **C) Semantic chunks** — Claude intelligently splits: a prose paragraph is one unit, a list is one unit, a code listing is one unit.

## User

> A

## Agent

> Good — blank-line delimited, the natural LaTeX paragraph boundary.
>
> **Should the skill support starting from / jumping to a specific section?**
> - **A) Always start from the beginning** — full sequential read every time
> - **B) User specifies a starting section** — e.g., `/paper-read-aloud 3` starts at Section 3, then reads sequentially from there
> - **C) User specifies a section range** — e.g., `/paper-read-aloud 3-4` reads only Sections 3 and 4

## User

> B

## Agent

Proposed 3 approaches:

### Approach A: Single-agent loop (Recommended)

Claude reads the paper itself, paragraph by paragraph. For each paragraph:
1. Strip LaTeX commands to plain text
2. Run `say` via Bash to read aloud
3. Analyze as a naive reader — flag issues
4. Present fix menu via `AskUserQuestion`
5. Apply chosen fixes with `Edit`
6. Advance to next paragraph

**Pros:** Simple, full context of prior paragraphs accumulates naturally, edits are immediate.  
**Cons:** Context window fills up over a long paper; the analyzer has full paper context (not truly "naive").

### Approach B: Subagent per paragraph

Main agent orchestrates. For each paragraph, dispatches a subagent that receives only the current paragraph + a brief summary of what came before.

**Pros:** True context isolation — subagent genuinely doesn't know what's coming.  
**Cons:** More complex, slower (agent dispatch per paragraph), harder to apply edits.

### Approach C: Hybrid — single agent with "amnesia" protocol

Single agent with explicit instructions to only consider text seen so far.

**Pros:** Simple like A, aims for naivety like B.  
**Cons:** LLMs are bad at pretending they haven't seen text they've already read.

**Recommendation:** Approach A. The value is the *audio pacing* and *forced stopping*.

## User

> A

## Agent

Presented design in 3 sections, each approved by the user:

### Design Section 1: Invocation & Setup

- **Skill name:** `paper-read-aloud`
- **Trigger:** `/paper-read-aloud` or `/paper-read-aloud 3`
- **Setup:** Read `paper.tex`, parse sections, display index, jump to target, split into paragraphs by blank lines
- **LaTeX-to-speech stripping rules:** Remove `\cite`, `\label`, `\ref`; keep inner text of `\textbf`/`\textit`/`\emph`/`\texttt`; best-effort math pronunciation; skip figures and code listings

## User

> yes

## Agent

### Design Section 2: The Read-Analyze-Fix Loop

**Step 1 — Display & Speak:**
- Show raw LaTeX in blockquote with line range
- Run `say` with stripped text
- Wait for finish

**Step 2 — Naive Reader Analysis (checks for):**
- Undefined terms
- Logical gaps
- Unclear referents
- Overloaded sentences
- Awkward phrasing
- Redundancy

If no issues: `"No issues. Moving to next paragraph."` and advance automatically.

**Step 3 — Fix Menu (if issues found):**
- State problem in one sentence
- Offer 2-3 fix options (A/B/C), recommended one marked
- Wait for pick or `s` to skip
- Apply edits, then advance

**Navigation commands:**
- `next` / `n` — skip paragraph
- `stop` — end session with summary
- `replay` — re-read current paragraph
- `re-read` — re-read after edits applied

## User

> yes

## Agent

### Design Section 3: Session End & Edge Cases

**Session end:** Summary of paragraphs read, issues found, fixes applied. Ask "Continue to next section?" if section complete.

**Edge cases:**
- Figures/tables: skip, announce with caption
- Code listings: skip with announcement
- Very short paragraphs: read individually, no merging
- Equations: say "equation block"
- Cross-references: say "Figure reference" / "Equation reference"
- Line number drift after edits: re-read `paper.tex` for updated line numbers
- Long paragraphs: let `say` finish, user can `stop`

**Out of scope:** No structural review, no bibliography checking, no figure review, no cross-section coherence.

## User

> yes

## Agent

All 3 design sections approved.

### Write Design Spec

Created `TaskCreate`: "Write design spec document"

Created directory: `docs/superpowers/specs/`

Wrote spec to: `docs/superpowers/specs/2026-04-12-paper-read-aloud-design.md`

**Spec self-review:**
- Placeholder scan: clean
- Internal consistency: clean
- Scope check: single skill file, well-scoped
- Ambiguity fix: added `say -f /tmp/paragraph.txt` to avoid shell quoting issues

Used `Edit` to update the spec with the `say -f` clarification.

> Spec written to `docs/superpowers/specs/2026-04-12-paper-read-aloud-design.md`. Please review it and let me know if you want any changes before we move on to writing the implementation plan.

## User

> continue

## Agent

### Write Skill File

Created `TaskCreate`: "Write the skill SKILL.md file"

Read existing skill at `.claude/skills/paper-writing-review/SKILL.md` (161 lines) to match format and conventions.

Created directory: `.claude/skills/paper-read-aloud/`

Wrote skill file to: `.claude/skills/paper-read-aloud/SKILL.md`

The skill file includes:
- YAML frontmatter (`name`, `description`)
- Overview section
- When to Use triggers
- Invocation syntax
- Workflow diagram (dot graph)
- Setup steps (4 steps)
- LaTeX-to-speech stripping table
- Read-Analyze-Fix Loop (3 steps)
- Navigation commands table
- Edge cases
- Session end behavior
- Scope boundaries
- Common mistakes

> Skill created at `.claude/skills/paper-read-aloud/SKILL.md`. Ready to use with `/paper-read-aloud` or `/paper-read-aloud 3`.

---

## Files Created

| File | Purpose |
|---|---|
| `docs/superpowers/specs/2026-04-12-paper-read-aloud-design.md` | Approved design spec |
| `.claude/skills/paper-read-aloud/SKILL.md` | The skill definition file |

## Design Decisions Summary

| Decision | Choice | Alternatives Considered |
|---|---|---|
| Role | Naive reader | Writing coach, Both, Minimal |
| Audio | macOS `say` command | Audio file generation, No audio |
| Fix workflow | Fix menu (A/B/C per issue) | Discussion first, Batch at end |
| Paragraph unit | Blank-line delimited | Subsection-level, Semantic chunks |
| Navigation | Start from specified section | Always from beginning, Section range |
| Architecture | Single-agent loop | Subagent per paragraph, Hybrid amnesia |
