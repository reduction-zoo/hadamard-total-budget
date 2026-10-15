# Balanced Hadamard allocation with an incomplete Cartesian frame

Tags: Hadamard-decomposition, total-rank-budget, rank-saturation, product-basis,
Cartesian-frame, selectors, witness-recovery

## Claim and applicability

For exactly two unrestricted-sign real factors, a matrix with s^2 columns and
a leading I_(s^2) forces both factor ranks to equal s under total rank budget
2s. Indeed, s^2 <= rank(A)rank(B) <= (rank(A)+rank(B))^2/4 <= s^2.
The identity row tensors and column tensors then form dual bases of an
s-by-s tensor space. This standard rank-product argument excludes every
alternative allocation; it does not by itself force Cartesian coordinates.

The following additional constraints enforce a frame while retaining selectors.
Let s=2K with K>=3 and index the identity columns by (a,c), 0<=a,c<s.
For each i<K, reserve L_i=(0,2i), R_i=(1,2i+1), X_i=(0,2i+1), Y_i=(1,2i).
Every index except X_i,Y_i is an anchor. Add a two-unit sum row for every pair
of anchors in the same grid row or column, and the four local sum rows joining
each of X_i,Y_i to each of L_i,R_i.

Up to a global exchange of factor sides, all anchor-row cliques share left
lines and all anchor-column cliques share right lines. A complete row and a
column intersect once: equal orientation would place 2s-2>s independent basis
vectors on one factor line. A top row gives the analogous inequality K+s-2>s.
The full identity basis and local neighbor constraints force the global left
and right lines to be bases, and X_i,Y_i occupy opposite corners of their
local 2-by-2 tensor rectangle. Adding L_i+R_i+X_i+Y_i calibrates their nonzero
multipliers to be reciprocal. These are the two orientations used by the
subset-product cycle in the linked construction.

The claim requires the specified pair rows, exact entry equations, full
identity saturation, and exactly two factors. It does not cover approximate
factorization, arbitrary incomplete grids, smaller clique sizes, or an
unrestricted number of factors. The incidence labels describe the construction;
Cartesian coordinates must be deduced, not assumed.

## Evidence and status

Evidence type: general lemma and complete reduction, with finite checks.
Origin: [round 001](../../campaigns/hadamard-total-budget/rounds/001/round.md).
The [proof](../../campaigns/hadamard-total-budget/work/proof.md) contains the
budget and anchor arguments, selector-cycle composition, both Karp directions,
and recovery from every valid common-primitive algebraic witness.
The [native independent review](../../campaigns/hadamard-total-budget/reviews/native/review.md)
advanced the result on 2026-09-15, including the all-allocation converse.
Independent human expert assessment remains pending; novelty is qualified by
the review's explicit literature-coverage limits.

[Standalone checks](../../campaigns/hadamard-total-budget/rounds/001/probe-repaired.txt)
cover eight complete frame witnesses and fifteen allocation boundaries.
[Independent verification](../../campaigns/hadamard-total-budget/work/verification.md)
records fourteen source instances and seventy recovery calls. The reviewer
also checked negative prefix parameters, dense coordinate changes and localized
high-degree algebraic representatives in both factor orders. Structural NO
oracles depend on the general frame proof; their agreement does not prove it.

Rank-product bounds, rank budgets and identity constructions are prior tools;
see Wertz, Vandaele and Gillis, [Theorem 1 and Appendices A–B](https://arxiv.org/html/2504.13633v2).
The selector-cycle mechanism comes from the preceding
[fixed-width campaign](../../campaigns/hadamard-decomposition/rounds/013/round.md).
The extension recorded here is the incomplete frame combined with balanced
saturation, not a new claim of originality for those ingredients.

## Consequence for search

When transferring fixed-width Hadamard hardness to a total budget, first check
whether the rank-product lower bound forces a unique allocation. If it does
not, the fixed-width converse cannot simply be reused. Square saturation offers
a concrete route, provided the discrete construction can be embedded in the
larger balanced space with the frame constraints proved above.

For witness recovery, determine the global orientation by testing which factor
has proportional identity rows L_0,L_1, then decode each X_i by proportionality
to L_0 on that side. Test factor exchange and coordinate changes mixing active
and frame directions; canonical witnesses alone do not exercise this premise.

## Use history

Extracted on 2026-09-15 after explicit user authorization to write the shared
entry. The originating round used the prior selector-cycle evidence and produced
the total-budget candidate. No subsequent campaign use or comparative discovery
benefit has yet been recorded.
