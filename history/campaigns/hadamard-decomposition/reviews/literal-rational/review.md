# Final focused review: literal rational inputs

Date: 2026-09-15. Decision: **advance**.

The literal-rational repair closes R3. Together with the earlier common-primitive arithmetic repair, all correctness and executable-contract findings from this review sequence are resolved. The unchanged construction, general real soundness proof, and significance assessment remain supported. Novelty remains supported within the documented primary-literature coverage, with its explicit limits. Advance means eligible for expert review and the remaining manuscript workflow; it does not mean publication acceptance or independent human verification.

## Scope and retained evidence

I compared the current algorithm.py with rounds/013/before-literal-rational-repair/algorithm.py, read the revised contract and Section 7, and inspected literal-rational-prepared-check.txt and literal-rational-check.txt. The actual code change is the shared rational parser and its two call sites. The forward construction and mathematical mechanism are unchanged.

I reuse the global proof audit and literature assessment in [the first review](../native/review.md), and the common-primitive gcd/Sturm audit and degree-five/repeated-factor witness evidence in [the second review](../common-primitive/review.md). Those files are unchanged. All new files are in this assigned review directory; no candidate implementation was imported and no agents were spawned.

## Correctness and runtime

**R3 is closed.** algorithm.py:61–65 checks integer type or the exact grammar `-?[0-9]+(?:/[0-9]+)?` before Fraction is called. Coordinate conversion uses this routine at line 70; interval conversion uses it at line 93. The grammar excludes exponent compression, decimal points and expression notation. Zero denominators fail explicitly. Signed numerators, leading zeros and reducible fractions cannot hide more numeric bits than their serialized digits. Every rational value still has a valid literal numerator/denominator representation.

The regex has no ambiguous nested repetition or expensive backtracking path: a sign, digits, and at most one slash with digits suffice. Parsing, normalization and integer conversion have polynomial bit cost. The defining polynomial already uses actual JSON integers, whose decimal serialization similarly charges their size to the input. Consequently input degrees and coefficient/endpoint bit sizes are O(W), and the polynomial bounds assessed in the previous review apply to the executable procedure. The mathematical interpretation is unchanged.

**R1 and R2 remain closed.** The implementation executes common-primitive polynomial determinants, gcds through controlled subresultants, square-free reduction and a sign-corrected Sturm count. It handles zero determinants, constant gcds, reducible and nonsquare-free defining polynomials and localization to the selected root. The previous review checked the actual installed SymPy routines rather than assuming an unspecified equivalent implementation. This repair introduces no additional field operation or arithmetic algorithm.

**Overall correctness judgment: pass.** The retained proof covers both Karp directions, the full unrestricted-real target, and recovery from every valid encoded algebraic witness. Forward construction is polynomial in source length, backward recovery is polynomial in source plus supplied witness length, and target dimensions/widths satisfy the fixed question. Existing oracle NO decisions still depend on the structural theorem; this review's direct proof audit, not repeated finite agreement, is the evidence for that theorem.

## Focused execution evidence

[Independent source](targeted_checks.py) and [output](targeted_checks.txt) are retained. Command:

```
python3 campaigns/hadamard-decomposition/reviews/literal-rational/targeted_checks.py
```

The check builds a full rational witness independently, validates its target entries, applies reciprocal signed fractional row gauges, and confirms successful fresh-process recovery using rational endpoints with leading zeros. It then injects scientific notation, decimal notation and expression notation separately at a coordinate and an endpoint. All six malformed inputs fail through the new literal-grammar error, before Fraction conversion. No unaffected source suite was rerun by the reviewer.

The submitted prepared log records six injected cases and eight recoveries passing. The independent log records 109 recoveries with nine algebraic gauges and both exponent-location rejections passing. These finite results support implementation behavior; they do not replace the general proof or bit analysis.

## Novelty and significance

**Novelty judgment: supported within reviewed coverage.** This final parser change introduces no new novelty question. Reused primary searches are dated 2026-09-15 and documented in the first report with URLs and theorem locations. Closest baselines include [the 2024 origin](https://link.springer.com/article/10.1007/s10618-024-01033-y), Equation (4) and Sections 4.3/9; [the 2025 algorithm paper](https://arxiv.org/html/2504.13633v2), Appendix B Lemma 2; [the 2026 face-splitting formulation](https://arxiv.org/html/2605.28980v1), Lemmas 2.3–2.4; and [entrywise-power/signing hardness](https://arxiv.org/html/2607.04875v2), Theorem 2.2. No inspected result supplies the synchronized selectors and multiplicative cycle for independent real Hadamard factors. Unindexed work, exhaustive citation closure and overlooked equivalent representation results remain outside coverage. The second review's unresolved pinpoint access to Akritas Section 2.4.3 is retained as a citation-coverage limit; correctness of the implemented routine was assessed directly from installed source and the algebraic argument.

**Significance judgment: pass.** The result addresses exact real Hadamard feasibility with arbitrary signs and at-most widths. Its nonnegative integer target matrices and fixed first width two give a concrete hardness boundary; the second width grows with the input. It does not establish both widths fixed, strong NP-hardness, approximation hardness, ETR-completeness or unrestricted NP membership.

No further repair is requested by this reviewer. The unchanged final candidate may proceed to the required write and expert-review preparation stages.
