# Round 013 — subset-product cycle and full 3-SAT composition

## Plan

Action: continue from the synchronized selector in Round 012. Hypothesis:
calibrate s_i t_i=1, then use weighted product-vector sums to enforce a cyclic
multiplicative equation whose factor is r_i or 1 according to selector i.
Scope: derive the cycle equivalence for positive integers r_i and target T;
compose a direct prime-exponent encoding of 3-SAT; implement construction and
all-witness direction recovery. Initial tests: existing six SAT fixtures and
finite subset-product cases with known selected subsets and NO products.
No change to endpoints: arbitrary-sign real factors, widths at most the budgets.
Completion: executable candidate, full proof and explicit bit bounds, or a
counterexample to this fixed cycle mechanism. Reuse the local pending selector
finding; Round 011 prevents treating unsynchronized bases as palettes.

## Evidence and diagnosis (review in progress)

The calibrated selector admits cycle ratios r_i h_i or h_i, selected by its
orientation. The final coefficients (1,T²,T,T) impose T h_0. Cancellation of
nonzero ratios yields the exact subset-product equation. A standard prime
encoding composes 3-SAT with this construction. The current candidate, its
all-real soundness proof and recovery are in `work/`.

Prepared checks: six injected source instances and eight recovery calls;
[final log](repaired-candidate-check.txt). Independent implementation: 29 source
instances, 105 recovery calls, five irrational gauges; [log](independent-check.txt).
The structural target oracle also passed 32 standalone subset-product cases
against exhaustive enumeration, with 16 YES and 16 NO; [log](structural-oracle-check.txt).
Both NO oracles use the candidate structural theorem, a dependency explicitly
recorded for independent proof review.

Preparation repairs made the occurring-variable convention and dense algebraic
encoding explicit, validated target shape before either oracle, and removed
Python's integer-conversion cutoff. Superseded cited code and logs are retained
here. These repair the executable encoding contract; they do not change the
source problem or the matrix construction. The first candidate run and the
post-repair run each passed six cases and eight recovery calls; these are reruns,
not twelve distinct source cases. Oracle self-tests and their logs are separate
from injected-instance counts.

A native independent reviewer is assessing correctness, novelty and significance.
Its current concern is the executable algebraic representation and runtime
contract; no final verdict has been issued. No code changes are made during review.

Supporting arithmetic source checked on 2026-09-15: Emiris, Mourrain and
Tsigaridas, *Real Algebraic Numbers: Complexity Analysis and Experimentation*,
Theorem 5.1, Remark 5.2 and Section 6,
https://who.paris.inria.fr/Elias.Tsigaridas/files/emt-lncs-2006.pdf.
The unrestricted degree/height qualification in Remark 5.2 matters.
The current 2607.04875 record is v2 (9 July 2026), *On the Complexity of Low-Rank
Matrix Signing and Entrywise Power Matrix Factorization*; its introduction
still distinguishes independent Hadamard factors from the entrywise power model.
https://arxiv.org/html/2607.04875v2. Final novelty assessment belongs to review.


### Independent review and executable repair

[Native review](../../reviews/native/review.md) returned revise for two precise
interface/runtime gaps. It found no error in the unrestricted-real selector and
cycle proof, and supported novelty and significance within its documented search.
Its two cubic-gauge checks and local UNSAT/symbolic checks are separate evidence.

R1/R2 repair: replace the candidate's per-coordinate Z3 decoder with the fixed
common-primitive representation. Compute each determinant as a rational
univariate polynomial; detect zero at the isolated root using a subresultant gcd
and the sign-corrected `sturm_amv` sequence in installed SymPy 1.14.0. No solver
or field compositum runs in the candidate. The actual arithmetic procedure now
has explicit degree, coefficient-height and bit-operation bounds. The matrix
construction and all-real converse are unchanged. This is an executable contract
repair within the declared round, not another discovery mechanism.

All affected cited files are retained in [before-review-repair](before-review-repair/).
The prepared checker serializes its native solver values into the public
interface; independent verification constructs that interface directly.
Post-repair [prepared checks](common-primitive-prepared-check.txt) pass six source
cases and eight recovery calls. [Independent checks](common-primitive-check.txt)
pass the same 29 distinct source formulas, now with 109 recovery calls and nine
algebraic gauges, including negative roots, cubic roots and reducible polynomials.
Four focused calls reuse a prior source. The [arithmetic check](arithmetic-check.txt)
compares root counts on additional polynomial families. Current self-test:
[log](common-primitive-self-test.txt). Reruns are not new source instances or rounds.

For implementation grounding, inspected SymPy 1.14.0's `sturm_amv` and its
subresultant coefficient invariant, and Akritas, *Anna Johnson and Her Seminal
Theorem of 1917*, Section 2.4.3 / Theorem 5,
https://faculty.e-ce.uth.gr/akritas/publications/100.pdf (2026-09-15).
A one-line inspection initially imported `dup_sturm` from the wrong SymPy module;
the corrected read-only inspection used `sympy.polys.rootisolation`. This was a
tool-location error, not a mathematical experiment or candidate failure.

The [common-primitive review](../../reviews/common-primitive/review.md) accepted
R1/R2 in substance and found one additional grammar defect: Fraction accepts
compressed scientific exponents, invalidating the serialized-length premise.
R3 repair shares one literal rational parser between coordinate coefficients
and interval endpoints. It checks the numerator/denominator grammar before
numeric conversion. Reviewed files are retained in
[before-literal-rational-repair](before-literal-rational-repair/).
The reviewer also passed four stronger full-witness cases with a degree-12,
negative-leading, nonsquare-free defining polynomial, two isolated roots,
nonconstant row gauges and degree-13 coordinate perturbations. These count as
reviewer checks, not new source formulas or new research rounds.

**Experience extraction:** two campaign-local proposals, pending shared writes.
Extend Round 012's `hadamard-product-basis-selectors.md` with the calibrated
multiplicative cycle theorem, its positive-integer item premise, K≥3 anchors,
full right-basis independence, and all-real soundness/completeness. It uses the
residual scalar freedom to encode subset product; a common Cartesian basis
must not be assumed from an identity block alone. Support: current proof
Sections 2–6, Round 011's counterexample, Round 012's selector checks, and native
review's structural audit. This extends an existing pending proposal rather
than creating a second selector entry.

Propose `common-primitive-witness-zero-tests.md`: for one dense integer defining
polynomial with a root-isolating rational interval and dense rational coordinate
polynomials, a determinant vanishes at the selected root exactly when its gcd
with the defining polynomial has a root in that interval. Subresultants and
sign-corrected Sturm sequences implement this in polynomial bit time, including
reducible/nonsquare-free defining polynomials. Literal rational grammar is a
premise: compressed exponents defeat the serialized-length bound. This is a
standard arithmetic technique applied to the witness contract, not a new
mathematical discovery. Support: proof Section 7, common-primitive review's
four full-witness tests and compressed-exponent counterfamily, and the cited
arithmetic sources. No applicable shared entry was found by searching primitive,
algebraic, subresultant, encoding and witness terms on 2026-09-15.

Both destinations are under `research/experience/`; campaign-only writes prevent
shared extraction here. Total distinct pending files across the campaign: six.
No shared entries were created or updated. Time/token totals unavailable.

## Closure

Decision: advance; round 013 completed on 2026-09-15. The final
[literal-rational review](../../reviews/literal-rational/review.md) closes R3
and retains closure of R1/R2. The current candidate passes the prepared suite
(6 sources, 8 recoveries) and independent suite (29 distinct sources,
109 recoveries, including 9 algebraic cases). Raw current outputs are
[literal-rational-prepared-check.txt](literal-rational-prepared-check.txt) and
[literal-rational-check.txt](literal-rational-check.txt). Finite checks and agent
review remain distinct from the general proof and human verification.

The English [manuscript](../../work/manuscript.pdf) is authored directly in
[Typst](../../work/manuscript.typ), with the technical-writing skill applied.
The two vector figures show actual matrix supports and the symbolic cycle-row
submatrix. Their design was informed by Figures 1 and 3 of Ciaperoni et al.,
https://link.springer.com/article/10.1007/s10618-024-01033-y, inspected on
2026-09-15. Reference images are under [reference-figures](reference-figures/).
The actual illustrative factorization is generated by
[build.py](../../work/figures/build.py); all 832 entry products and both ranks
were checked exactly ([figure-data-check.txt](figure-data-check.txt)). This
illustration is not an additional research round or a new independent source case.
Cycle entries were compared with the construction and the four recurrence
identities. Support cells encode zero/nonzero only, as stated in the caption.

Compilation passed with Typst 0.15.1; diagnostics are in
[typst-redesign-compile.txt](typst-redesign-compile.txt). All nine rendered pages
were visually inspected; the last adjustment kept the recurrence with its setup,
and the affected pages 4 and 5 were inspected again. No clipped diagrams or
unreadable mathematical labels were found. Earlier figures and manuscript remain
in [before-figure-redesign](before-figure-redesign/). Editorial changes did not
alter the reviewed algorithm or mathematical claims, so passing algorithm checks
were reused.

Campaign total: 13 completed rounds out of 40 authorized; 27 unstarted.
Stop exploration because a complete candidate passed review and writing, rather
than manufacturing further attempts. Next action is independent human expert
review. Six distinct experience proposals remain campaign-local pending shared
extraction; new shared entries 0, updated 0. Time/token totals unavailable.
