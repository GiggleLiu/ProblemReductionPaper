## Reviewer c6QA

We thank the reviewer for their feedback. Following are our responses to each individual comment.

> *My main concern is that the paper feels much more like an engineering report than a research paper. The work does not introduce a new learning method, a new agent architecture, a new optimization algorithm, a theoretical result, or a benchmark.*

Answer: We do not claim a new learning method, agent architecture, etc. Under the official NeurIPS Contribution Types, this is a **Use-inspired** paper.

First, we address a central question for the research community: *what scientific tasks were previously out of reach but become feasible only with AI agents?* We identify large-scale reduction-library construction as one answer. The task has a mechanical side: integrating hundreds of known reductions under one interface. It also requires nontrivial judgments of correctness and usefulness. The resulting graph is itself scientifically valuable because it connects hard problems to solvers. Each rule is concretely falsifiable because one counterexample is enough to reject it. Tasks that combine repetitive scale, nontrivial reasoning, scientific value, and cheap falsification are rare. This combination makes reduction-library construction especially well suited to human–agent collaboration.

Second, our research object is the domain-specific harness that made this build possible (Secs. 2–3). It has three parts: a skill-based automation pipeline, a no-code contribution route for domain experts, and a multilayer verification stack. The decisive verification step is agentic feature testing. A fresh-context agent drives the real CLI, searches for counterexamples, and rejects a rule when it finds one.

We will revise Section 1 and Related Work so this Use-inspired framing and the harness-level contribution are stated up front, rather than left for the reader to infer from the build narrative.

> *The evaluation is also too thin for the claims. [...] I would have liked to see direct evidence: how much maintainer time was saved, how many agent-written PRs failed, how many errors were caught during review, and whether outside domain experts could actually use the no-code contribution route successfully.*

Answer: The four questions can be answered directly from our development record. We will add these numbers to Section 4.


| Question                                | Answer                                                                                                                         |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| Maintainer time saved                   | ~30× rule throughput vs. the Julia prototype                                                                                   |
| Agent-written PRs failed                | Feasibility was screened before implementation; of 356 Final Review attempts, only 1 was rejected and not merged |
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

**4. Maintainer effort and throughput.** At Final Review, maintainers acted on the agent’s report instead of reviewing line-by-line diffs. Because we moved the strict feasibility gate before implementation, nearly every issue that entered implementation was ultimately implemented. Of 356 logical Final Review attempts, 41 merged directly, 296 were corrected in one round and then merged, 18 were reworked and then merged, and only 1 was rejected and not merged.

Our harness greatly reduced the maintainers’ implementation and maintenance burden. Against the Julia prototype, rule throughput rose about 30×.


|                       | Julia prototype | This library (v0.5.0) |
| --------------------- | --------------- | --------------------- |
| Main build window     | ~6 months       | ~3 months             |
| Problem types / rules | 17 / 17         | 190 / 265             |
| Source size           | ~4.3k lines     | 170k+ lines           |


By week 8.5, the library had 23 problem types and 52 rules. After the full pipeline was in place, it grew to 190 types and 265 rules in under five weeks.

> *The harness itself is also not evaluated carefully enough. [...] there is no ablation showing which parts mattered.*

Answer: The stage-by-stage contribution of the full pipeline is quantified in our previous response. Here we focus on agentic feature testing. For reduction-algorithm bugs, acceptance is decided by an exact check: let $I$ be a source instance, $I'=f(I)$ the reduced target, $s'$ a target solution, and $s=g(s')$ the mapped-back source solution. A report counts as a defect only if an exact check finds that $s$ is not valid for $I$, or that its objective disagrees with that of $s'$ under the claimed correspondence. Otherwise it is discarded, regardless of how confidently the sub-agent stated it. A reduction rule is concretely falsifiable because one counterexample is enough to reject it. Agentic feature testing exploits this property by actively searching for counterexamples. During development, it caught 16 defects among 70 non-ILP rules that had already passed compilation, unit, and round-trip tests.

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

Answer: The single-class experiment was intended as an illustrative downstream case study, not a comprehensive utility benchmark. We agree that Section 4.2 did not make this scope clear. Our claim is that the library provides reusable, tested reduction paths, not that a short skill alone completes downstream problem solving. 

To show that the observed behavior is not specific to Maximum Cut, we repeated the same comparison on three additional problems (maximum-likelihood ranking, two-color PaintShop, and bounded closest vector). Each problem used ten random instances, a fresh agent and working directory, one 90-second solver call, and an independent check against the original problem.


| Source problem             | Bare AI | Web only | `pred` | `pred` + web |
| -------------------------- | ------- | -------- | ------ | ------------ |
| Maximum-likelihood ranking | 2/10    | 1/10     | 1/10   | 2/10         |
| Two-color PaintShop        | 0/10    | 1/10     | 2/10   | 5/10         |
| Bounded closest vector     | 4/10    | 2/10     | 6/10   | 6/10         |
| **Total**                  | 6/30    | 4/30     | 9/30   | 13/30        |


The table should be read as a case study of downstream use, not as a utility proof. `pred` helps only when it gives the agent a better way to solve the problem within the 90-second budget. For the first problem, both bare and `pred`-guided agents use essentially the same Boolean ILP, so `pred` does not remove the bottleneck. For PaintShop and closest vector, `pred` exposes QUBO formulations that QUBO-native samplers can use to return answers quickly. Together with the Maximum Cut example in the paper, these cases show that reduction-graph access alone is not enough. In practice, solving a problem requires considering not only reduction overhead but also the capabilities of the available solver. This is a more complex problem. We will broaden Section 4.2 with this multiclass illustration and state this scope explicitly.

> *W2: Dependency on specific LLM capabilities. It is unclear how sensitive the harness engineering framework is to the underlying model's capabilities, or how often human maintainers had to intervene during the "headless" implementation phases.*

Answer: This work evaluates a production harness using the strongest and the most suitable models available to us, not sensitivity to model choice. In practical software production, reliability is the goal, so there is little reason to replace them with weaker models. Comparing model capabilities is a separate research question outside our scope.

For intervention frequency, please see our response to Reviewer c6QA’s second question. Before implementation, an agent checks and repairs each issue; proposals that still fail the quality gate do not enter the implementation pipeline. Implementation therefore required almost no human intervention. At Final Review, maintainers acted on agent reports rather than reading line-by-line diffs: of 356 attempts, 41 merged directly, 296 were corrected in one round and merged, 18 were reworked and merged, and only 1 was rejected. The more important human work was designing this architecture, whose quality gate and multilayer verification stack filter out most errors before merge. We will state the evaluated models and this scope more clearly.

> *W3: Overhead of the reductions. [...] the paper does not extensively evaluate the practical performance degradation caused by composing multiple reductions (e.g., the constant factors involved in a 3-hop reduction to QUBO).*

Answer: Encoding time stays in milliseconds when the composed path preserves target size. The main practical degradation is target-size blowup from auxiliary variables. Details and timings are in Q2 below.

> *Q1: In the agentic feature tests, how often did the sub-agents hallucinate bugs that did not actually exist, and how was this noise filtered by the main agent?*

Answer: We do not need a separate hallucination count. For reduction-algorithm bugs, acceptance is decided by an exact check: let $I$ be a source instance, $I'=f(I)$ the reduced target, $s'$ a target solution, and $s=g(s')$ the mapped-back source solution. A report counts as a defect only if an exact check finds that $s$ is not valid for $I$, or that its objective disagrees with that of $s'$ under the claimed correspondence. Otherwise it is discarded, regardless of how confidently the sub-agent stated it. The reported 0.97 defects per audited PR and 63.4% finding rate include only such confirmed findings. We will clarify this filtering protocol in Section 3.

> *Q2: What is the practical runtime overhead of composing multiple reductions (e.g., 3 hops to QUBO) compared to a hand-crafted, direct reduction for a specific problem?*

Answer: We added a controlled MIS-to-QUBO benchmark on an Apple M3. We compare a hand-crafted direct encoder with two library paths. The recommended route is `MIS → SetPacking<i32> → SetPacking<f64> → QUBO`. The discarded route is `MIS → Clique → ILP → QUBO`. On a dense 128-vertex instance:


|                      | Direct encoding | Recommended path | Discarded path |
| -------------------- | --------------- | ---------------- | -------------- |
| Encoding time        | 0.013 ms        | 9.09 ms          | 174 ms         |
| QUBO variables       | 128             | 128              | 4,192          |
| Dense matrix storage | 0.125 MiB       | 0.125 MiB        | 134.1 MiB      |


The recommended path matches the direct encoder entry by entry (128 variables, 0.125 MiB). Composition adds about 9 ms of one-time preprocessing, noticeable as a relative factor and negligible next to any nontrivial solve. The discarded path is the practical failure mode. It takes 174 ms to encode and yields a 4,192-variable / 134 MiB QUBO. On a sparse 512-vertex graph, the recommended-path comparison is similar (0.043 ms vs 14.7 ms; identical QUBOs). We will report both construction time and final target size in the revision.

> *Q3: How frequently did the automated implementation agent fail to produce a compiling or correct reduction, requiring the issue to be moved to the "On Hold" column for human intervention?*

Answer: With current frontier coding agents, implementation itself rarely fails in the sense the reviewer means. The agent keeps iterating until it produces a PR that passes the available tests; otherwise it does not stop. The hard question is therefore not whether the agent can ship compiling code, but how we verify that the reduction is correct. That verification stack, and the pre-implementation quality gate that keeps weak proposals out of this phase, is detailed in our response to Reviewer c6QA’s second and third questions. Of 356 Final Review attempts, 41 merged directly, 296 were corrected in one round and merged, 18 were reworked and merged, and only 1 was rejected. We will add this stage-by-stage accounting to Section 4.

---

## Reviewer WsAZ

Rebuttal:
We thank the reviewer for their feedback. Following are our responses to each individual comment.

> *[...] the paper never reports what fraction of reductions required human correction of logical errors, or how often the verification stack misses a semantically incorrect reduction. Without that data, we cannot assess how tight the human bottleneck is.*

Answer: Please see our responses to Reviewer c6QA’s second and third questions for the stage-by-stage record and how verification works. In brief, human work was concentrated before implementation and at final authorization: of 167 proposals that entered repair, agents repaired 128 and humans stopped 39; of 356 Final Review attempts, only 1 was rejected. During development, agentic feature testing caught 16 defects among 70 non-ILP rules that had already passed compilation, unit, and round-trip tests; these were fixed before merge. The detailed data and analysis are in those two responses.

> *Section 1.2 is dense. The paper introduces "primitive reduction rules," "size features," "reduction overhead" without walking you through a single end-to-end example in the main text. Clarity suffers from oscillation between mathematical formalism in Section 1 and engineering description in Section 2.*

Answer: We agree and will replace the abstract notation in Section 1.2 with one example. Our 150-person team-split problem is Maximum Cut. To solve it on an Ising machine, the library follows Maximum Cut $\to$ SpinGlass $\to$ QUBO, then maps the machine's answer back to a team assignment.

Each arrow is one translation step, which we call a *primitive reduction rule*. It converts an instance into the next form and knows how to translate the resulting solution back. To track the cost of this translation, the library records the counts that determine an instance's size. For Maximum Cut, those counts are the numbers of people and scored pairs. For QUBO, the count is the number of binary variables. We call these counts *size measures*. The *reduction overhead* is a formula showing how the input counts determine the output counts. For example, $|V|$ people may produce $O(|V|)$ or $O(|V|^4)$ QUBO variables.

These details decide whether a reduction is useful, not merely correct. Our library has two valid paths from Maximum Cut to QUBO. One uses $O(|V|)$ variables, while the other uses $O(|V|^4)$. At 150 people, that is the difference between a practical input and an unusable one. Tracking overhead lets the library choose the practical path automatically. Composing primitive rules lets each new rule connect many existing problems to new solvers. We will present this example before the terminology and move the composition equation to the appendix.

> *The paper also fails to clearly distinguish what is novel from what is standard practice. The six-stage pipeline looks like a standard build-test-merge workflow with LLM wrappers.*

Answer: Please see our response to Reviewer c6QA’s third question. The decisive part is agentic feature testing. A fresh-context agent drives the real CLI to check the user interface and, especially, to adversarially search for counterexamples. This scientific task is special in that each rule implementation is easy to falsify: one counterexample is enough to reject it. That falsifiability is what makes AI-assisted software development reliable here, and most tasks lack it. 

> *How do you verify that a generated reduction rule is correct? What fraction of reductions required human correction of logical errors?*

Answer: For reduction-algorithm bugs, acceptance is decided by an exact check: let $I$ be a source instance, $I'=f(I)$ the reduced target, $s'$ a target solution, and $s=g(s')$ the mapped-back source solution. A report counts as a defect only if an exact check finds that $s$ is not valid for $I$, or that its objective disagrees with that of $s'$ under the claimed correspondence. Otherwise it is discarded, regardless of how confidently the sub-agent stated it. The reported 0.97 defects per audited PR and 63.4% finding rate include only such confirmed findings. Details are in our response to Reviewer c6QA’s third question. We will clarify this protocol in Section 3.

> *Can you walk through one non-trivial reduction end-to-end, showing what the agent produced versus what required human intervention?*

Answer: We agree and will add the Minimum Vertex Cover $\rightarrow$ Ensemble Computation rule as a staged end-to-end case study:

+ Task specification. A contributor proposed the reduction and supplied its mathematical source. The task was converted into a structured issue defining the source problem, target problem, expected construction, and required examples.

+ Agent implementation. The agent implemented the target-instance construction and solution mapping, and added documentation, examples, and tests. The resulting code compiled and passed its initial software checks.

+ Verification failure. The agentic feature testing found that although the code compiled and passed its initial tests, the generated target did not preserve the source problem. The chosen budget made every target instance feasible, regardless of the correct source answer. The construction also discarded vertex weights. It therefore implemented the form of the reduction without preserving its mathematical meaning.

+ Human intervention. The reviewing agent confirmed the semantic mismatch and proposed three options: (A) remove the rule from the batch until redesigned; (B) keep Ensemble Computation as a feasibility problem and add a decision variant of Minimum Vertex Cover with an explicit budget $K$, setting $J=K+|E|$ as in Garey and Johnson; (C, recommended) reframe Ensemble Computation as an optimization problem, restrict the source to unit-weight Minimum Vertex Cover, and establish the tight optimal-value relationship $J^*=K^*+|E|$. A human reviewer authorized the agent's recommended option (C). 

+ Agent repair. The agent revised the problem model, reduction rule, solution mapping, documentation, and tests according to the chosen option.

+ Final review. The corrected rule was checked on worked instances and exact small-instance tests. The human reviewer authorized the corrected rule and merged the PR.

This case shows the division of labor during development. The agent wrote the code, found the bug, proposed the fix options, and applied the repair. The human chose among those options and authorized the merge. Once the architecture is in place, expansion can therefore be fast.

> *How do you handle cases where composed overhead makes a reduction path practically useless?*

Answer: Please see our response to Reviewer yPT8’s Q2 for the controlled MIS-to-QUBO timings. In brief, when routing a problem to a solver we compare candidate paths by composed size overhead, not only by reachability. On a 128-vertex instance, one MIS-to-QUBO route yields 128 QUBO variables; another through Clique and ILP yields 4,192. We discard the latter. If every remaining path exceeds the size budget, we report that no practical route exists rather than silently returning an unusable encoding. We will report both construction time and final target size in the revision.

> *Which parts of the harness are actually novel versus standard automation with LLM wrappers?*

Answer: Please see our response to Reviewer c6QA’s third question. The decisive part is agentic feature testing. A fresh-context agent drives the real CLI to check the user interface and, especially, to adversarially search for counterexamples. This scientific task is special in that each rule implementation is easy to falsify: one counterexample is enough to reject it. That falsifiability is what makes AI-assisted software development reliable here, and most tasks lack it. 

> *How many domain experts used the no-code contribution route, and what was their experience?*

Answer: Six domain experts used the no-code route and contributed about 245 of the 265 rules in v0.5.0. They supplied definitions, algorithms sketches, and worked examples through structured issues; agents handled the Rust implementation, tests, and documentation. Of 381 proposals, 214 passed the quality gate immediately; of the other 167, agents repaired 128 and stopped 39 for human decisions before implementation. We will report these adoption and stage outcomes in Section 4.