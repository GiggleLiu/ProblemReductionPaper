## Reviewer c6QA

We thank the reviewer for their feedback. Following are our responses to each individual comment.

> *My main concern is that the paper feels much more like an engineering report than a research paper. The work does not introduce a new learning method, a new agent architecture, a new optimization algorithm, a theoretical result, or a benchmark.*

Answer: We do not claim a new learning method, agent architecture, etc. Under the official NeurIPS Contribution Types, this is a **Use-inspired** paper.

First, we address a central question for the research community: *what scientific work can humans pursue in the AI era?* We identify large-scale reduction-library construction as one answer. The task has a mechanical side: integrating hundreds of known reductions under one interface. It also requires nontrivial judgments of correctness and usefulness. The resulting graph is itself scientifically valuable because it connects hard problems to solvers. Each rule is concretely falsifiable because one counterexample is enough to reject it. Tasks that combine repetitive scale, nontrivial reasoning, scientific value, and cheap falsification are rare. This combination makes reduction-library construction especially well suited to human–agent collaboration.

Second, our research object is the domain-specific harness that made this build possible (Secs. 2–3). It has three parts: a skill-based automation pipeline, a no-code contribution route for domain experts, and a multilayer verification stack. The decisive verification step is agentic feature testing. A fresh-context agent drives the real CLI, searches for counterexamples, and rejects a rule when it finds one.

We will revise Section 1 and Related Work so this Use-inspired framing and the harness-level contribution are stated up front, rather than left for the reader to infer from the build narrative.

> *The evaluation is also too thin for the claims. [...] I would have liked to see direct evidence: how much maintainer time was saved, how many agent-written PRs failed, how many errors were caught during review, and whether outside domain experts could actually use the no-code contribution route successfully.*

Answer: The four questions can be answered directly from our development record. We will add these numbers to Section 4.


| Question                                | Answer                                                                                                                         |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Maintainer time saved                   | ~30× rule throughput vs. the Julia prototype                                                                                   |
| Agent-written PRs failed                | Feasibility was screened before implementation; only 1 of 168 issues that passed this strict gate was rejected at Final Review |
| Errors caught during review             | Agentic feature testing confirmed 0.97 defects per audited PR; 63.4% of audited PRs had a finding                              |
| No-code route usable by outside experts | Yes: six domain experts contributed ~245 of the 265 rules through this route                                                   |


**1. No-code contributions.** About 20 of the 265 rules in v0.5.0 came from the pre-agent Julia prototype cited in Related Work. Six domain experts contributed the other ~245 through the no-code route.


**2. Pre-implementation quality gate.** We moved feasibility checks before implementation. Of 381 proposals, 214 passed immediately. The other 167 entered `fix-issue`; the agent repaired 128, while 39 were stopped before implementation.


| Outcome                 | Count              |
| ----------------------- | ------------------ |
| Proposed issues         | 381                |
| Passed quality gate     | 214                |
| Entered `fix-issue`     | 167                |
| … repaired by the agent | 128 (76.6%) of 167 |
| … stopped / On Hold     | 39 (23.4%) of 167  |


Of the 167 that entered `fix-issue`, most failures were mechanical. An agent can fix them by searching the literature and writing simple scripts, without human review. In the record, that meant filling in missing fields in the issue template (size fields, complexity bounds, etc.) (66% of 167), fixing incomplete or wrong examples (46%), correcting wrong size measures in the overhead table (19%), defining missing symbols (17%), completing incomplete algorithm steps (8%), and correcting wrong citations or textual descriptions (77%).

The 39 stopped issues required a human decision. Those ones need human intelligence to fix.


| What the record shows                                          | Count |
| -------------------------------------------------------------- | ----- |
| The reduction algorithm was incomplete, unverifiable, or wrong | 22    |
| Prerequisite not in the library                                | 12    |
| Already covered or isomorphic                                  | 5     |


**3. Review.** Compilation, unit tests, and round-trip tests are hard merge gates. Agentic feature testing then reviews the change through the real CLI. As we stated in Appendix G, interface checks accounted for 64% of confirmed findings in audited PRs, and counterexample searches accounted for 33%. For example, it caught 16 defects among 70 non-ILP rules that had already passed compilation, unit, and round-trip tests. Overall, it confirmed 0.97 defects per audited PR, and 63.4% of audited PRs had a finding. 

**4. Maintainer effort and throughput.** At Final Review, maintainers acted on the agent’s report instead of reviewing line-by-line diffs. Because we moved the strict feasibility gate before implementation, nearly every issue that entered implementation was ultimately implemented correctly. Only 1 rule was rejected at Final Review and not merged.

Our harness greatly reduced the maintainers’ implementation and maintenance burden. Against the Julia prototype, rule throughput rose about 30×.

|                       | Julia prototype | This library (v0.5.0) |
| --------------------- | --------------- | --------------------- |
| Main build window     | ~6 months       | ~3 months             |
| Problem types / rules | 17 / 17         | 190 / 265             |
| Source size           | ~4.3k lines     | 170k+ lines           |

By week 8.5, the library had 23 problem types and 52 rules. After the full pipeline was in place, it grew to 190 types and 265 rules in under five weeks.

> *The harness itself is also not evaluated carefully enough. [...] there is no ablation showing which parts mattered.*

Answer: The stage-by-stage contribution of the full pipeline is quantified in our previous response. Here we focus on agentic feature testing. A reduction rule is concretely falsifiable because one counterexample is enough to reject it. Agentic feature testing exploits this property by actively searching for counterexamples. During development, it caught 16 defects among 70 non-ILP rules that had already passed compilation, unit, and round-trip tests.

This aggregate result shows value beyond the conventional gates. To test whether that value comes only from running more instances, we compare agent-guided construction with uniform-random testing in one Optimal Communication Spanning Tree (OCST) → ILP case:


| Test layer                 | Instances | Defects |
| -------------------------- | --------- | ------- |
| Existing repo tests        | 7         | 0       |
| Uniform-random instances   | 100       | 0       |
| Agent-constructed instance | 1         | 1       |

The conventional and uniform-random tests both missed the bug. The agent targeted a structural weak spot and found it. In practice, agentic feature testing combines breadth with targeting (the second and the third rows in the table). The agent tests broad families of common instances while also generating cases around likely structural weak points.

We will add the aggregate result and the OCST → ILP case to Section 4.

> *I also think the paper should be more careful with the word "verified." The reductions are tested and reviewed, but they are not formally verified.*

Answer: We agree that “verified” can be read as formal verification. We will therefore write “tested and reviewed” throughout. Our claim is practical usability supported by agentic feature testing plus compile, unit, and round-trip gates (Secs. 2–3), not formal verification. For a practical package of this scope, this is the strongest assurance we can provide without claiming formal verification.

---

## Reviewer yPT8

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment.

> *W1: Limited algorithmic depth in the case study. The end-user utility experiment (Section 4.2) is based on a single problem class (signed-weight Maximum Cut).*

Answer: We agree that one problem class was too narrow. We therefore repeated the same comparison, switching web search and `pred` on and off one at a time, on three more problems (maximum-likelihood ranking, two-color PaintShop, and bounded closest vector). Each problem used ten random instances, a fresh agent and working directory, one 90-second solver call, and an independent check against the original problem.


| Source problem             | Bare AI | Web only | `pred` | `pred` + web |
| -------------------------- | ------- | -------- | ------ | ------------ |
| Maximum-likelihood ranking | 2/10    | 1/10     | 1/10   | 2/10         |
| Two-color PaintShop        | 0/10    | 1/10     | 2/10   | 5/10         |
| Bounded closest vector     | 4/10    | 2/10     | 6/10   | 6/10         |
| **Total**                  | 6/30    | 4/30     | 9/30   | 13/30        |


This remains a simple case study, not the contribution of the paper. The contribution is the library and the harness that built it. The case study is useful mainly for what it teaches about downstream use. Giving the agent only a short Markdown skill on how to call `pred` is not enough. With that skill alone, `pred` reaches 9/30 accepted answers, while `pred` + web reaches 13/30. The graph can change where the agent goes, but a usable answer still depends on what is run after the reduction.

That lesson is exactly why we think the artifact matters. Before a shared reduction library, each agent or solver stack reinvented problem modeling on its own. With a common graph, those later pieces can share one narrative. They match a natural problem to a typed node, walk a tested path to a solver-ready form, and map the answer back. Path ranking, solver bindings, formulation comparison, and hardware-aware choice can all sit on top of that shared substrate. None of them is in the present experiment, and none of them needs to be invented from scratch for each new problem. Once that shared story exists, later systems can improve on top of it in many ways, and almost any of those ways is better than asking each agent to rediscover modeling and reduction from scratch. We will broaden Section 4.2 with this multiclass illustration and state clearly that the case study is a starting point for such workflows, not a claim that a skill alone finishes the job.

> *W2: Dependency on specific LLM capabilities. It is unclear how sensitive the harness engineering framework is to the underlying model's capabilities, or how often human maintainers had to intervene during the "headless" implementation phases.*

Answer: For intervention frequency, see our reply to Reviewer c6QA. In brief, 1 of 168 unique implementation issues (0.6%) directly blocked; merge-gate semantic interventions happened 4 times (1.7% of 351 shipped contributions); maintainers operated without reading agent PR diffs as the review method. The retroactive adversarial re-test numbers are in that same reply. [TODO sensitivity to the underlying model's capabilities.]

> *W3: Overhead of the reductions. [...] the paper does not extensively evaluate the practical performance degradation caused by composing multiple reductions (e.g., the constant factors involved in a 3-hop reduction to QUBO).*

Answer: Encoding time stays in milliseconds when the composed path preserves target size. The main practical degradation is target-size blowup from auxiliary variables. Details and timings are in Q2 below.

> *Q1: In the agentic feature tests, how often did the sub-agents hallucinate bugs that did not actually exist, and how was this noise filtered by the main agent?*

Answer: [TODO]

> *Q2: What is the practical runtime overhead of composing multiple reductions (e.g., 3 hops to QUBO) compared to a hand-crafted, direct reduction for a specific problem?*

Answer: We added a controlled MIS-to-QUBO benchmark on an Apple M3 (release builds; medians after two warmups). We compare a hand-crafted direct encoder with two library paths. The recommended route is `MIS → SetPacking<i32> → SetPacking<f64> → QUBO`. The discarded route is `MIS → Clique → ILP → QUBO`. On a dense 128-vertex instance:


|                      | Direct encoding | Recommended path | Discarded path |
| -------------------- | --------------- | ---------------- | -------------- |
| Encoding time        | 0.013 ms        | 9.09 ms          | 174 ms         |
| QUBO variables       | 128             | 128              | 4,192          |
| Dense matrix storage | 0.125 MiB       | 0.125 MiB        | 134.1 MiB      |


The recommended path matches the direct encoder entry by entry (128 variables, 0.125 MiB). Composition adds about 9 ms of one-time preprocessing, noticeable as a relative factor and negligible next to any nontrivial solve. The discarded path is the practical failure mode. It takes 174 ms to encode and yields a 4,192-variable / 134 MiB QUBO. On a sparse 512-vertex graph, the recommended-path comparison is similar (0.043 ms vs 14.7 ms; identical QUBOs). We will report both construction time and final target size in the revision.

> *Q3: How frequently did the automated implementation agent fail to produce a compiling or correct reduction, requiring the issue to be moved to the "On Hold" column for human intervention?*

Answer: 1 of 168 unique implementation issues (0.6%) directly blocked and required human intervention. Of On Hold transitions in that phase, 92% were routine claim locks, so the column count overstates implementation failure if read as a failure queue. Of proposals that entered repair, 39 / 167 (23.4%) stopped at the pre-implementation gate and 128 / 167 (76.6%) were repaired automatically. 1 rule was rejected at Final Review. The 4 merge-gate semantic interventions are in our reply to Reviewer c6QA.

---

## Reviewer WsAZ

Rebuttal: We thank the reviewer for their feedback. Following are our responses to each individual comment.

> *[...] the paper never reports what fraction of reductions required human correction of logical errors, or how often the verification stack misses a semantically incorrect reduction. Without that data, we cannot assess how tight the human bottleneck is.*

Answer: See our reply to Reviewer c6QA for the layered reading of the checks. Short version follows.

Human semantic correction at the merge gate numbered 4 interventions (1.7% of 351 shipped contributions). Agents applied repairs from round-trip and agentic feature tests. Maintainers did not use line-by-line diff reading as the correction path. Before implementation, 39 / 167 proposals that entered repair were stopped as irreparable.

The misses include the vacuous-budget case, plus the retroactive strengthened adversarial re-test of about 70 v0.5.0 rules that found 8 unsound constructions (and 7 further extraction/overhead/panic defects). Humans then design stronger oracles and keep removal authority. We will describe the artifact as tested and reviewed. The audit is why that wording is required.

> *Section 1.2 is dense. The paper introduces "primitive reduction rules," "size features," "reduction overhead" without walking you through a single end-to-end example in the main text. Clarity suffers from oscillation between mathematical formalism in Section 1 and engineering description in Section 2.*

Answer: We agree and will replace the abstract notation in Section 1.2 with one example. Our 150-person team-split problem is Maximum Cut. To solve it on an Ising machine, the library follows Maximum Cut $\to$ SpinGlass $\to$ QUBO, then maps the machine's answer back to a team assignment.

Each arrow is one translation step, which we call a *primitive reduction rule*. It converts an instance into the next form and knows how to translate the resulting solution back. To track the cost of this translation, the library records the counts that determine an instance's size. For Maximum Cut, those counts are the numbers of people and scored pairs. For QUBO, the count is the number of binary variables. We call these counts *size measures*. The *reduction overhead* is a formula showing how the input counts determine the output counts. For example, $|V|$ people may produce $O(|V|)$ or $O(|V|^4)$ QUBO variables.

These details decide whether a reduction is useful, not merely correct. Our library has two valid paths from Maximum Cut to QUBO. One uses $O(|V|)$ variables, while the other uses $O(|V|^4)$. At 150 people, that is the difference between a practical input and an unusable one. Tracking overhead lets the library choose the practical path automatically. Composing primitive rules lets each new rule connect many existing problems to new solvers. We will present this example before the terminology and move the composition equation to the appendix.

> *The paper also fails to clearly distinguish what is novel from what is standard practice. The six-stage pipeline looks like a standard build-test-merge workflow with LLM wrappers.*

Answer: [TODO]

> *How do you verify that a generated reduction rule is correct? What fraction of reductions required human correction of logical errors?*

Answer:  [TODO]

> *Can you walk through one non-trivial reduction end-to-end, showing what the agent produced versus what required human intervention?*

Answer: [TODO end-to-end walkthrough. The vacuous-budget MinimumVertexCover-to-EnsembleComputation reduction (human-corrected to unit weights with the tight relation J=K+|E|) is a candidate.]

> *How do you handle cases where composed overhead makes a reduction path practically useless?*

Answer: When routing a problem to a solver (for example, MIS to QUBO), we compare candidate paths by composed size overhead, not only by reachability. Each edge records how source sizes map to target sizes (for example, graph order n to QUBO variable count). We compose these maps along each path and drop any path that another dominates on every size measure (variables, constraints, and so on) and is strictly smaller on at least one measure. Given a concrete instance and a size budget, we also check the actual constructed sizes.

One MIS-to-QUBO route maps n vertices to n QUBO variables. Another through Clique and ILP adds auxiliaries and, on a 128-vertex instance, yields 4,192 variables instead of 128. We discard the latter. If every remaining path exceeds the budget, we report that no practical route exists rather than silently returning an unusable encoding. Domain experts seek reductions that stay useful under realistic sizes. We develop and rank paths in the library by that same practical criterion.

> *Which parts of the harness are actually novel versus standard automation with LLM wrappers?*

Answer: [TODO novelty statement.]

> *How many domain experts used the no-code contribution route, and what was their experience?*

Answer: [TODO domain-expert usage.]