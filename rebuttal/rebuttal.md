## Reviewer c6QA

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment (which are highlighted in italics).

> *My main concern is that the paper feels much more like an engineering report than a research paper. The work does not introduce a new learning method, a new agent architecture, a new optimization algorithm, a theoretical result, or a benchmark.*

Answer: We agree. Under NeurIPS Contribution Types, this submission is **Use-inspired**: it addresses a real application need instead of proposing a general-purpose ML method.

The need it addresses is one this community is beginning to ask about: *which scientific tasks were out of reach before, and only become possible with today's AI agents?* A reduction library is a clean instance. Finding a reduction and proving it correct is hard and takes human insight, but the literature already contains hundreds of proved rules. What was missing is the code. Writing one rule is a small, mechanical job, and there are hundreds of them, spread over decades of papers and subfields that few people span. That is too much tedious work for a researcher and too specialized for an engineer, so nobody did it. Agents can do this volume, and every rule can be checked automatically (the replies below analyze these checks and what they miss in the manuscript). Agents make mistakes, but tests catch them. This paper reports one such build.

What agents can and cannot build is an AI question, which is why we brought the study here rather than to a complexity theory or software venue. Two groups of readers can also use the library itself. One group builds solvers. A good solver for a single target such as ILP, QUBO, or SAT becomes a solver for every problem that reduces to that target, and the library supplies both the reductions and a large set of problems to test on. The other group works on quantum computing, where claiming an advantage means first putting a hard problem into a form the hardware accepts. The library lists those paths and what each one costs, so a path can be chosen by search instead of by hand. We also need these readers. The library is open and built for outside contributions, and the solvers, new problems, and bug reports they bring are what will let it grow beyond what our own group can maintain.

Where the draft still falls short of a strong Use-inspired paper is evaluation and transferable insight: we under-measure maintainer and domain-expert outcomes, and we under-analyze which harness choices matter. The replies below and the revision address those gaps; we do not claim to turn this into a methods paper.

> *The evaluation is also too thin for the claims. [...] I would have liked to see direct evidence: how much maintainer time was saved, how many agent-written PRs failed, how many errors were caught during review, and whether outside domain experts could actually use the no-code contribution route successfully.*

Answer: To provide this evidence, we went back through the complete development record of the main construction phase: every issue, pull request, review comment, and project-board event, cross-checked against the git history. The table summarizes what happened at each pipeline stage; three findings follow.


| Stage                      | What the record shows                                                                                              | Human role                                                                |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------- |
| 1. Propose                 | 381 proposals                                                                                                      | Issue templates only                                                      |
| 2. Validate                | **214 cleared directly**; of **167** entering repair, **128 (76.6%) passed and 39 (23.4%) stopped**                | Final park/close decision on stopped items                                |
| 3. Implement               | **168 unique issues** entered implementation; **1 direct block (0.6%)**                                            | Unblocking that one item                                                  |
| 4. Automated review        | Agentic tests found **0.97 confirmed defects per audited PR**; **63.4%** of audited PRs had a finding              | Issue/human comments prompted 7 recorded fixes; agents applied them       |
| 5. Final review            | **355 merged logical additions**: 296 after one repair round, 41 clean, 18 reworked; 1 additional attempt rejected | 4 semantic interventions (1.7% of shipped contributions); merge authority |
| 6. Post-merge verification | Humans re-examined ~70 non-ILP rules and found **16 defects across 15 rules, including 8 unsound constructions**   | Humans designed adversarial checks and chose repair vs. removal           |


To compare review layers on a common scale, we report yield per audited PR:


| Automated layer          | Yield per audited PR          | PRs affected | Main error types                                                                                                   |
| ------------------------ | ----------------------------- | ------------ | ------------------------------------------------------------------------------------------------------------------ |
| Compile-time type checks | **0.05 failed revisions/PR**  | **3.9%**     | API/field/import mismatch; feature gates; denied lints                                                             |
| Unit tests               | **0.10 failed revisions/PR**  | **4.9%**     | Evaluator/validation logic; stale fixtures; solver hangs/nondeterminism                                            |
| 266 round-trip tests     | Shared with unit tests        | n/a          | Reduce-solve-lift consistency; later audit exposed **8 unsound, 3 extraction, 4 overhead, 1 panic** escapes        |
| Agentic feature tests    | **0.97 confirmed defects/PR** | **63.4%**    | **34** workflow/docs, **15** validation/numeric, **10** registration/metadata, **8** semantic, **2** weak examples |


The early-layer entries are failed revisions rather than distinct defects because unit and round-trip checks shared one historical job.

**First, agent PRs did fail, and the record shows where:** 23.4% of flawed proposals could not be repaired, the detailed agentic reports contain almost one confirmed defect per PR, and one contribution was rejected outright.

**Second, the harness absorbed most failures automatically:** 76.6% of flawed proposals were repaired before any code was written; review reports attribute at least 74 fixes to Copilot findings and 7 to issue/human comments, all applied inside the agent repair loop; and 94.3% of corrected contributions cleared final review in a single round.

**Third, human intervention was rare but decisive.** Maintainers intervened at the merge gate only 4 times (touching 1.7% of the 351 shipped contributions), each time catching a semantic error that automation had passed. For example, one reduction used a vacuous budget that failed to preserve the optimization objective even though every automated test passed. Beyond the merge gate, human QA produced 10 corrective PRs: building independent test oracles (solver-generated witnesses, brute-force cross-checks) and re-examining ~70 rules for soundness, which removed 8 unsound reductions. This is what separates the harness from a build-test wrapper: agents run the repair loops; humans design adversarial tests, interpret semantic failures, and keep merge and removal authority.

[TODO: maintainer time saved; domain-expert usage of the no-code route.]

> *The harness itself is also not evaluated carefully enough. [...] there is no ablation showing which parts mattered.*

Answer: [TODO: ablation discussion.]

> *I also think the paper should be more careful with the word "verified." The reductions are tested and reviewed, but they are not formally verified.*

Answer: We agree and will say "tested and reviewed," not "verified," throughout the revision. The distinction is concrete in our own record: after merge, humans re-examined about 70 rules and found 8 unsound constructions that had passed the automated stack; they were removed, and reduction verification became a default gate. We will state both this measured result and its limits in the revision.

---



## Reviewer yPT8

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment (which are highlighted in italics).

> *W1: Limited algorithmic depth in the case study. The end-user utility experiment (Section 4.2) is based on a single problem class (signed-weight Maximum Cut).*

Answer: [TODO: broader end-user evaluation.]

> *W2: Dependency on specific LLM capabilities. It is unclear how sensitive the harness engineering framework is to the underlying model's capabilities, or how often human maintainers had to intervene during the "headless" implementation phases.*

Answer: For intervention frequency, we went through the complete development record of the construction phase; the stage-by-stage summary is in our reply to Reviewer c6QA, visible in this forum. In brief: **1 of 168 unique implementation issues (0.6%)** directly blocked and required human unblocking; maintainers intervened at the merge gate 4 times, touching 1.7% of shipped contributions; and human QA outside the ordinary contribution workflow produced 10 corrective PRs. [TODO: sensitivity to the underlying model's capabilities.]

> *W3: Overhead of the reductions. [...] the paper does not extensively evaluate the practical performance degradation caused by composing multiple reductions (e.g., the constant factors involved in a 3-hop reduction to QUBO).*

Answer: [TODO: practical overhead measurement.]

> *Q1: In the agentic feature tests, how often did the sub-agents hallucinate bugs that did not actually exist, and how was this noise filtered by the main agent?*

Answer: We re-audited the detailed agentic feature-test records. They contain **69 confirmed defects across 45 PRs (0.97 per audited PR)**; 26 PRs had no confirmed defect. Confirmation required the main agent to reproduce the command or trace the behavior to code before repair. We collapsed repeated reports and multiple symptoms of one root cause within a PR, which prevents retries and verbose sub-agent reports from inflating the count. The reports explicitly record three false alarms filtered this way: an incorrectly framed MCP probe, an allegedly required variant suffix that was not required, and an expected solver-fallback error treated as intended behavior. Because discarded suspicions were not logged systematically, three is a lower bound and does not support a hallucination rate. The 69 confirmed defects were 34 workflow/documentation failures, 15 validation or numeric-domain failures, 10 registration/metadata failures, 8 semantic errors, and 2 weak canonical examples.

> *Q2: What is the practical runtime overhead of composing multiple reductions (e.g., 3 hops to QUBO) compared to a hand-crafted, direct reduction for a specific problem?*

Answer: [TODO: overhead benchmark; see W3.]

> *Q3: How frequently did the automated implementation agent fail to produce a compiling or correct reduction, requiring the issue to be moved to the "On Hold" column for human intervention?*

Answer: **1 of 168 unique implementation issues (0.6%) directly blocked and required human intervention.** The On Hold column itself is not a failure queue: 92% of its transitions during the phase were routine claim locks, so reading the column as a failure count would substantially overestimate failures. Failures surfaced instead where the harness could absorb them: 23.4% of flawed proposals were stopped at the pre-implementation quality gate (the other 76.6% were repaired automatically), and one rule was rejected at Final Review as valid only on a restricted numeric domain. The four merge-gate interventions are itemized in our reply to Reviewer c6QA.

---



## Reviewer WsAZ

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment (which are highlighted in italics).

> *[...] the paper never reports what fraction of reductions required human correction of logical errors, or how often the verification stack misses a semantically incorrect reduction. Without that data, we cannot assess how tight the human bottleneck is.*

Answer: We measured both by going through the complete development record of the construction phase (stage-by-stage summary in our reply to Reviewer c6QA, visible in this forum).

Fraction requiring human correction: at Final Review, human logical or semantic correction was needed for **1.7% of shipped contributions**. Earlier review reports attribute at least 74 agent-applied fixes to Copilot findings and 7 agent-applied fixes to issue/human comments. Before implementation, the quality gate corrected mathematics or sources on 88 proposals and stopped 9 as semantically unsound.

Misses by the verification stack: final human review caught one vacuous-budget reduction after every automated check passed (described in our reply to Reviewer c6QA). Separately, after merge, humans re-examined about 70 rules and found **8 unsound constructions (about 11% of that focused subset)** and 7 further rules with extraction, overhead, or panic defects. The unsound reductions were removed, and reduction verification became a default gate. This is a focused-subgroup result, not a library-wide escape estimate. We therefore describe the artifact as tested and reviewed, not formally verified.

> *Section 1.2 is dense. The paper introduces "primitive reduction rules," "size features," "reduction overhead" without walking you through a single end-to-end example in the main text.*

Answer: [TODO: end-to-end example in Section 1.2.]

> *The paper also fails to clearly distinguish what is novel from what is standard practice. The six-stage pipeline looks like a standard build-test-merge workflow with LLM wrappers.*

Answer: Please see Q4 below.

> *Clarity suffers from oscillation between mathematical formalism in Section 1 and engineering description in Section 2.*

Answer: [TODO: bridge the reduction graph and the implementation.]

> *How do you verify that a generated reduction rule is correct? What fraction of reductions required human correction of logical errors?*

Answer: Please see our response to the first comment above: 1.7% of shipped contributions needed human logical correction at Final Review, and the post-merge re-examination of ~70 rules found ~11% of them unsound. [TODO: describe the verification stack itself.]

> *Can you walk through one non-trivial reduction end-to-end, showing what the agent produced versus what required human intervention?*

Answer: [TODO: end-to-end walkthrough; the vacuous-budget MinimumVertexCover-to-EnsembleComputation reduction (human-corrected to unit weights with the tight relation J=K+|E|) is a candidate.]

> *How do you handle cases where composed overhead makes a reduction path practically useless?*

Answer: We have one measured instance: human testing across reduction paths exposed a pathological, nondeterministically selected QAP-to-ILP path, and the fix made path selection overhead-aware and deterministic. [TODO: general overhead-handling policy.]

> *Which parts of the harness are actually novel versus standard automation with LLM wrappers?*

Answer: The development record shows the difference in practice. A build-test wrapper gates on compilation and tests; here, 76.6% of flawed proposals were repaired *before any code was written*, agentic feature tests (an AI sub-agent role-playing an end user) failed 32.4% of the PRs they reviewed, and 94.3% of corrected contributions cleared Final Review in one round. The human role is complementary, not supervisory of each step: designing solver-backed and brute-force test oracles, re-checking ~70 rules for soundness, and deciding repair versus removal. [TODO: sharpen the novelty statement (advisor versus automation skills, abstract steps).]

> *How many domain experts used the no-code contribution route, and what was their experience?*

Answer: [TODO: domain-expert usage.]