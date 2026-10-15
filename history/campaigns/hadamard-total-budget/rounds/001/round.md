# Round 001: balanced saturation with a partially specified Cartesian frame

## Plan

Action: reconsider allocation forcing. The previous identity of order 4K does
not saturate arbitrary budget-2K+2 factors. Instead use s=2K, N=s^2 identity
columns and total budget 2s. The rank-product inequality and AM-GM force exactly
p=q=s. This changes the matrix construction, not the question.

Hypothesis: a partially specified s-by-s Cartesian product frame can preserve K
two-choice selectors in its first two tensor rows while enforcing all anchor
row/column directions. Omitted cells are the two off-diagonal positions in each
2-by-2 selector. All other cells are anchors. Pair-sum cliques run along every
anchor row and column; the missing cells connect only to their local L/R anchors.
Calibration and the old multiplicative cycle then encode subset product.

Scope: prove orientation of the entire anchor frame, recover the old local
selector argument, construct rational witnesses for all eight selections of
K=3 items [2,3,5] with the corresponding target, and check one failed product.
Investigate rank-allocation arithmetic for s=6 through 20, as a boundary check.
Completion: a general argument or a concrete obstruction; finite checks alone
cannot close any structural lemma. A complete proof will proceed to actual
source injection, separate verification and native independent review.

Experience retrieval: the shared index has no Hadamard-specific entry. Reuse
prior campaign rounds 002/011 (identity does not force Cartesian coordinates),
012 (synchronized selectors) and 013 (product cycle and literal algebraic codec)
in place. The frame must be proved from its pair rows, never assumed from I_N.
This test is more discriminating than running a large unconstrained quartic
query on an old NO matrix, so that proposed query has not been executed.

## Evidence and diagnosis

The candidate argument is in [proof.md](../../work/proof.md). Its new step is
orientation of the anchor cliques: a full row and a column would put 2s-2>s
independent identity vectors on one factor line if their common sides agreed.
Top rows give K+s-2>s. The remaining local neighbors and dimension saturation
then force both global bases, preserving the calibrated selector-cycle proof.
This is a general candidate lemma, not an inference from the finite tests.

The initial witness emitter mixed literal fraction strings with the checker's
internal SMT rational codec. [probe.txt](probe.txt) and
[prepared-check.txt](prepared-check.txt) retain these failures. The repair only
changes internal oracle serialization to Z3 rational expressions; the candidate
and public encoding were unchanged. The previous emitter is retained as
[frame-oracle-before-scalar-repair.py](frame-oracle-before-scalar-repair.py).
The corrected [probe](probe-repaired.txt) passes 15 allocation boundaries,
eight complete 180-by-36 rational witnesses, and one structural subset-product
NO. The larger checks pass six source injections/eight recoveries and fourteen
separately checked sources/seventy recoveries. These belong to verification of
the same construction, not additional construction hypotheses or research rounds.

Primary-literature follow-up inspected Wertz et al., arXiv:2504.13633v2,
Theorem 1, Appendix A Lemma 1 and Appendix B Lemma 2. Their rank budget and
identity construction are explicitly prior work. Their variable-factor budget
optimization does not enforce this candidate's additional rows or establish its
hardness. Ciaperoni et al. Section 4.3 and Gillis et al. 2605.28980v1 provide
the feasibility and tensor viewpoints. Search queries and remaining coverage
are recorded in the candidate proof's reference section. No novelty conclusion
is based on an empty search alone. Native independent review is pending.

**Experience extraction (proposed, pending review):** one potential entry,
`balanced-hadamard-frame-allocation.md`, for exactly two real factors, identity
order s^2, total budget 2s, s=2K with K>=3, and the precisely specified anchor
pair rows. The entry would combine budget saturation with the incomplete-frame
orientation lemma. Rank-product/AM-GM are standard; the useful construction
lesson is preserving selector freedom while proving the full frame. A bare
identity or an arbitrary number of factors does not satisfy its premises.
No existing shared entry matches these claims. The user-supplied campaign-only
write rule prevents writing `research/experience/`; retain the claim and its
proof/review links here and report shared extraction as pending at closure.

## Closure

Completed on 2026-09-15. Decision: advance to independent human expert review.
The [native review](../../reviews/native/review.md) advances with no requested
repair. It independently audits all allocations, frame orientation, selector
composition, both maps and actual arithmetic bounds. Its two additional full
witness checks use negative prefixes, dense coordinate changes, a localized
fifth root and repeated reducible polynomial with degree-14 representatives;
both factor orders recover the source assignment. Novelty remains supported
within the report's stated coverage, not certified by an absence of search hits.

The [English manuscript](../../work/manuscript.pdf) is authored in native Typst
using research-write and how-to-technical-writing. Two vector figures depict
actual identity-factor supports and the anchor incidence grid. The actual
436-by-64 factorization used for the support crop is checked entrywise in
[figure-check.txt](figure-check.txt). The figure's scope and zero/nonzero encoding
are explicit. Grid anchor and selector indices agree with the construction;
its row/column clique counts are 8,7,1 and 4,7,1 for the displayed K=4.

Typst 0.15.1 compiled all nine pages; see [typst-final-compile.txt](typst-final-compile.txt).
Every rendered page was inspected, with the final render in final-page-1.png
through final-page-9.png. The final language/notation pass removed a duplicated
cross-reference label, separated local coefficients from the budget symbol,
and clarified the inherited selector-cycle provenance. All formulas use native
math. No algorithm or substantive proof change occurred after independent review;
passing checks were reused. Earlier compile errors (operator declaration and a
figure division function name) were editorial tool errors, not research rounds.

**Experience extraction:** the single proposal above is now supported by the
complete general argument and independent advance review, with human assessment
pending. Proposed destination remains `research/experience/balanced-hadamard-frame-allocation.md`.
Exact premises exclude a bare identity with no frame rows and decompositions
with a variable number of factors. This evidence supports a concrete reusable
construction, not a measured claim about the workflow's discovery efficiency.
New shared entries 0; updated 0; pending 1, under the campaign-only write rule.

Total: one construction hypothesis, one oracle serialization repair, 15 finite
allocation boundaries, eight standalone frame witnesses, six prepared source
injections/eight recoveries, fourteen separately checked sources/seventy recoveries,
and two reviewer recoveries. Figure validation is reported separately. No further
round was started: a complete candidate passed the campaign gate, so padding
39 additional attempts would not be meaningful. Next action is human expert
assessment. Time/token totals unavailable.


## Shared extraction completed

On 2026-09-15, the user explicitly authorized writing the pending shared entry.
Saved [balanced-hadamard-frame-allocation.md](../../../../research/experience/balanced-hadamard-frame-allocation.md)
with exact applicability, exclusions, proof and review links, search consequences
and use history. This resolves the earlier pending extraction without changing
the theorem or starting another research round. Current extraction totals:
new shared entries 1; updated 0; pending 0. Human expert review remains pending.
