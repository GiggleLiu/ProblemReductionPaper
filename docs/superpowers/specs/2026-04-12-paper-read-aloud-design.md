# Paper Read-Aloud Skill Design

**Skill name:** `paper-read-aloud`  
**Date:** 2026-04-12  
**Status:** Approved  

## Purpose

An interactive skill that reads a LaTeX paper paragraph by paragraph using macOS TTS (`say`), pauses after each paragraph to analyze it as a naive first-time reader, reports issues, proposes fix options, and applies chosen edits before advancing.

The core value is that *hearing* prose aloud exposes awkward phrasing, overloaded sentences, and logical gaps that silent reading misses. The forced stopping after each paragraph prevents the "skim and move on" habit.

## Architecture

**Single-agent loop.** Claude reads the paper itself — no subagent dispatch. The agent accumulates context naturally as it progresses through paragraphs. This is simpler and faster than per-paragraph subagents, and the primary value (audio pacing + forced stopping) doesn't require strict context isolation.

## Invocation

```
/paper-read-aloud          # starts at Section 1
/paper-read-aloud 3        # starts at Section 3
```

The argument is a section number (matching `\section{}` order in the `.tex` file).

## Setup Phase

1. Read the full `paper.tex` file.
2. Parse section structure — extract `\section{}` and `\subsection{}` headers with line ranges.
3. Display a numbered section index.
4. If a section number was given, jump there. Otherwise start at Section 1.
5. Split the target section into paragraphs by blank lines.
6. Display: `"Reading Section N: <title> — X paragraphs. Starting..."`

## LaTeX-to-Speech Stripping

| LaTeX construct | Speech treatment |
|---|---|
| `\cite{...}` | Remove (citations are noise aloud) |
| `\label{...}` | Remove |
| `\ref{...}`, `\eqref{...}` | "Figure reference" / "Equation reference" |
| `\textbf{...}`, `\textit{...}`, `\emph{...}` | Keep inner text |
| `\texttt{...}` | Keep inner text |
| `$...$` inline math | Best-effort pronunciation (e.g., `$O(n^2)$` → "O of n squared") |
| `\begin{figure}...\end{figure}` | Skip entirely |
| `\begin{lstlisting}...\end{lstlisting}` | Skip, announce "code listing skipped" |
| `\begin{equation}...\end{equation}` | Say "equation block" |
| `\begin{itemize}` / `\begin{enumerate}` list items | Keep as plain text |

## The Read-Analyze-Fix Loop

For each paragraph:

### Step 1 — Display & Speak

- Show the raw LaTeX paragraph in a quoted block with line number range (e.g., `lines 142-155`).
- Run `say` via Bash with the stripped plain-text version. Default system voice, normal rate.
- Wait for `say` to finish before proceeding.

### Step 2 — Naive Reader Analysis

Analyze the paragraph as if hearing it for the first time. Check for:

- **Undefined terms** — jargon or acronyms used before being defined
- **Logical gaps** — conclusions that don't follow from what was stated
- **Unclear referents** — "this", "it", "these" pointing to ambiguous antecedents
- **Overloaded sentences** — sentences doing too much (multiple ideas crammed in)
- **Awkward phrasing** — things that sounded wrong when read aloud
- **Redundancy** — saying the same thing twice in different words

If no issues found: print `"No issues. Moving to next paragraph."` and advance automatically.

### Step 3 — Fix Menu (only if issues found)

For each issue:

1. State the problem in one sentence.
2. Offer 2-3 fix options labeled A/B/C, with a recommended one marked.
3. Wait for user to pick one, or type `s` to skip that issue.

After all issues are resolved, apply edits with the Edit tool, then advance.

## Navigation Commands

The user can type these anytime during the loop:

| Command | Effect |
|---|---|
| `next` / `n` | Skip this paragraph without analysis |
| `stop` | End session, show summary |
| `replay` | Re-read the current paragraph aloud |
| `re-read` | Re-read after edits have been applied |

## Session End

When `stop` is typed or all paragraphs in the section are done:

- Print summary: paragraphs read, issues found, fixes applied.
- If the section is complete, ask: `"Continue to next section?"`

## Edge Cases

- **Figures/tables**: Skip but announce: `"[Figure N: <caption text>] — skipped."`
- **Code listings**: Skip with `"[Code listing] — skipped."`
- **Very short paragraphs**: Read and analyze individually. No merging.
- **Equations**: Read surrounding context; say `"equation block"` for the math itself.
- **Line number drift after edits**: Re-read `paper.tex` after applying fixes to get updated line numbers.
- **Long paragraphs (>200 words)**: Let `say` finish. No splitting. User can `stop` to interrupt.

## Scope Boundaries

This skill does NOT do:

- Overall structural review (use `paper-revision` for that)
- Bibliography checking
- Figure/table content review
- Cross-section coherence analysis

## Tools Used

- `Read` — read `paper.tex`
- `Bash` — run `say` command for TTS
- `AskUserQuestion` — wait for user input after each paragraph
- `Edit` — apply chosen fixes to `paper.tex`
