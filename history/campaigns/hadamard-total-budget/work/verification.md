# Verification of the total-budget candidate

The independent checker imports neither candidate code nor the prepared checker.
It invokes the actual forward map, verifies its complete returned matrix and
budget against the frame family, solves the extracted subset-product instance
by meet-in-the-middle enumeration, and compares the outcome to exhaustive
source assignments. For target YES cases, it independently builds factors and
checks every entry by Fraction arithmetic before invoking the actual extractor.

Command: `python3 campaigns/hadamard-total-budget/work/verify.py --candidate
campaigns/hadamard-total-budget/work/algorithm.py`.
[Output](../rounds/001/independent-check.txt): 14 distinct sources, 12 YES and
two NO, 70 recovery calls including four algebraic gauges, and four malformed
sources. There are no random cases or timeouts. The largest output is 3720 by
256, budget 32. The finite source domain includes all eight one-variable
one-clause sign patterns, contradictory unit clauses, mixed/repeated literals,
and two- and three-variable cases with K<=8.

Witness variants include up to two target subset choices, coordinate swaps and
shears mixing the active rows with frame directions, signed row/column gauges,
and exchange of entire factor sides. Algebraic witnesses use polynomial shears
and their inverses over a positive quadratic root, negative quadratic root,
cubic root and a repeated defining polynomial. Their base rational factors are
fully checked; the shear preserves each ordinary product identically in the
polynomial parameter. This is a restricted algebraic witness family, not
exhaustive coverage of encoded factors.

The structural target NO decision relies on the general allocation and anchor
lemmas; enumeration does not independently establish them. No large unrestricted
quartic instance is claimed solved. The [native independent review](../reviews/native/review.md) advances the
candidate after auditing general correctness, qualified novelty, significance
and polynomial recovery bounds. Its own targeted checks add two full
higher-degree algebraic witness recoveries, including both factor orders.
Independent human assessment remains pending.
