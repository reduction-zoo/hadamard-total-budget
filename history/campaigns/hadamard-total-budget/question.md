# 3-SAT to total-budget Hadamard complexity

Status: selected for preparation; no hardness result claimed.
Date: 2026-09-15. The user proposed this distinct theorem after the fixed-width
Hadamard campaign. This question does not replace that campaign's statement.

## Decision languages and required theorem

The source is 3-SAT with three literals per clause, allowing repetitions, in
binary encoding. Variables are renamed consecutively over the occurring variables;
the empty conjunction is satisfiable. Malformed encodings are outside the language.

The target input is a nonempty rational matrix M of size m by n and a
nonnegative integer budget b, all binary encoded. Define

C0(M) = min { rank(A) + rank(B) : A,B real m-by-n matrices, M = A Hadamard B }.

Ask whether C0(M) <= b. There are exactly two factors; their entries have
arbitrary signs. The target does not prescribe either individual rank bound.
Ranks may be zero, so C0(0)=0; for a nonzero matrix both ranks are positive.
Equivalently quantify integer widths 0 <= p,q <= min(m,n), p+q <= b, and
real U,V,W,Z with M=(UV) Hadamard (WZ). Width zero denotes a zero product.

Construct one total deterministic polynomial-time map F -> (M_F,b_F) with
F satisfiable if and only if C0(M_F) <= b_F. Prove explicit polynomial bounds
on dimensions, coefficient bit lengths, budget bits and runtime. Every
well-formed source, YES or NO, must yield a well-formed target. Malformed
source strings may map to a designated malformed target outside the language.

Fixed-allocation hardness is insufficient. The NO direction must exclude every
allocation with sum at most b_F. A different gadget is permitted; preserving
the earlier matrix or its budget 2K+2 is not an acceptance requirement.

## Witness recovery as part of the research rule

A source witness is a satisfying Boolean assignment. An encoded target witness
supplies p,q and U,V,W,Z with the dimensions above, p+q <= b_F and every entry
of (UV) Hadamard (WZ) equal to M_F. Coordinates use one common real algebraic
primitive element: an explicitly dense nonzero integer defining polynomial,
a rational non-root interval isolating exactly one distinct real root, and
dense rational coordinate polynomials. Rational values use literal integer
numerators and denominators, without compressed exponent notation.

Recover a satisfying source assignment from every valid encoded target witness
in polynomial time in source plus witness length. Recovery must cover both
factor orders, all legal allocations and arbitrary valid coordinate gauges.
The mathematical soundness proof covers all real factors. Executable tests use
the finite algebraic encoding, without assuming polynomial witness length in F.
This recovery obligation is additional to standard Karp reducibility.

## Importance and difficulty

Importance: high for the stated metric. A qualifying theorem establishes
NP-hardness of optimizing the total rank cost, not merely feasibility at a
specified pair of widths. For an m-by-n dense two-factor parameterization,
the nominal scalar parameter count is (m+n)(p+q); this is a representation
count, not a claim about minimal bit storage or generalization performance.

Difficulty: high and not yet route-qualified. The existing proof's exact
ambient-dimension saturation is lost under alternative allocations. A gadget
must force an allocation, recover a hard subproblem under every allocation,
or encode the source by an allocation-independent mechanism. None is proved.

## Initial literature coverage

The following are screening leads, not a completed novelty audit:

- Ciaperoni, Gionis and Mannila, The Hadamard decomposition problem (2024),
  https://link.springer.com/article/10.1007/s10618-024-01033-y,
  Equations (1)-(2), Section 4 and Section 9: factor-width formulation,
  rank-product bound and complexity discussion. The rank-product bound
  alone does not force an allocation under a sum budget.
- Wertz, Vandaele and Gillis, Efficient algorithms for the Hadamard decomposition
  (2025), https://arxiv.org/abs/2504.13633; author-hosted conference version
  https://orbi.umons.ac.be/bitstream/20.500.12907/53536/1/42%20Efficient%20algorithms%20for%20the%20Hadamard%20decomposition%20-%20MLSP%202025.pdf.
  Search excerpt explicitly uses the sum of factor ranks as an experimental
  budget. Full theorem and related-work coverage for the total-budget
  decision problem remains to be inspected.

Web queries on 2026-09-15: `"Hadamard decomposition" "sum" "rank" complexity`
and `"Hadamard decomposition" "total" "NP-hard"`. No matching theorem appeared
in this limited search. This does not establish openness; equivalent objectives,
follow-ups and implications of existing reductions require further checking.

## Preparation and first proof obligation

Read the previous campaign's proof and boundary counterexamples in place.
Build the target oracle from the total-budget definition: test all unordered
legal allocations, using monotonicity only where proved. A NO answer requires
conclusive infeasibility for every relevant allocation; unknown is not NO.
The previous fixed-width target oracle is not an oracle for this problem.

Test zero, rank-one, identity, swapped-factor and noncanonical-allocation
witnesses before testing a new reduction. For the previous construction,
rank(M_F)=4K implies pq>=4K. This necessary condition admits
(3,2K-1) for K>=3 because 6K-3>=4K, while p+q=2K+2.
It proves only that the rank lower bound cannot exclude this allocation,
not that a NO formula has such a decomposition.

The first construction investigation should seek an actual alternative-allocation
witness for a smallest NO source, or a structural obstruction ruling it out.
Do not infer a general allocation-forcing lemma from finite solver outcomes.
