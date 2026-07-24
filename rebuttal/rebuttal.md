## Reviewer c6QA

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment (which are highlighted in italics).

> *My main concern is that the paper feels much more like an engineering report than a research paper. The work does not introduce a new learning method, a new agent architecture, a new optimization algorithm, a theoretical result, or a benchmark.*

Answer: [TODO: research-contribution positioning.]

> *The evaluation is also too thin for the claims. [...] I would have liked to see direct evidence: how much maintainer time was saved, how many agent-written PRs failed, how many errors were caught during review, and whether outside domain experts could actually use the no-code contribution route successfully.*

Answer: We answer with a retrospective audit of the complete Phase-3 record (2026-03-07 to 2026-04-08): 895 active issues and PRs, 3,861 project-board transitions, 1,804 discussion comments, and 337 inline review comments, cross-checked against the git history. A machine-checked completeness report confirms no timeline, review file, or board event is missing. Two counting conventions apply: a *logical contribution* is one problem model or one reduction rule (the 133 contribution-introducing PRs expand to 355 merged contributions—164 models, 191 rules; replacing four legacy rules gives the paper's net growth of 351); a *repair round* is one substantive corrective session (claim-lock retries are collapsed).


| Stage               | Observed record                                                                  | Failure / repair outcome                                                     | Documented human role                                              |
| ------------------- | -------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| 1. Propose          | 567 logical issues (224 models, 343 rules)                                       | —                                                                            | Issue templates only                                               |
| 2. Validate         | 381 proposals checked; 167 entered the automated repair loop                     | **128 repaired to Ready (76.6%); 39 stopped (23.4%)**                        | Park/close decisions on the 39                                     |
| 3. Implement        | 190 starts on 168 unique items                                                   | **1 hard failure (0.5%)**                                                    | Unblocking that one item                                           |
| 4. Automated review | Reports on 113 merged PRs; 71 carry an agentic feature-test verdict (Sec. III-D) | **23 of 71 verdicts fail (32.4%)**; at least 74 findings agent-repaired      | 7 findings maintainer-fixed; 7 items marked "needs human decision" |
| 5. Final review     | 356 logical attempts from 133 PRs                                                | **296 corrected in one round; 41 clean; 18 reworked; 1 rejected**            | 4 interventions (6 outputs, 1.7%); merge authority                 |
| 6. Community verify | 147 checklists; focused audit of ~70 non-ILP rules                               | **16 defects across 15 rules: 8 unsound, 3 extraction, 4 overhead, 1 panic** | Adversarial checks; repair-vs-removal decisions                    |


Agent PRs did fail, and the record shows where: 39 of 167 flawed proposals could not be salvaged in one repair round (23.4%); agentic feature tests returned fail verdicts on 23 of the 71 PRs they reviewed (32.4%); 18 of 355 merged contributions needed rework beyond one round; 1 was rejected outright. What the harness bought is visible in the same record: 76.6% of flawed proposals were repaired before any code was written, and 296 of the 314 corrected merged contributions (94.3%) cleared Final Review in a single round.

Human contribution is visible in a different record. At the final merge gate, maintainers intervened 4 times, touching 6 of 351 shipped contributions (1.7%), each after automation had passed or mislabeled the defect: a proposed problem that was Partition in disguise (#684); a makespan-*minimization* issue implemented as deadline *feasibility* (#760); a vacuous-budget reduction that did not preserve the optimization problem, caught after all 11 automated tests passed (#804); and a degenerate example replaced by an ILP-backed remedy (#819). Beyond `[Model]`/`[Rule]` delivery, we found 12 human QA/report trajectories: 10 confirmed problems produced 10 corrective PRs, and 2 reports were investigated and correctly triaged. These include CLI and build QA (#189, #697); harness and test-oracle audits (#636, #701, #772, #773, #974) that added exhaustive solution tests, solver-generated witnesses for 46 examples, and brute-force-vs-ILP checks for 46 of 85 ILP rules; cross-path correctness audits (#780, #789) that caught a pathological QAP-to-ILP path and an unsound zero-cost connector in HamiltonianCircuit-to-StackerCrane; and a systematic soundness audit (#1000–#1006, corrective PR #1052) that found 16 defect instances across 15 of ~70 examined non-ILP rules and removed 8 unsound constructions. This distinguishes the harness from a build-test wrapper: agents execute recoverable repair loops, while humans design adversarial tests, interpret semantic failures, and retain merge/removal authority.

All numbers are regenerated by `audit.py` in the supplementary directory, which fails loudly if any cross-check breaks; per-event classifications and raw records are checked in. [TODO: maintainer time saved; domain-expert usage of the no-code route.]

> *The harness itself is also not evaluated carefully enough. [...] there is no ablation showing which parts mattered.*

Answer: [TODO: ablation discussion.]

> *I also think the paper should be more careful with the word "verified." The reductions are tested and reviewed, but they are not formally verified.*

Answer: We agree and will say "tested and reviewed," not "verified," throughout the revision. The audit makes the distinction concrete: a human-directed post-merge audit of ~~70 non-ILP rules found 8 unsound constructions (~~11% of that focused subset) that had passed the automated stack; the 8 unsound edges were removed, `verify-reduction` became a default gate, and the global escape rate remains unmeasured. We will state both the measured subgroup result and its limits in the revision.

---

## Reviewer yPT8

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment (which are highlighted in italics).

> *W1: Limited algorithmic depth in the case study. The end-user utility experiment (Section 4.2) is based on a single problem class (signed-weight Maximum Cut).*

Answer: [TODO: broader end-user evaluation.]

> *W2: Dependency on specific LLM capabilities. It is unclear how sensitive the harness engineering framework is to the underlying model's capabilities, or how often human maintainers had to intervene during the "headless" implementation phases.*

Answer: For intervention frequency, we audited the complete Phase-3 record (895 issues and PRs, 3,861 project-board transitions); the methodology and full tables are in our reply to Reviewer c6QA, visible in this forum. In brief: 1 of 190 implementation starts (0.5%) required human unblocking; at the final merge gate, maintainers intervened 4 times, touching 6 of 351 shipped contributions (1.7%); and 12 human QA trajectories outside the ordinary contribution workflow produced 10 corrective PRs plus 2 correctly triaged reports. [TODO: sensitivity to the underlying model's capabilities.]

> *W3: Overhead of the reductions. [...] the paper does not extensively evaluate the practical performance degradation caused by composing multiple reductions (e.g., the constant factors involved in a 3-hop reduction to QUBO).*

Answer: [TODO: practical overhead measurement.]

> *Q1: In the agentic feature tests, how often did the sub-agents hallucinate bugs that did not actually exist, and how was this noise filtered by the main agent?*

Answer: [TODO: hallucinated-bug rate and filtering.]

> *Q2: What is the practical runtime overhead of composing multiple reductions (e.g., 3 hops to QUBO) compared to a hand-crafted, direct reduction for a specific problem?*

Answer: [TODO: overhead benchmark; see W3.]

> *Q3: How frequently did the automated implementation agent fail to produce a compiling or correct reduction, requiring the issue to be moved to the "On Hold" column for human intervention?*

Answer: **1 of 190 implementation starts (0.5%) failed into On Hold for human intervention** (issue #200). The On Hold column itself is not a failure queue: of its 241 Phase-3 transitions, 222 (92%) are workflow claim locks—the pipeline parks an item there while an agent holds it (168 `fix-issue` claims, 54 Final-Review claims)—so reading the column as a failure count would overestimate failures by two orders of magnitude. Failures instead surfaced where the harness could absorb them: 39 proposals were stopped at the pre-implementation quality gate (128 of 167 flawed proposals, 76.6%, were repaired automatically), and one rule was rejected at Final Review because it was valid only on a restricted numeric domain. The four merge-gate interventions are itemized in our reply to Reviewer c6QA. All counts are regenerated by the checked-in `audit.py`, which fails loudly if any cross-check breaks.

---

## Reviewer WsAZ

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment (which are highlighted in italics).

> *[...] the paper never reports what fraction of reductions required human correction of logical errors, or how often the verification stack misses a semantically incorrect reduction. Without that data, we cannot assess how tight the human bottleneck is.*

Answer: We measured both, by auditing the complete Phase-3 record (895 issues and PRs, 3,861 project-board transitions; methodology and full tables are in our reply to Reviewer c6QA, visible in this forum).

Fraction requiring human correction: at Final Review, human logical or semantic correction was needed in 4 trajectories touching **6 of 351 shipped contributions (1.7%)**; the remaining documented review repairs were executed by agents inside the staged loop (at least 74 review findings agent-fixed versus 7 maintainer-fixed). Before implementation, the quality gate corrected mathematics or sources on 88 proposals and stopped 9 as semantically unsound.

Misses by the verification stack: final human review caught one vacuous-budget reduction after all automated checks passed (PR #804). Separately, a human-directed post-merge audit examined ~~70 non-ILP rules and found **8 unsound constructions (~~11% of that focused subset)** plus 8 extraction, overhead, or panic defects (16 instances across 15 rules; one rule had two defect types). The 8 unsound edges were removed and `verify-reduction` became a default gate. This is a focused-subgroup result, not a library-wide escape estimate; community checklist completion was not logged systematically. We therefore describe the artifact as tested and reviewed, not formally verified.

> *Section 1.2 is dense. The paper introduces "primitive reduction rules," "size features," "reduction overhead" without walking you through a single end-to-end example in the main text.*

Answer: [TODO: end-to-end example in Section 1.2.]

> *The paper also fails to clearly distinguish what is novel from what is standard practice. The six-stage pipeline looks like a standard build-test-merge workflow with LLM wrappers.*

Answer: Please see Q4 below.

> *Clarity suffers from oscillation between mathematical formalism in Section 1 and engineering description in Section 2.*

Answer: [TODO: bridge the reduction graph and the implementation.]

> *
>
> 1. How do you verify that a generated reduction rule is correct? What fraction of reductions required human correction of logical errors?*

Answer: Please see our response to the first comment above: 1.7% of shipped contributions needed human logical correction at Final Review, and the focused post-merge audit measured an ~11% unsound rate in its ~70-rule subset. [TODO: describe the verification stack itself.]

> *
>
> 1. Can you walk through one non-trivial reduction end-to-end, showing what the agent produced versus what required human intervention?*

Answer: [TODO: end-to-end walkthrough; PR #804 (vacuous-budget MinimumVertexCover-to-EnsembleComputation, human-corrected to unit weights with the tight relation J=K+|E|) is a candidate.]

> *
>
> 1. How do you handle cases where composed overhead makes a reduction path practically useless?*

Answer: Partially measured by the audit: a human cross-path audit (#780) exposed a pathological nondeterministically-selected QAP-to-ILP path, and the corrective PR #785 made path selection overhead-aware and deterministic. [TODO: general overhead-handling policy.]

> *
>
> 1. Which parts of the harness are actually novel versus standard automation with LLM wrappers?*

Answer: The audited record shows the difference operationally. A build-test wrapper gates on compilation and tests; here, 76.6% of flawed proposals were repaired *before any code was written*, agentic feature tests (an AI sub-agent role-playing an end user) returned fail verdicts on 32.4% of the PRs they reviewed, and 94.3% of corrected contributions cleared Final Review in one round. The human role is complementary, not supervisory of each step: designing solver-backed and brute-force test oracles, auditing ~70 rules for soundness, and deciding repair versus removal. [TODO: sharpen the novelty statement (advisor versus automation skills, abstract steps).]

> *
>
> 1. How many domain experts used the no-code contribution route, and what was their experience?*

Answer: [TODO: domain-expert usage.]