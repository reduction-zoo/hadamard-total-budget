# Focused independent review: common-primitive recovery

Date: 2026-09-15. Decision: **revise**, for one narrow input-encoding repair.

The common-primitive interface and actual subresultant/Sturm procedure address the substance of R1 and R2 in the [previous review](../native/review.md). The remaining issue is that the rational parser accepts scientific notation with a compressed exponent. That contradicts the coefficient-size premise used to bound the executable by serialized witness length. No new mathematical construction is required.

## Scope and retained findings

I inspected the revised algorithm.py, contract.md, proof.md, preparation.md and verification.md, the reported arithmetic/prepared logs, and the installed SymPy 1.14.0 source of sturm_amv and euclid_amv. I reuse the prior review of unchanged Sections 1–6, forward construction, unrestricted-real recovery, novelty and significance. The prior report remains unchanged. All new reviewer files are in this directory; no candidate implementation was imported and no further agents were used.

## R1 and R2 reassessment

The executable now accepts one dense integer defining polynomial P, an interval isolating one distinct real root theta, and dense rational coordinate polynomials. This directly represents the fixed question's witnesses. P need not be irreducible or square-free. For a determinant polynomial D, D(theta)=0 exactly when gcd(P,D) has a root in the supplied interval. Since every gcd root is a root of P, its count in that interval is zero or one. The last nonzero subresultant supplies the gcd up to scale, including D=0, where the list ends in P. Constant gcds produce zero roots.

The square-free conversion inside root_count removes multiplicity before applying a Sturm sequence. The endpoints are not roots of P and hence cannot be roots of a gcd divisor. Omitting zero entries in the endpoint sign lists is the correct variation convention. Negative leading coefficients and rational scales do not invalidate the count. There is no need to construct a global number field or factor P into irreducibles.

The installed sturm_amv(method=1) calls euclid_amv, whose remainder steps use Collins–Brown–Traub coefficient reduction; sturm_amv applies the Sturm sign pattern to those controlled remainders. This is materially different from merely postulating an alternate polynomial realization. The installed source directly documents and implements this sign-corrected subresultant construction. The candidate additionally cites the [Akritas paper](https://faculty.e-ce.uth.gr/akritas/publications/100.pdf), Section 2.4.3; its opening pages were accessible, but follow-up retrieval of that exact section failed (HTTP 403/timeout), so this review does not independently certify that pinpoint citation. The [Emiris–Mourrain–Tsigaridas paper](https://who.paris.inria.fr/Elias.Tsigaridas/files/emt-lncs-2006.pdf), Theorems 2.1–2.4 and Section 6, provides the underlying polynomial coefficient and algebraic-comparison bounds. These sources were checked on 2026-09-15; the latter was already retained and inspected in the first review.

Under a literal rational encoding whose numeric bit lengths are bounded by its serialized length, the revised degree/height argument supports polynomial runtime for the procedure actually called. All polynomial degrees are O(W); normalized subresultants have polynomial coefficient height, and one polynomial division step on bounded-degree, bounded-height inputs has polynomial intermediate size. The deliberately loose exponent 24 is sufficient as a conservative bound; it is not a measured performance claim. The remaining parser issue below prevents an unconditional executable-length claim as currently written.

## R3. Compressed rational exponents bypass the size premise

Locations: algorithm.py, polynomial's `values=[Fraction(c) for c in coefficients]`; extract's interval conversion `Fraction(v)`; contract.md, rational coefficient/endpoint syntax; proof.md Section 7, “Degrees and rational input heights are bounded by B.”

Python Fraction accepts scientific notation such as `1e4096` and `1e-4096`. The six-character first string creates a numerator with 13,607 binary digits. More generally, `1eN` has O(log N) characters but expands to Theta(N) bits, before any polynomial computation. The interval parser accepts the same notation. Dense polynomial encoding alone does not exclude this numeric compression.

The current contract calls these values “exact rational strings” and excludes symbolic expressions and JSON floating-point values, but does not specify a literal numerator/denominator grammar or reject exponent strings. The executed parser accepts the strings exactly. If they are intended to be outside the legal encoding, that boundary must be explicit and checked before Fraction expands them. Merely charging the *expanded* coefficient bits to W changes W from serialized input length to a different measure.

The reviewer check gives a full valid target witness with an anchor-row gauge: replace a unit U1 coordinate by `1e4096` and the matching U2 coordinate by `1e-4096`. Their product stays one, every factor equation remains true, and the current extractor accepts it. The bounded example demonstrates the accepted representation and the size discrepancy, not a timing lower bound. Increasing the exponent gives the asymptotic counterfamily to the stated input-height premise.

Required correction: define and enforce a literal rational grammar for both coefficients and interval endpoints before calling Fraction, for example integer JSON values or a signed integer numerator with an optional integer denominator. Reject compressed exponent and symbolic-expression strings. Preserve all ordinary rational values by their explicit numerator/denominator representations. Add one rejection check per input location and recheck the revised executable. This is a parser repair, not a new reduction mechanism or permission to weaken the fixed witness requirement.

## Independent targeted evidence

Command:

```
python3 campaigns/hadamard-decomposition/reviews/common-primitive/targeted_checks.py
```

[Source](targeted_checks.py) and [output](targeted_checks.txt) are retained. Four full-witness tests passed for both source truth orientations and two isolated roots of

```
P(theta) = -3 (theta^5 - 2)^2 (theta^2 - 2).
```

The intervals select either the fifth root of two or the positive square root of two. Witnesses use a degree-four shear, its inverse, a nonconstant row scale, and a rational-polynomial inverse modulo the relevant irreducible factor. A degree-13 coordinate perturbation vanishes at the selected root but is not divisible by the entire defining polynomial. Every target entry is independently checked modulo the selected irreducible polynomial, and extraction is executed in a fresh process. These tests exercise gcd localization, repeated roots, negative leading coefficients, high-degree coordinates and the case deg(D)>deg(P).

The fifth test confirms acceptance of the compressed-exponent gauge described in R3. These checks do not import the candidate or repeat the 29-source suites. Finite testing is not the general correctness proof.

## Novelty, significance and next action

Novelty remains supported within the primary-literature coverage and explicit gaps of the first review. The new codec is standard exact algebraic arithmetic, not an added originality claim. The fixed significance assessment is unchanged: NP-hardness for nonnegative integer matrices with one Hadamard width fixed at two would be a meaningful contribution; the second width grows.

After the literal-rational repair and its focused checks, reassess R3. Unchanged structural, algebraic and literature evidence can be reused. Advance remains withheld until the serialized-input runtime premise is enforced.
