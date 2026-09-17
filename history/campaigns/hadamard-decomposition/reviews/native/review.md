# Independent review: synchronized Hadamard selectors

Date: 2026-09-15. Decision: **revise**.

The mathematical forward reduction and unrestricted-real converse survive this review. The fixed campaign's complete executable rule does not yet meet its witness-interface and polynomial-time recovery obligations. These are focused, repairable issues; they do not require a new mathematical construction or a weakened question. Novelty is supported within the primary-literature coverage below, and the claimed NP-hardness would be significant. This is not publication acceptance or independent human verification.

## Scope and independence

I read README.md, AGENTS.md, research-review/SKILL.md, the fixed question, and current work/algorithm.py, contract.md, proof.md, preparation.md, verification.md, check.py, verify.py and product_basis_oracle.py. I inspected the existing finite evidence through their reports. The candidate remained unchanged during review. All reviewer artifacts are in this directory. No candidate implementation was imported, and no further agents were used.

The two existing target NO oracles both invoke the structural characterization, notwithstanding their independently implemented discrete solvers. I therefore assessed Sections 3–6 directly. Agreement between those oracles is not evidence for that characterization. The reviewer checks in [targeted_checks.py](targeted_checks.py), with output in [targeted_checks.txt](targeted_checks.txt), test local proof premises and cubic witness recovery; they do not rerun the existing suites.

## Correctness: mathematical construction

**Forward encoding.** The canonical source convention is legitimate: rename the occurring variables, and take n=0 for the empty conjunction. This is polynomially equivalent to conventional 3-SAT, including repeated literals. It avoids requiring an exponentially long assignment for a short declaration of unused variables. In algorithm.py:21–33, the variable prime forces exactly one of the two assignment items; each clause prime has assignment exponent c in {0,1,2,3}, and slack exponents {0,1,2,3} reach four precisely when c>0. Padding by ones to K≥3 is essential and implemented. The empty source produces a legal YES instance.

**Saturation.** The identity submatrix gives N independent row tensors in an ambient space of dimension exactly N=2(2K), and the column tensors are their duals. Every later row tensor is consequently its prescribed linear combination, rather than merely having a projection equal to that combination. At-most factor widths do not permit unused dimensions or lower-dimensional escape: the identity already forces saturation. This argument is valid over the reals without sign or genericity hypotheses.

**Selectors.** The pair-sum lemma follows by a two-dimensional contraction when neither factor pair is proportional. For a pairwise-sum clique of independent tensors, fixing any pair forces every third member onto its common factor line. A K≥3 clique cannot share a right line, since its span would have dimension at most two. If the two clique left lines coincided, every common neighbor would lie on that line and the entire basis would have span at most 2K. If b_i and c_i were proportional, the four vectors of that selector would have span at most two. Both contradictions use actual basis independence, not an assumption about intended factors.

With the two left lines and the local right lines distinct, a common neighbor must occupy an off-diagonal corner; independence requires opposite corners for X_i and Y_i. All 2K right vectors are globally independent because otherwise the whole tensor basis would have dimension less than 4K. This last inference justifies cycle composition across blocks. Calibration yields st=1, so its parameters cannot be zero.

**Cycle and completeness.** Independent right supports reduce decomposability of a two-block row to equality of its left-line ratios. Direct symbolic calculation confirms all three coefficient patterns in both selector orientations. Their ratios yield the claimed recurrence and nonzero cancellation around the cycle. Negative parameters cause no exception. Conversely, a satisfying subset produces scaled, permuted coordinate tensors and a product-vector dual basis; every additional row has rank one. This supplies full factors, including the prescribed zero entries. No implication from arbitrary rank-one bases to product dual bases is needed in completeness because the constructed basis is explicitly of this special form.

**Recovery as a mathematical map.** Every valid real target witness has nonzero anchor rows. The determinant of the U1 rows at L_0 and X_i vanishes exactly in the selected orientation. Independent row gauges cannot change that zero predicate. Reading only the first 2n selectors is sufficient, and prime uniqueness then gives a satisfying assignment. The proof does not restrict recovery to rational or constructed witnesses.

**Size.** K=O(n+m+1), the row count K²+9K and column count 4K match the code, and both widths lie in the required range. Prime sizes, total literal occurrences, multiplication and dense serialization have polynomial bit cost. The stated forward/output upper bounds are conservative. No unary expansion of item magnitudes is used. I found no forward-map or general YES/NO error.

## Required repairs

### R1. The actual recovery runtime is not established

Location: algorithm.py:56–77 and proof.md:166–199.

The proof gives a plausible polynomial implementation of four-number determinant comparison through certified isolation and a norm separation bound. I checked the norm argument: multiplying by the four leading coefficients produces an algebraic integer of degree at most B⁴; the conjugate bound implies the stated nonzero separation. Propagating intervals to smaller width distinguishes zero correctly. The primary root-isolation paper supports polynomial Sturm operations.

However, that implementation is not the executable. algorithm.py parses root objects and invokes Z3 algebraic simplification. proof.md:196–199 expressly says that no library-internal runtime guarantee is inferred and that its bit bound describes a standard realization of the comparisons. Existence of a polynomial realization does not bound an arbitrary implementation of the same function. This is a missing complexity premise, not a demonstrated superpolynomial lower bound or a failed finite test.

Required correction: make the actual recovery execute a specified deterministic polynomial arithmetic procedure, or provide an implementation-level bound for the operations it actually calls. For a direct common-primitive representation, polynomial arithmetic, gcd and certified root counting can avoid constructing unrelated algebraic fields. Whichever implementation is selected needs explicit degree, coefficient and intermediate-size bounds. Passing more Z3 examples alone does not close R1.

### R2. The fixed algebraic witness representation remains unhandled

Location: question.md, target-witness paragraph; work/contract.md, target-witness paragraph; algorithm.py:56–77; proof.md:166–204.

The fixed question specifies a common primitive element, an isolating interval and rational coordinate polynomials. The current executable only consumes each scalar as a rational expression or its own dense polynomial plus real-root index. It does not read a common primitive element or coordinate polynomials, and the proof only bounds the latter per-coordinate representation. contract.md itself labels this as the injected-test representation and leaves the question's representation obligations to the completed rule.

These encodings describe the same mathematical numbers but are not the same finite input interface. Their polynomial relation in the needed direction has not been implemented or proved here. This finding is based on the explicit accepted grammar, not on inventing an unspecified JSON envelope and reporting its rejection.

Required correction: specify and implement the fixed common-primitive interface directly, or give and implement a polynomial conversion from it, charging all degrees and rational coefficient bits to input length. Preserve recovery for every valid encoded witness, including reducible primitive polynomials with an isolating interval selecting the relevant factor if such polynomials are allowed. Add targeted checks with genuinely nonconstant coordinate polynomials, multiple possible real roots and gauges; keep the unrestricted-real proof unchanged.

## Reviewer evidence

Command:

```
python3 campaigns/hadamard-decomposition/reviews/native/targeted_checks.py
```

The checks passed:

- A QF_NRA escape query allows a completely arbitrary real 2-by-3 common neighbor of normalized anchors, imposes rank-one neighbor sums, and asks for any nonzero vector outside the two off-diagonal corners. It is UNSAT. This tests the local lemma with an extra right coordinate; the global all-dimension proof is the argument above.
- Exact symbolic calibration determinant and six cycle-ratio identities.
- Two actual candidate targets for opposite single-variable truth orientations, independently assembled rational witnesses, every target entry checked, and fresh-process recovery after a cube-root-of-two shear. The shear and its inverse are verified symbolically. Both assignments are recovered correctly.

These extend quadratic gauge coverage but establish neither all-witness runtime nor the missing common-primitive interface.

## Novelty

Judgment: **supported within the following search coverage**, with no matching theorem located. Search date: 2026-09-15. Searches included “Hadamard decomposition NP-hard”, “Hadamard factorization NP-hard”, “Hadamard decomposition complexity matrix”, “Hadamard decomposition subset product”, and “product basis NP-hard matrix”. Only primary papers support the judgments below.

| Primary source and inspected location | Relation to this candidate |
| --- | --- |
| [Ciaperoni–Gionis–Mannila, 2024](https://link.springer.com/article/10.1007/s10618-024-01033-y), Equation (4), Sections 4.3 and 9 | Same width-based real model; exact feasibility is placed in ETR, and formal complexity is left open. This is the direct baseline. |
| [Wertz–Vandaele–Gillis, 2025, v2](https://arxiv.org/html/2504.13633v2), Section II, conclusion, Appendix B Lemma 2 | Alternating optimization and an explicit identity factorization. The identity construction/rank-product phenomenon is prior art; it does not characterize the selector rows or encode subset product. |
| [Gillis–Saha–Sicilia–Vandaele, 2026](https://arxiv.org/html/2605.28980v1), Section 2, Lemmas 2.3 and 2.4; Section 3 | Rowwise rank-one/face-splitting formulation and the tensor rank-product identity are explicitly known. These support, rather than constitute, the candidate's new selector and cycle. The methods optimize approximate decompositions. |
| [Low-Rank Matrix Signing and Entrywise Power Matrix Factorization, July 2026, v2](https://arxiv.org/html/2607.04875v2), Sections 1.1–1.2, Theorems 2.2 and 3.2 | Exact signing/power hardness concerns one matrix with prescribed magnitudes; fixed-rank signing is tractable. Two independent Hadamard factors have extra magnitude freedom. Hardness of the constrained model does not automatically imply this candidate's target hardness. |
| [Oneto–Vannieuwenhoven, v2](https://arxiv.org/html/2308.06597v2), Theorem 4.5, Proposition 4.6 and conclusion | Generic tensor identifiability under identifiable induced CP decompositions. No all-input matrix-feasibility implication supplies this reduction. |
| [Hadamard ranks of algebraic varieties](https://arxiv.org/html/2510.05231v1), Theorem 4.3, Corollary 4.5 | Dimension bounds for products of secant varieties/mixture models. Generic dimensions do not decide this specially constrained rational matrix family. |
| [Emiris–Mourrain–Tsigaridas](https://who.paris.inria.fr/Elias.Tsigaridas/files/emt-lncs-2006.pdf), Theorem 5.1, Remark 5.2, Section 6 | Supports polynomial real-root isolation and algebraic comparisons, including nonsquare-free inputs; does not certify the candidate's Z3 implementation. Downloaded PDF/text are retained here for citation checking. |

Unresolved coverage: unindexed manuscripts, exhaustive citation closure, all quantum product-basis/Segre-recognition formulations, and hidden consequences of more general representation-hardness theorems. I inspected the cited theorem statements and the closest construction sections, not every proof of every cited paper. No claim of absolute novelty is justified. In particular, the manuscript should credit the 2025 identity construction and 2026 face-splitting characterization while localizing originality to synchronization, calibration and the multiplicative cycle.

## Significance and next review

Judgment: **passes the fixed significance target, conditional on completing the rule and sustaining novelty**. Hardness for nonnegative integer inputs with one factor width fixed at two is a concrete boundary for the unrestricted-sign, exact real model. The second width grows with the source; the result does not assert both widths fixed, strong NP-hardness, approximation hardness, NP membership of the unrestricted problem or ETR-completeness.

A follow-up review should concentrate on R1/R2, new witness tests and changed proof bounds. The unchanged selector/cycle argument and the successful evidence above can be reused. Advance is withheld until the executable rule meets the fixed encoding and runtime obligations.
