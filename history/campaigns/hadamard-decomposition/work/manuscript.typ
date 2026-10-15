#import "report.typ": research-report
#show: research-report.with(
  title: "NP-hardness of exact Hadamard decomposition\nwith one rank bound equal to two",
  date: "15 September 2026",
  status: "Working manuscript · Awaiting independent human expert review",
)
#set math.equation(numbering: "(1)")
#let proof(body) = [*Proof.* #body #h(1fr) $square$]

#heading(numbering: none)[Abstract]
Exact Hadamard decomposition asks whether a rational matrix is the entrywise
product of two real matrices with prescribed rank bounds. We give a deterministic
polynomial-time reduction from 3-SAT, even when the input matrix is nonnegative
integer and one rank bound is two. An identity submatrix forces a basis of
product vectors. Additional rows synchronize two-choice selectors, and weighted
rows around a cycle encode an exact subset-product equation. The converse holds
for arbitrary real factors, without sign restrictions. A determinant predicate
recovers a satisfying assignment from every valid decomposition. For witnesses
encoded over a common real algebraic primitive element, a subresultant and Sturm
procedure implements recovery in polynomial bit time. The construction addresses
an explicitly stated complexity question; its novelty is supported within the
literature coverage described here and remains subject to expert assessment.

= Introduction

Hadamard decomposition represents a matrix by multiplying low-rank matrices
entrywise. It can represent a matrix of rank equal to the product of the factor
ranks. This expressive capacity motivates its use as a multiplicative model for
matrix compression. Ciaperoni, Gionis and Mannila introduced a data-analysis
formulation, placed exact real feasibility in the existential theory of the
reals, and left its formal computational complexity open @ciaperoni2024.

Subsequent work developed alternating and manifold-based numerical algorithms
@wertz2025 @gillis2026manifold. The product-vector interpretation is also known:
rank-one reshapes of row factors recover the Hadamard representation
@gillis2026manifold. These algorithms and reformulations do not decide exact
feasibility for all rational inputs. Our contribution is a reduction that forces
discrete choices within the unrestricted real factorization model.

For a rational matrix $M in QQ^(mu times N)$ and positive integer bounds
$p,q <= min(mu,N)$, define exact Hadamard feasibility by
$ M = (U V) ⊙ (W Z), $ <hadamard>
where $U in RR^(mu times p)$, $V in RR^(p times N)$,
$W in RR^(mu times q)$ and $Z in RR^(q times N)$. The symbol $⊙$
denotes entrywise multiplication. Factor entries may have arbitrary signs;
the two ordinary products have ranks at most their respective bounds.

#block[
  *Theorem 1 (Main result).* Exact Hadamard feasibility is NP-hard under
  deterministic polynomial-time many-one reductions, even for nonnegative
  integer matrices with $p=2$. More precisely, a 3-SAT formula with $n$
  occurring variables and $m$ clauses maps to an instance with
  $ K=max(3,2n+2m), quad mu=K^2+9K, quad N=4K, quad q=2K. $ <dimensions>
  The formula is satisfiable if and only if this instance is feasible.
  Every valid real decomposition determines a satisfying assignment by explicit
  determinant zero tests. On the common-primitive algebraic witness encoding
  defined in @recovery, these tests give a deterministic algorithm polynomial
  in the formula length plus the supplied witness length.
] <main-theorem>

The source reduction uses the standard many-one framework @karp1972. A
prime-exponent encoding first expresses satisfaction as subset product.
The new matrix construction then makes each item correspond to one of two
orientations of a product-vector selector. Calibration retains a nonzero
continuous parameter at each selector. A cycle of weighted rows makes the
product of the selected items equal a prescribed target. The second rank bound
grows with the source instance; the theorem does not fix both bounds.

= From 3-SAT to subset product <prime-encoding>

Let $F$ be a conjunction of $m$ clauses, each containing three literals.
Repeated literals are allowed. Number the occurring variables consecutively
from $1$ to $n$; the empty conjunction has $n=0$. Renaming the occurring
variables of an ordinary 3-SAT formula is polynomial-time. This convention also
ensures that the assignment length is bounded by the source encoding length.

Choose distinct primes $pi_i$ for variables and $kappa_j$ for clauses. For each
variable $i$ and truth value $b$, let $c_(i,b,j)$ be the number of occurrences
in clause $j$ made true by that value. Create two assignment items per variable
and two slack items per clause:
$ r(i,b)=pi_i product_(j=1)^m kappa_j^(c_(i,b,j)),
  quad kappa_j, quad kappa_j^2. $ <items>
The required product is
$ T=(product_(i=1)^n pi_i)(product_(j=1)^m kappa_j^4). $ <target-product>
Order the assignment items by variable, with the true item before the false
item, followed by the clause slack pairs. Append ones if needed to obtain
$K>=3$ items, indexed $r_0,dots,r_(K-1)$.

#block[
  *Lemma 1 (Prime encoding).* A subset of these items has product $T$ if and
  only if $F$ is satisfiable. Reading the selected assignment items recovers
  a satisfying assignment from every exact-product subset.
] <prime-lemma>

#proof[
  The exponent of $pi_i$ forces exactly one of variable $i$'s assignment items.
  Its selected truth value determines how many literals of each clause are
  true. For clause $j$, let this count be $c_j$, between zero and three.
  Its two slack items can add exponent zero, one, two or three. The required
  exponent four is reachable exactly when $c_j>=1$. This proves both
  implications, including repeated literals. Padding by ones changes no
  exponent. For the empty formula, $T=1$, and the empty subset is feasible.
]

= Matrix construction <construction>

We now take any positive integers $r_0,dots,r_(K-1),T$ with $K>=3$.
For each item $i$, reserve four column indices $L_i,R_i,X_i,Y_i$, in that order.
Let $e_J$ denote the unit row vector at index $J$ in $RR^(4K)$.
The matrix begins with the identity $I_(4K)$. The remaining rows are prescribed
coefficient vectors relative to these indices.

First add $e_(L_i)+e_(L_j)$ for every $i<j$, then the corresponding $R$ rows.
For each $i$, add the four rows pairing either $X_i$ or $Y_i$ with either
$L_i$ or $R_i$. Next add one calibration row per item:
$ C_i=e_(L_i)+e_(R_i)+e_(X_i)+e_(Y_i). $ <calibration>
Finally add one cycle row per item. A cycle row has only two nonzero blocks,
each of length four. Row $i$ uses
$ (1,r_i,1,r_i) " in block " i, quad
  (1,1,1,1) " in block " i+1 $ <ordinary-cycle>
when $0<=i<K-1$. The last row instead uses
$ (1,r_(K-1),1,r_(K-1)) " in block " K-1, quad
  (1,T^2,T,T) " in block " 0. $ <closing-cycle>
All omitted entries are zero. Every zero is a prescribed value, not a missing
entry. The output bounds are $p=2$ and $q=2K$.

The row counts, in construction order, are $4K$, $K(K-1)$, $4K$, $K$ and $K$.
They give @dimensions. The two blocks of every cycle row are distinct because
$K>=3$. All entries are nonnegative integers.

@factorization-figure shows the support of a complete, exactly verified
factorization for a one-clause formula. The five row families remain visible
in the target matrix.

#figure(
  include "figures/factorization.typ",
  caption: [An actual constructed instance for $F=(x_1 or x_1 or x_1)$,
    with $K=4$. Black cells indicate nonzero entries; these are support plots,
    not plots of entry magnitudes. The rational factors satisfy every entry
    of $(U V) ⊙ (W Z)=M$ exactly. Heavy vertical lines separate the four
    selector blocks; horizontal lines separate the five row families.
    The matrix-based presentation follows the visual convention of Figures
    1 and 3 in @ciaperoni2024.],
) <factorization-figure>

= Structure forced by a feasible decomposition <structure>

== Saturation and pair sums

A nonzero tensor $a ⊗ b$ is called a product vector. Under the usual
coordinate identification, it is a rank-one matrix. In a decomposition satisfying
@hadamard, associate the product vector $u_A ⊗ w_A$ to row $A$, and
$v_J ⊗ zeta_J$ to column $J$. Their pairing is $M_(A,J)$.
Here $u_A,w_A$ are rows of $U,W$, while $v_J,zeta_J$ are columns of $V,Z$.

#block[
  *Lemma 2 (Saturation).* The first $N=4K$ row product vectors form a basis of
  $RR^2 ⊗ RR^(2K)$, and the column product vectors form its dual basis.
  A later row with coefficients $(a_J)_J$ has product vector $sum_J a_J z_J$,
  where $z_J$ denotes the basis vector belonging to identity row $J$.
] <saturation-lemma>

#proof[
  The leading identity gives a nonsingular pairing matrix of size $N$.
  The ambient tensor space has dimension exactly $N$. Both families are
  therefore bases and are dual. Pairing a later row with every dual basis
  vector determines each of its coordinates. This forces its entire product
  vector, not just a projection. Lower actual factor ranks cannot evade the
  argument, since the identity already requires the full ambient dimension.
]

For two independent product vectors, their sum is a product vector exactly
when they share a left or a right factor line. If both pairs of factors were
independent, linear functionals on their spans would map the sum to a
$2 times 2$ identity matrix, contradicting rank one. The converse follows
by distributing the tensor product.

Three or more independent product vectors with product-vector pairwise sums
must share one factor line. To see this, fix two that share a left line and
have distinct right lines. A third vector without that left line would have
to share both distinct right lines, which is impossible. Thus it has the
common left line. The argument with left and right exchanged is identical.

== Synchronized selectors

#block[
  *Lemma 3 (Two orientations).* In every feasible decomposition, there are
  independent left vectors $alpha,beta$ and a basis
  $b_0,c_0,dots,b_(K-1),c_(K-1)$ of $RR^(2K)$ such that
  $ z_(L_i)=alpha ⊗ b_i, quad z_(R_i)=beta ⊗ c_i. $
  For each $i$, exactly one of the following orientations holds, with a
  nonzero real scalar $t_i$:
  $ "Selected: " & z_(X_i)=t_i alpha ⊗ c_i, quad z_(Y_i)=t_i^(-1) beta ⊗ b_i, \
    "Unselected: " & z_(X_i)=t_i beta ⊗ b_i, quad z_(Y_i)=t_i^(-1) alpha ⊗ c_i. $ <orientations>
] <selector-lemma>

#proof[
  The pair-sum rows on the $L$ indices force a common factor line.
  A common right line would confine $K>=3$ independent vectors to a
  two-dimensional space. They therefore share a left line $alpha$.
  The $R$ indices likewise share a left line $beta$.

  These two lines are distinct. Otherwise each pair $z_(L_i),z_(R_i)$ would
  have the same left line and independent right factors. Its two common
  neighbors would be forced onto that left line as well. All $4K$ basis
  vectors would then lie in a space of dimension $2K$, a contradiction.
  Write the anchor vectors as in the statement.

  Within each block, $b_i$ and $c_i$ are independent. If they were proportional,
  every common neighbor would have that right line: it cannot share both
  independent left lines. The four vectors would lie in a two-dimensional
  space. With both pairs of factor lines distinct, a common neighbor must
  occupy an off-diagonal tensor position. The two neighbors occupy opposite
  positions because they are independent. Initially write their nonzero
  multipliers as $t_i,s_i$.

  All right vectors across blocks are independent. A proper span of the
  $2K$ right vectors would make the span of the $4K$ basis vectors smaller
  than $4K$. This proves the global independence needed for composition.
  In either orientation, the calibration row has determinant $1-s_i t_i$
  in the local $2 times 2$ coordinates. Its decomposability forces
  $s_i t_i=1$, proving @orientations.
]

= Cycle equivalence and completeness <cycle-section>

Let $epsilon_i$ be one for the selected orientation and zero otherwise.
For block coefficients $(a,b,c,d)$ at indices $(L_i,R_i,X_i,Y_i)$, the local
coordinate matrices supplied by Lemma 3 are
$ mat(a,c t_i; d/t_i,b) " (selected), " quad
  mat(a,d/t_i; c t_i,b) " (unselected). " $ <local-blocks>
Define $h_i=1/t_i$ in the selected orientation and $h_i=t_i$ otherwise.
Each pattern in @calibration, @ordinary-cycle and @closing-cycle satisfies $a b=c d$ and
has no zero entries. Its local block has rank one. The ratio of its second
row to its first is
$ (1,1,1,1) & ↦ h_i, \
  (1,r_i,1,r_i) & ↦ r_i^(epsilon_i) h_i, \
  (1,T^2,T,T) & ↦ T h_i. $ <ratios>
These formulas follow directly from the first column of @local-blocks.

#block[
  *Lemma 4 (Product cycle).* The constructed matrix has a real Hadamard
  decomposition at widths $(2,2K)$ if and only if a subset of the item
  integers has product $T$.
] <cycle-lemma>

#block(breakable: false)[*Proof.* Suppose a decomposition exists. By the global right-basis independence
  in Lemma 3, a cycle row has rank one only when its two nonzero blocks
  have the same left line. Applying @ratios gives
  $ h_(i+1)=r_i^(epsilon_i) h_i quad (0<=i<K-1),
    quad T h_0=r_(K-1)^(epsilon_(K-1)) h_(K-1). $ <recurrence>]
  Every $h_i$ is nonzero. Multiplying these equations and cancelling gives
  $ product_(i=0)^(K-1) r_i^(epsilon_i)=T. $ <product-equivalence>
  No positivity of a factor or of $t_i$ has been assumed.

  Conversely, suppose a subset satisfies @product-equivalence. Use the two
  standard left basis vectors for $alpha,beta$ and the standard right basis
  for all $b_i,c_i$. Set $h_0=1$ and compute the successive $h_i$ from
  @recurrence. #box[Set $t_i=1/h_i$] for a selected item and $t_i=h_i$ otherwise.
  The four vectors of each block in Lemma 3 are a scaled permutation of
  the standard tensor basis. Their dual basis also consists of product vectors.

  Use this basis for the identity rows and its dual for the columns.
  Anchor and neighbor rows are product vectors because their summands
  share a factor. Calibration rows have zero local determinant.
  The cycle rows have equal left-line ratios by @recurrence, including
  the last row by the subset-product premise. Each resulting rank-one
  coordinate matrix factors into a left and a right vector. These provide
  $U,W$ row by row, while the product duals provide $V,Z$ column by column.
  Their pairings equal every prescribed entry of $M$. All constructed
  coordinates are rational. #h(1fr) $square$

The cycle-row submatrix is shown in @cycle-figure. Lemma 1 followed
by Lemma 4 proves the YES/NO equivalence in Theorem 1.

#figure(
  include "figures/cycle.typ",
  caption: [The cycle-row submatrix for $K=4$, with the same block order
    as @factorization-figure. Each white block labeled zero is entirely zero.
    An outgoing block and its incoming block must have the same left-factor
    line, giving the equation at the right. The last row couples block 3
    back to block 0 with the prescribed target $T$. Multiplying the four
    equations eliminates the nonzero ratios $h_i$. The same pattern extends
    to every $K>=3$; the coefficients here are symbolic.],
) <cycle-figure>

= Witness recovery and bit complexity <recovery>

== Recovery from arbitrary valid factors

The first row of $U$ belongs to identity index $L_0$. For each assignment item
$i$, compute the determinant of its left-factor rows at $L_0$ and $X_i$.
By Lemma 3, this determinant is zero exactly when item $i$ is selected:
$ epsilon_i=1 ⇔ det mat(u_(L_0,1),u_(L_0,2);u_(X_i,1),u_(X_i,2))=0. $ <decode>
This predicate is invariant under invertible changes of left coordinates and
nonzero row gauges. It therefore applies to every valid real decomposition,
not only to the witnesses constructed in Lemma 4. Read the first $2n$ item
bits and assign variable $i$ true exactly when its true item is selected.
Lemma 1 guarantees that exactly one item in each pair is selected and that
the recovered assignment satisfies every clause.

== The encoded zero test

For executable recovery, encode all factor entries in one real algebraic
primitive element $theta$. The witness supplies a nonzero integer polynomial
$P$ and rational non-root endpoints $a<b$ whose interval contains exactly
one distinct real root $theta$ of $P$. Each factor entry is a dense rational
coordinate polynomial evaluated at $theta$. The polynomial $P$ may be
reducible or have repeated roots. All degrees and coefficients are written
explicitly. Rational numerators and denominators are integer literals;
compressed exponents and symbolic expressions are excluded.

For the determinant polynomial $D$ in @decode, use the equivalence
$ D(theta)=0 ⇔ gcd(P,D) " has a root in " (a,b). $ <gcd-test>
Every root of the gcd is a root of $P$, so the isolating premise makes the
right-hand root count zero or one. A zero determinant gives $gcd(P,0)=P$;
a constant gcd has no root. This handles localization to an irreducible
factor without factoring $P$ or constructing another number field.

The executable computes the gcd up to scale as the last nonzero subresultant.
For root counting, it clears denominators, takes the primitive integer part,
and removes repeated factors using the gcd with the derivative. It then
computes the sign-corrected subresultant Sturm sequence. Subtracting its
sign-variation count at $b$ from that at $a$, omitting zero evaluations,
gives the required root count. These are standard exact polynomial operations
@emiris2008. The implementation uses SymPy's #raw("Poly.subresultants") and
#raw("sturm_amv(method=1)"); the latter computes sign-corrected subresultants
as described in Section 2.4.3 of @akritas2016. No feasibility solver runs
inside either reduction map.

== Bounds for both maps

Let $ell$ be the source bit length and set $S=n+m+2$.
The first $n+m$ primes have magnitude $O(S log S)$ by the classical explicit
prime bounds @rosser1962. Trial division generates them in polynomial time.
The total number of literal occurrences is $3m$, so each item, $T$, and $T^2$
has $O(S log S)$ bits. The dense target consequently has
$ O(S^3) " entries and " O(S^4 log S) " bits. " $ <output-bound>
This is a loose encoding bound that charges the longest entry at every
position. Schoolbook arithmetic and serialization give conservative bounds
$ O((ell+2)^8) " forward bit operations, " quad
  O((ell+2)^5) " output bits. " $ <forward-bound>
The rational witnesses in Lemma 4 also have polynomial encoding length:
every $h_i$ is an item subproduct, with at most $O(S^2 log S)$ bits under
a loose bound. This statement concerns the constructed YES family only.

Let $H$ be the total serialized algebraic witness length and put $B=H+2$.
Literal rational parsing and dense coordinate encoding ensure that degrees
and input coefficient heights are at most $B$. Each determinant has degree
$O(B)$ and, after clearing denominators, coefficient height $O(B^2)$.
A subresultant coefficient is a determinant of a Sylvester submatrix of
order $O(B)$, giving height $O(B^3)$ for the normalized gcd. The square-free
part retains this polynomial height; its sign-corrected subresultants have
height $O(B^4)$. The subresultant size bounds underlying these steps are
standard; see Theorems 2.1–2.4 of @emiris2008.

The controlled remainder procedure has $O(B^3)$ rational coefficient
operations per sequence. Allowing $O(B^8)$ bits per intermediate numerator
or denominator conservatively covers polynomial divisions on these
bounded-degree, bounded-height inputs. Schoolbook rational arithmetic,
normalization and endpoint evaluation therefore fit within $O(B^24)$ bit
operations per determinant. This deliberately loose bound applies to the
subresultant procedure actually called. With $2n$ determinant queries and
one field check, recovery takes
$ O((ell+1)(H+2)^24) " bit operations " $ <recovery-bound>
and outputs $O(ell+1)$ bits. No bound polynomial in the formula length alone
is assumed for an arbitrary supplied witness.

The converse in Lemma 4 and the predicate in @decode hold over all real factors.
The executable guarantee concerns the finite algebraic encoding just defined.
Since the feasibility equations have rational coefficients, a nonempty real
solution set has a real-algebraic point by real closed field transfer. This
fact does not assert polynomial witness length for the unrestricted problem.

Malformed source encodings map outside the target language. The canonical
occurring-variable representation is polynomially obtainable from ordinary
3-SAT. Together, the construction, equivalence, recovery and bounds prove
Theorem 1.

= Relation to previous work and limits <related>

The target is the factor-width formulation of Ciaperoni, Gionis and Mannila,
Equation (4) of @ciaperoni2024, with exact feasibility discussed in their
Section 4.3 and the complexity question in Section 9. Our input matrices
are integer and nonnegative; all factor variables remain unrestricted real.
This distinction matters because imposing extra factor conditions changes
the decision problem.

Identity factorizations and tensor-product representations are prior
ingredients. Wertz, Vandaele and Gillis give an identity construction in
Appendix B, Lemma 2 of @wertz2025. Gillis and coauthors give a face-splitting
and rank-one reshape formulation in Lemmas 2.3–2.4 of @gillis2026manifold.
The contribution here is the synchronization of all selector blocks,
calibration of their residual scales, and the multiplicative cycle.

Low-rank matrix signing and entrywise power factorization have their own
hardness results @gillis2026signing. In particular, Theorem 2.2 of that
paper establishes hardness for prescribed magnitudes of a single factor.
Two independent Hadamard factors admit additional magnitude freedom, so
that theorem alone does not establish the present result. Generic
identifiability of Hadamard–Hitchcock tensor decompositions
@oneto2025 likewise does not decide exact feasibility of every matrix.

Primary-literature searches through 15 September 2026 found no matching
hardness theorem for this unrestricted real two-factor model. Coverage
included the papers above, Hadamard factorization aliases, subset product,
product bases and generic Hadamard-rank results. Unindexed manuscripts,
exhaustive citation closure and overlooked implications of general
representation theorems remain outside that coverage. The claimed new
construction requires independent human assessment of correctness and novelty.

= Conclusion

Synchronized product-vector selectors convert exact subset product into
Hadamard feasibility at widths $2$ and $2K$. Their cycle gives a Karp
reduction from 3-SAT, and their left-factor directions provide witness
recovery for arbitrary valid factors. The result identifies a hardness
boundary with one rank bound fixed. It does not establish strong NP-hardness,
approximation hardness, membership of the unrestricted problem in NP,
or completeness for the existential theory of the reals.

#bibliography("references.bib", style: "ieee")

#pagebreak()
#set text(size: 10.5pt)
#set heading(numbering: "A.1.")
#counter(heading).update(0)
= Verification and reproducibility <reproduction>

== Evidence and its scope

The implementation was checked with Python 3.14.7, SymPy 1.14.0 and Z3 5.1.0.
The manuscript uses Typst 0.15.1. The prepared suite tests six source formulas
and performs eight recovery calls. A separately implemented verifier tests
29 distinct formulas, including 27 YES and two NO instances, and performs
109 recovery calls. Nine of these calls use algebraic gauges, including
negative roots, cubic roots and reducible defining polynomials. Four focused
calls reuse an existing source formula; they are not extra distinct instances.
The generated cases use seed 13013 and two through four occurring variables.
The largest tested target has 682 rows and 88 columns, with widths 2 and 44.

The verifier runs the actual candidate in fresh processes. It enumerates
source assignments and validates the actual matrix against the constructed
family before solving its subset-product coefficients by exact
meet-in-the-middle enumeration. It independently builds target factors,
checks every matrix entry, invokes recovery, and checks the returned
assignment directly. Variants include non-diagonal coordinate changes,
right-coordinate mixing, and signed row and column gauges.

The prepared target oracle instead uses Z3 Boolean-controlled linear prefix
equations. Its 32 standalone three-item checks agree with exhaustive
subset enumeration, with 16 YES and 16 NO cases. A separate 38-case
arithmetic check compares sign-corrected subresultant root counts with a
rational Sturm implementation. Scientific notation is rejected before
coefficient or endpoint conversion. The defining quartic real-factor oracle
is retained for tiny target examples; an unknown outcome is an error.

Both structural target NO oracles depend on Lemmas 2–4. Their finite
agreement cannot establish those lemmas. A separate reviewer inspected
the general proof and constructed further checks without importing the
candidate. These included an unrestricted local real escape query,
exact symbolic cycle identities, and full witnesses using repeated,
reducible defining polynomials and higher-degree coordinate perturbations.
The final review found no remaining repair requirement. This agent review
and the finite checks do not replace independent human expert verification.

== Files and commands

All paths below are relative to the repository root. The candidate and
contract are in #raw("campaigns/hadamard-decomposition/work/").
The files #raw("algorithm.py"), #raw("proof.md"), #raw("contract.md"),
#raw("preparation.md") and #raw("verification.md") describe the rule and its
checks. Current raw outputs are in #raw("campaigns/hadamard-decomposition/rounds/013/"):
#raw("literal-rational-prepared-check.txt"), #raw("literal-rational-check.txt"),
#raw("structural-oracle-check.txt") and #raw("arithmetic-check.txt").
The final review is #raw("campaigns/hadamard-decomposition/reviews/literal-rational/review.md").
Earlier evidence remains with its owning round or review.

From the repository root, run:
```sh
cd campaigns/hadamard-decomposition/work
python3 check.py --self-test
python3 check.py --oracle product-basis --candidate algorithm.py
python3 verify.py --candidate algorithm.py
typst compile manuscript.typ manuscript.pdf
```
The two candidate suites execute both maps. There are no configured solver,
subprocess or campaign timeouts. The finite input domains are declared in
#raw("cases.json") and #raw("verify.py"). To run the maps on supplied inputs:
```sh
python3 algorithm.py < source.json > target.json
python3 algorithm.py --extract < request.json > assignment.json
```
Here #raw("source.json") is a formula with keys #raw("n") and #raw("clauses").
The second input has keys #raw("source") and #raw("target_solution").
Its target solution uses the four factor matrices plus #raw("field"), exactly
as specified in #raw("contract.md"). Each coordinate is a dense list of literal
rational coefficients. These two command modes share no process state.
