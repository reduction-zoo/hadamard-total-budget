# Candidate theorem: total-budget Hadamard feasibility is NP-hard

Status: native independent review advanced on 2026-09-15; human expert review
remains pending. The fixed question is unchanged.
All factors are real with arbitrary signs. Exactly two factors are allowed.

## Construction

Encode a 3-SAT formula with n occurring variables and m clauses as positive
subset-product items using distinct variable primes p_v and clause primes q_j.
For each variable in order, make the true item then the false item: p_v times
the product of q_j raised to the number of its literal occurrences made true.
For each clause append q_j and q_j^2. The target is T=product(p_v)*product(q_j^4).
Pad with ones to K=max(3,2n+2m). A target-product subset selects exactly one
assignment item per variable. Each clause contributes c true occurrences,
0<=c<=3, and its slack items add 0,1,2,3; exponent four is reachable iff c>=1.
Thus the subset equation is equivalent to satisfiability, with direct recovery.
This prime-exponent encoding is standard, not the new contribution.

Set s=2K, N=s^2 and budget b=2s=4K. Column indices are cells (a,c) in
{0,...,s-1}^2, in row-major order. Start M with I_N. In each pair of columns
2i,2i+1 of the first two tensor rows, name the indices
L_i=(0,2i), R_i=(1,2i+1), X_i=(0,2i+1), Y_i=(1,2i).
All indices except X_i,Y_i are anchors. The labels are construction indices,
not an assumption about the coordinates of an arbitrary witness.

For every pair of anchors in the same grid row, add their two-unit sum row.
Do the same for every pair of anchors in the same grid column. Row families
are ordered by row, then column, with lexicographic pairs. Add the four local
pair rows X_i+L_i, X_i+R_i, Y_i+L_i, Y_i+R_i, then calibration L_i+R_i+X_i+Y_i.
Finally add K cycle rows: block i has coefficients (1,r_i,1,r_i) at L,R,X,Y;
block i+1 has (1,1,1,1), except the last row uses (1,T^2,T,T) at block zero.
All other entries are zero. The matrix is nonnegative integer and has
mu=s^2+K(K-1)+s(s-1)(s-2)+6K rows and N=s^2 columns.

## Budget saturation

For every Hadamard product M=A Hadamard B, rank(M)<=rank(A)*rank(B), by
expanding rank-one sums. The leading identity gives rank(M)=N=s^2.
Any feasible widths p,q under budget 2s therefore satisfy
s^2<=pq<=(p+q)^2/4<=s^2. Equality forces p=q=s and actual ranks s.
This excludes every alternative allocation, including smaller budgets.
The arithmetic observation is standard; it does not by itself force a grid.

Write the identity row product vectors as z_J=u_J tensor w_J in R^s tensor R^s.
Their pairings with column product vectors form I_N. They and the column
vectors are dual bases, since the ambient dimension is N. Every later row
with coefficients m_J consequently has product vector sum_J m_J z_J.

## Anchor orientation lemma

For two independent product vectors, their sum has rank one iff they share
one factor line. If neither pair of factor lines agrees, two linear maps
send their sum to the 2-by-2 identity, of rank two. The converse is immediate.
A clique of at least three independent product vectors with rank-one pair sums
shares one common factor line: fix a pair sharing one line; a third without
that line would have to share both distinct opposite lines. The same argument
extends to every member. Such a clique has a unique common side.

Each complete anchor row a>=2 has s members; each anchor column has s-1.
They intersect in exactly one index. If their common sides were equal, their
common lines would coincide at the intersection, confining 2s-2 independent
basis vectors to a subspace of dimension s. This is impossible since s>=6.
Thus every column clique has the opposite orientation to every complete row,
and all complete rows have the same orientation. A top anchor row has K members
and meets each applicable column in one member. Equal orientation would confine
K+s-2>s independent vectors to dimension s (K>=3), again impossible.
After possibly swapping the two factor spaces, all anchor rows have common
left lines alpha_a and all columns common right lines beta_c. Every anchor
therefore equals a nonzero scalar times alpha_a tensor beta_c.

The s anchors in a complete row are independent, so beta_0,...,beta_(s-1)
are independent. In particular the right factors of each L_i,R_i are distinct.
If alpha_0 and alpha_1 were the same line, both local common neighbors X_i,Y_i
would have that left line: sharing both distinct right lines is impossible.
Then all N basis vectors would have left factors in the span of at most s-1
lines (that line and the s-2 complete rows), contradicting their independence.
Thus alpha_0 and alpha_1 are independent. Every local common neighbor must
occupy an opposite corner between these two left lines and beta_(2i),beta_(2i+1).
X_i,Y_i occupy different corners because they are independent.
All basis vectors now have left factors among alpha_0,...,alpha_(s-1).
The same dimension argument forces these s left vectors to be a basis.
This proves the anchor structure without assuming a Cartesian identity basis.

## Selector and cycle

Absorb the L_i scalar into b_i on line beta_(2i), and the R_i scalar into c_i
on line beta_(2i+1). Write alpha=alpha_0, beta=alpha_1. All b_i,c_i together
are a basis of the right space. Then L_i=alpha tensor b_i, R_i=beta tensor c_i.
The opposite corners and calibration give exactly two possibilities, t_i!=0:
selected: X_i=t_i alpha tensor c_i, Y_i=t_i^(-1) beta tensor b_i;
unselected: X_i=t_i beta tensor b_i, Y_i=t_i^(-1) alpha tensor c_i.
Indeed if the two multipliers are initially t_i,v_i, calibration has determinant
1-t_i*v_i, so v_i=1/t_i. No positivity premise is used.

Coefficients (a,b,c,d) reshape locally as [[a,c*t_i],[d/t_i,b]] when selected,
and [[a,d/t_i],[c*t_i,b]] otherwise. Put epsilon_i=1 for selected and zero
otherwise, and h_i=1/t_i for selected, t_i otherwise. The second-to-first-row
ratios of the three patterns (1,1,1,1), (1,r_i,1,r_i), (1,T^2,T,T) are
h_i, r_i^epsilon_i*h_i, T*h_i respectively. Their local determinants vanish.
The independent right blocks imply that each whole cycle row has rank one iff
the two ratios agree. Thus h_(i+1)=r_i^epsilon_i*h_i and the closing equation
T*h_0=r_(K-1)^epsilon_(K-1)*h_(K-1). Multiplication cancels all nonzero h_i,
giving product(r_i^epsilon_i)=T. This proves soundness over all real witnesses.

Conversely, from a subset product choose standard left and right bases, h_0=1,
successive prefix products h_i, and the t_i just defined. Assign each anchor
its standard grid cell, and each X_i,Y_i its selected or unselected corner
and multiplier. The N vectors are a scaled permutation of the tensor grid,
so their dual basis also consists of product vectors. All anchor clique sums,
local pair sums, calibrated rows and cycle rows are product vectors by the
stated identities. Factor each reshaped row into two vectors for U,W, and each
dual basis vector for V,Z. Their pairings reproduce every entry of M exactly.
All coordinates in this constructed witness are rational. This proves completeness.

## Universal witness recovery

The anchor rows L_0 and L_1 have the same left line and independent right
lines in the oriented frame. Check whether rows 0 and 2 of supplied U are
proportional. If yes, use U as the left factor; otherwise use W. This handles
a global swap of the two spaces. For each assignment item i, X_i is selected
iff its row (index 2i+1) is proportional to row L_0 in that factor. Recover
one truth value per assignment pair. The prime exponents prove that exactly
one item in each pair is selected and every clause is satisfied.

For any nonzero vector a, choose its first nonzero coordinate a_j. A vector c
is proportional iff a_j*c_l-c_j*a_l=0 for all l. All identity-factor rows are
nonzero. Over the public common-primitive encoding, an evaluated polynomial D
vanishes at the isolated root theta of P iff gcd(P,D) has a root in the
isolating interval. Compute the gcd by the last nonzero subresultant, remove
repeated roots and count using sign-corrected subresultant Sturm sequences.
The prior campaign's reviewed literal-rational implementation is reused directly.
Dense explicit degrees and literal coefficients prevent hidden exponent growth.
Reducible and nonsquare-free P and arbitrary real coordinate gauges are covered.

## Bit complexity

Let ell be the source bit length and S=n+m+2. K,s=O(S), N=O(S^2), mu=O(S^3).
The first n+m primes are O(S log S); trial division finds them in polynomial
time. Items, T and T^2 have O(S log S) bits, charging all 3m literal occurrences.
Hence there are O(S^5) matrix entries and O(S^6 log S) output bits.
Schoolbook arithmetic and dense construction fit conservative bounds
O((ell+2)^10) forward bit operations and O((ell+2)^7) output bits.

The completeness witness has polynomial encoding length: h_i is an item
subproduct, of at most O(S^2 log S) bits under a loose bound; only rational
multiplication and division by nonzero coordinates is needed.

Let H be the entire supplied witness length. Each coordinate degree and
coefficient height is O(H). The previous common-primitive subresultant analysis
bounds each zero test by O((H+2)^24) bit operations; it clears denominators and
uses controlled subresultants, not naive unnormalized symbolic elimination.
Recovery uses O((n+1)s)=O((ell+2)^2) zero tests, including pivot searches and
orientation detection. Thus O((ell+2)^2*(H+2)^24) bit operations is a deliberately
loose bound for the implemented decoder. Its output has O(ell+1) bits.
No bound polynomial in ell alone is assumed for arbitrary witness encodings.
Arithmetic dependencies and their exact hypotheses require independent review.

## Novelty and scope

The contribution proposed here is the incomplete Cartesian anchor frame combined
with budget saturation and reversible selectors. The rank-product bound, AM-GM,
identity decompositions, prime encoding and algebraic zero tests are prior tools.
The selector-cycle mechanism is from the preceding repository campaign, not a
second independent discovery. Unlike that fixed-width result, this theorem
excludes all allocations under a total budget. It concerns exactly two factors,
exact equality, and unweighted nonnegative integer input; it does not establish
approximation hardness, hardness with a variable number of factors, strong
NP-hardness or membership of the unrestricted problem in NP.

## Primary references checked for this candidate

Checked 2026-09-15. Ciaperoni, Gionis and Mannila (2024), Sections 4.1/4.3/9,
https://link.springer.com/article/10.1007/s10618-024-01033-y, supplies the model,
rank-product bound and complexity question. Wertz, Vandaele and Gillis (2025),
https://arxiv.org/html/2504.13633v2, Theorem 1 and Appendix A/B, studies total
rank budget, maximal attainable rank and identity realizations. Credit these
prior ingredients explicitly; their identity result does not constrain the
additional anchor and cycle rows in this candidate. Gillis et al. (2026),
https://arxiv.org/html/2605.28980v1, Lemmas 2.3–2.4, gives the related
face-splitting/rank-one reshape viewpoint and numerical algorithms.

The literal common-primitive arithmetic uses Emiris, Mourrain and Tsigaridas,
Real Algebraic Numbers: Complexity Analysis and Experimentation, Theorems
2.1–2.4 and Section 6, https://who.paris.inria.fr/Elias.Tsigaridas/files/emt-lncs-2006.pdf,
and Akritas, Anna Johnson and Her Seminal Theorem of 1917, Section 2.4.3,
https://faculty.e-ce.uth.gr/akritas/publications/100.pdf. The exact current
subresultant routine and the height argument were inspected in the preceding
campaign's common-primitive review; the current decoder adds only line tests.
Rosser and Schoenfeld (1962), Theorem 3 and its corollary,
https://doi.org/10.1215/ijm/1255631807, supplies the prime magnitude bound.

Current Web/arXiv queries include `"Hadamard" "sum of ranks" hardness`,
`"Hadamard decomposition" "NP-hard" total budget rank`, `"Hadamard decomposition"
"equal" "complexity"`, `Hadamard decomposition "rank budget" complexity hardness`,
`Hadamard factorization "rank sum" NP hard`, `"product basis" "rank-one" "clique"
Cartesian`, and `"Hadamard" "minimum" "rank" "NP-hardness"`.
No matching total-budget hardness theorem was found within this coverage.
Unindexed results, exhaustive citation closure and unexamined implications of
broader representation theorems remain unresolved. Searches also returned
Hadamard-based neural adapters and tensor-entry optimization with different
predicates; no complexity transfer from those results is asserted.
