#import "report.typ": research-report
#show: research-report.with(
  title: "NP-hardness of Hadamard decomposition\nunder a total rank budget",
  date: "15 September 2026",
  status: "Working manuscript · Awaiting independent human expert review",
)
#set math.equation(numbering: "(1)")
#let rank = math.op("rank")
#let proof(body) = [*Proof.* #body #h(1fr) $square$]

#heading(numbering: none)[Abstract]
We study the minimum sum of the ranks of two real matrices whose entrywise
product is a prescribed rational matrix. We give a deterministic polynomial-time
reduction from 3-SAT to deciding whether this sum is at most an input budget.
The result holds for nonnegative integer input matrices and unrestricted-sign
real factors. A square identity block forces every feasible allocation of the
budget to have equal ranks. Additional pair-sum rows impose a partially specified
Cartesian frame while retaining two-choice selectors. Calibration and a cycle
of weighted rows encode subset product. The construction has a general converse
for every admissible rank allocation. A deterministic decoder recovers a
satisfying assignment from every valid decomposition encoded over one real
algebraic primitive element. We give explicit polynomial bit bounds and
separate the proof from finite computational checks.

= Introduction

Hadamard decomposition represents a matrix as the entrywise product of low-rank
matrices. Ciaperoni, Gionis and Mannila studied this representation for data
analysis and left the exact real feasibility problem's complexity unresolved
@ciaperoni2024. Subsequent numerical work explicitly compares decompositions
under a total rank budget @wertz2025. For a matrix with $mu$ rows and $N$ columns,
factors of widths $p,q$ use $(mu+N)(p+q)$ scalar parameters in their dense
parameterization. This makes the rank sum a natural representation cost.

For a rational matrix $M in QQ^(mu times N)$, define
$ cal(C)_0(M)=min_(M=A ⊙ B) (rank(A)+rank(B)), $ <cost>
where $A,B in RR^(mu times N)$ and $⊙$ denotes entrywise multiplication.
There are exactly two factors. Their entries may have arbitrary signs, and
rank zero is allowed; in particular, $cal(C)_0(0)=0$.
The decision input is $(M,b)$, where $b$ is a nonnegative integer in binary.
We ask whether $cal(C)_0(M)<=b$.

A hardness result with prescribed bounds on the two ranks would not by itself
settle this question. A matrix infeasible at one allocation could be feasible
at another allocation with the same sum. Our construction excludes all such
alternatives through equality in the rank-product bound.

#block(breakable: false)[
  *Theorem 1 (Main result).* Deciding $cal(C)_0(M)<=b$ is NP-hard under
  deterministic polynomial-time many-one reductions, even for nonnegative
  integer matrices $M$. A 3-SAT formula with $n$ occurring variables and $m$
  clauses maps to a matrix with a leading identity of order $s^2$ and budget
  $ K=max(3,2n+2m), quad s=2K, quad b=2s. $ <parameters>
  It is feasible exactly when the formula is satisfiable. Every feasible
  decomposition of the constructed matrix has both factor ranks equal to $s$.
  From every valid algebraically encoded decomposition, a deterministic
  algorithm recovers a satisfying assignment in time polynomial in the
  source length plus the supplied witness length.
] <main-theorem>

The reduction uses the standard Karp framework @karp1972. Prime exponents encode
3-SAT as subset product. The matrix construction supplies the discrete choices:
an incomplete Cartesian frame forces anchor directions while leaving two
orientations at each selector. Weighted rows make the product of the selected
integers equal a target. The frame, together with budget saturation, is the
mechanism that addresses arbitrary rank allocations.

= Budget saturation <budget-section>

A target witness can be written as
$ M=(U V) ⊙ (W Z), $ <factorization>
where the four matrix dimensions are $mu times p$, $p times N$, $mu times q$
and $q times N$, with $p+q<=b$. Expanding the ordinary products into rank-one
terms gives the familiar inequality $rank(M)<=p q$. This inequality and
identity examples are established ingredients of Hadamard decomposition
@ciaperoni2024 @wertz2025.

#block(breakable: false)[
  *Lemma 1 (Unique budget allocation).* Suppose $M$ has $s^2$ columns and
  contains $I_(s^2)$ as a row submatrix. Every decomposition satisfying
  @factorization with $p+q<=2s$ has $p=q=s$, and both ordinary products have
  rank exactly $s$.
]

#proof[
  The identity gives $rank(M)=s^2$. Consequently,
  $ s^2 <= rank(U V) rank(W Z) <= p q
      <= (p+q)^2/4 <= s^2. $ <saturation>
  Equality throughout forces $p+q=2s$, $p=q$, and both actual ranks to attain
  their respective widths. This also excludes zero widths and smaller budgets.
]

For orientation, @identity-figure shows the leading block of an actual
constructed YES instance. The extra rows used below constrain its possible
factorizations; the identity alone does not impose a Cartesian basis.

#figure(
  include "figures/identity.typ",
  caption: [Support plots for the leading identity rows of an exact rational
    factorization constructed from $F=(x_1 or x_1 or x_1)$. Here $K=4$,
    $s=8$ and $b=16$; $U_0,W_0$ denote the first 64 rows of $U,W$.
    Black cells mean nonzero entries, not unit values. All entries of the
    full $436 times 64$ factorization were checked exactly. The displayed
    crop illustrates saturation; it does not display the additional constraint
    rows. The matrix presentation follows Figures 1 and 3 of @ciaperoni2024.],
) <identity-figure>

= Construction <construction>

== Prime encoding

Let $F$ have $m$ clauses, each with three literals, allowing repetitions.
Number its occurring variables consecutively from $1$ to $n$; the empty
conjunction has $n=0$. Choose distinct primes $pi_v$ for variables and
$kappa_j$ for clauses. For each variable $v$ and truth value $e$, let
$c_(v,e,j)$ count its literal occurrences in clause $j$ made true by $e$.
Create the two assignment items
$ r(v,e)=pi_v product_(j=1)^m kappa_j^(c_(v,e,j)). $ <assignment-items>
Append the two slack items $kappa_j,kappa_j^2$ for each clause, and set
$ T=(product_(v=1)^n pi_v)(product_(j=1)^m kappa_j^4). $ <target>
Assignment items are ordered by variable, true before false, followed by
clause slack pairs. Pad with ones to obtain $K$ items $r_0,dots,r_(K-1)$
as in @parameters.

#block(breakable: false)[
  *Lemma 2 (Subset product).* A subset of the items has product $T$ if and
  only if $F$ is satisfiable. Its assignment-item choices recover a satisfying
  assignment.
]

#proof[
  The exponent of $pi_v$ forces exactly one of variable $v$'s assignment items.
  For a clause with $c$ true literal occurrences, its slack items can add
  exponent zero, one, two or three. Since $0<=c<=3$, exponent four is reachable
  exactly when $c>=1$. This proves both directions, including repeated literals.
  Padding by ones changes no constraint; the empty formula has $T=1$.
]

== The incomplete anchor grid

Set $s=2K$ and $N=s^2$. Index the columns of $M$ by pairs $(a,c)$ with
$0<=a,c<s$, in row-major order. Write $e_J$ for the unit row at index $J$.
For $0<=i<K$, name four indices
$ L_i=(0,2i), quad R_i=(1,2i+1), quad
  X_i=(0,2i+1), quad Y_i=(1,2i). $ <indices>
Call every index except the $X_i,Y_i$ an anchor. These are labels for the
construction; no coordinates of a future factorization are being assumed.
The anchor pattern appears in @frame-figure.

Begin $M$ with $I_N$. For every pair of anchors in the same grid row, append
their two-unit sum. Do the same for every pair in the same grid column.
Order these rows first by grid row, then by grid column, using lexicographic
pairs within each group. For each $i$, add four local pair rows:
$ e_(X_i)+e_(L_i), quad e_(X_i)+e_(R_i), quad
  e_(Y_i)+e_(L_i), quad e_(Y_i)+e_(R_i). $ <local-pairs>
Next append one calibration row per item,
$ e_(L_i)+e_(R_i)+e_(X_i)+e_(Y_i). $ <calibration>

#figure(
  include "figures/frame.typ",
  caption: [Construction indices for $K=4$. Solid cells are anchors; dots
    denote the remaining anchor indices. Pair-sum rows join every pair of
    anchors within a grid row or column. Dashed cells $X_i,Y_i$ have only
    the local pair constraints in @local-pairs before calibration and cycle
    constraints are added. The counts at the right explain why intersecting
    anchor cliques must use opposite factor sides. The grid is a schematic
    of index incidence, not a plot of matrix entries or a presupposed tensor
    coordinate system.],
) <frame-figure>

== Weighted cycle rows

Finally add one cycle row for each item. Its nonzero coefficients in the
ordered block $(L_i,R_i,X_i,Y_i)$ are
$ (1,r_i,1,r_i). $ <outgoing>
For $i<K-1$, its block $i+1$ is $(1,1,1,1)$. The final row instead uses
block zero with coefficients
$ (1,T^2,T,T). $ <closing>
Every omitted entry is zero. The two blocks are distinct since $K>=3$.
Set the output budget to $b=2s$.

The identity, anchor pairs, local pairs, calibrations and cycles give
$ mu=s^2+K(K-1)+s(s-1)(s-2)+6K $ <rows>
rows. The top two anchor rows contribute $K(K-1)$ pairs. The complete anchor
rows and the anchor columns each contribute $s(s-1)(s-2)/2$ pairs.
All entries of the resulting matrix are nonnegative integers.

= Structure of every feasible decomposition <structure>

== Product bases and pair sums

By Lemma 1, any feasible witness has widths $(s,s)$. A nonzero tensor of the
form $u ⊗ w$ is a product vector; its coordinate matrix has rank one.
Associate a row tensor $u_D ⊗ w_D$ to every row $D$, and a column tensor
$v_J ⊗ zeta_J$ to every column $J$. Their pairing equals $M_(D,J)$.
The tensor interpretation is consistent with the rank-one reshape formulation
in @gillis2026manifold.

The leading identity pairs $N$ row tensors with $N$ column tensors as $I_N$.
Since $dim(RR^s ⊗ RR^s)=N$, these families are dual bases. Let $z_J$
denote the identity row tensor at index $J$. Every later row with coefficients
$m_J$ therefore has the uniquely determined tensor $sum_J m_J z_J$.

Two independent product vectors have a product-vector sum exactly when they
share a left or a right factor line. If neither line is shared, linear maps on
the two independent pairs send their sum to a $2 times 2$ identity, contradicting
rank one. Sharing a line gives the converse by distributivity.

A clique of at least three independent product vectors with product-vector
pair sums has one common factor line. Fix a pair sharing a left line and having
distinct right lines. A third vector without that left line would have to share
both distinct right lines. This is impossible, so the third vector shares the
left line. The argument extends to the whole clique, and exchanging left and
right gives the other case. Its common side is unique, since sharing both
lines would make the vectors proportional.

== Forcing the anchor frame

#block(breakable: false)[
  *Lemma 3 (Anchor frame).* After possibly exchanging the two factor spaces,
  there are bases $alpha_0,dots,alpha_(s-1)$ and $beta_0,dots,beta_(s-1)$
  such that every anchor at index $(a,c)$ is a nonzero scalar multiple of
  $alpha_a ⊗ beta_c$. Each pair $X_i,Y_i$ occupies the two opposite
  corners between the left lines $alpha_0,alpha_1$ and right lines
  $beta_(2i),beta_(2i+1)$.
]

#proof[
  Every complete anchor row has $s$ members, and every anchor column has
  $s-1$ members. Their pair constraints and the preceding clique argument
  give each a common side. A complete row and a column intersect once.
  If their sides agreed, their common lines would coincide at that intersection.
  Their union would place $2s-2>s$ independent basis vectors on one factor
  line, in a subspace of dimension $s$. Thus their sides are opposite.

  Every complete row intersects every column. All complete rows consequently
  have the same orientation, and all columns the opposite orientation.
  A top anchor row has $K$ members and intersects each applicable column once.
  Equal orientation would confine $K+s-2>s$ independent vectors to dimension
  $s$, because $K>=3$. Both top rows therefore orient like the complete rows.
  After a possible global swap, write the anchor factors on the lines
  $alpha_a$ and $beta_c$ as in the statement.

  The $s$ anchors in a complete row are independent, forcing the $s$ right
  lines to be independent. In particular, each $L_i,R_i$ pair has distinct
  right lines. Suppose the two top left lines coincided. A common neighbor
  $X_i$ or $Y_i$ without that left line would have to share both distinct
  right lines of its anchors. Hence every local neighbor would have the
  common top left line. All $N$ basis vectors would then have left factors
  in the span of at most $s-1$ lines, contradicting their full span.

  The top two left lines are therefore distinct. A common neighbor of
  $L_i,R_i$ must occupy an off-diagonal corner between their two left and
  two right lines. The neighbors occupy different corners by independence.
  All identity tensors now use left factors from the $s$ anchor-row lines.
  Their full span forces those lines to be independent as well.
]

== Calibrated selectors

Absorb the scalar of $L_i$ into a vector $b_i$ on line $beta_(2i)$, and that
of $R_i$ into $c_i$ on line $beta_(2i+1)$. Put $alpha=alpha_0$ and
$beta=alpha_1$. The anchor tensors are
$ z_(L_i)=alpha ⊗ b_i, quad z_(R_i)=beta ⊗ c_i, $ <anchors>
and all $b_i,c_i$ together form a basis of the right factor space.
The calibration row and Lemma 3 leave exactly two orientations:
$ "Selected: " &z_(X_i)=t_i alpha ⊗ c_i, quad
                    z_(Y_i)=t_i^(-1) beta ⊗ b_i, \
  "Unselected: " &z_(X_i)=t_i beta ⊗ b_i, quad
                    z_(Y_i)=t_i^(-1) alpha ⊗ c_i, $ <orientations>
with $t_i!=0$. Indeed, if the two initial multipliers are $t_i,v_i$, the
calibration tensor has determinant $1-t_i v_i$ in its local coordinates.
Rank one forces $v_i=1/t_i$, without any sign assumption.

= Cycle equivalence <cycle>

Let $epsilon_i$ be one for a selected item and zero otherwise. A coefficient
block $(xi_L,xi_R,xi_X,xi_Y)$ at $(L_i,R_i,X_i,Y_i)$ reshapes as
$ mat(xi_L,xi_X t_i; xi_Y/t_i,xi_R) " (selected), " quad
  mat(xi_L,xi_Y/t_i; xi_X t_i,xi_R) " (unselected). " $ <local-matrices>
Define $h_i=1/t_i$ when selected and $h_i=t_i$ otherwise. The calibration,
outgoing and closing patterns have zero determinant and nonzero entries.
Their second-row to first-row ratios are respectively
$ (1,1,1,1)&↦ h_i, \
  (1,r_i,1,r_i)&↦ r_i^(epsilon_i)h_i, \
  (1,T^2,T,T)&↦ T h_i. $ <ratios>

#block(breakable: false)[
  *Lemma 4 (Cycle equivalence).* The constructed matrix has total rank cost
  at most $2s$ if and only if some subset of its items has product $T$.
]

#proof[
  A feasible decomposition has the frame and selectors just proved.
  Independent right blocks make a two-block cycle tensor rank one exactly
  when its two left lines agree. The ratios in @ratios therefore give
  $ h_(i+1)=r_i^(epsilon_i)h_i quad (0<=i<K-1), quad
    T h_0=r_(K-1)^(epsilon_(K-1))h_(K-1). $ <recurrence>
  Since all $h_i$ are nonzero, multiplication and cancellation yield
  $ product_(i=0)^(K-1) r_i^(epsilon_i)=T. $ <product>

  Conversely, suppose @product holds. Choose standard bases for both factor
  spaces, put $h_0=1$, and compute successive prefix products using
  @recurrence. Use $t_i=1/h_i$ when selected and $t_i=h_i$ otherwise.
  Place every anchor at its standard grid cell and place $X_i,Y_i$ at the
  corners and scales in @orientations. These $N$ vectors are a scaled
  permutation of the coordinate tensor basis. Their duals are consequently
  product vectors as well.

  Anchor pair sums share a factor. Local pair sums do also. Calibration rows
  have zero local determinant, and cycle rows have equal left-line ratios,
  including the final row by @product. Every prescribed row therefore has a
  rank-one reshape. Factoring each reshape supplies its two row vectors;
  factoring the dual basis supplies the column vectors. Their pairings reproduce
  every entry of $M$, including zeros, at widths $(s,s)$. All these constructed
  factor coordinates are rational.
]

Combining Lemmas 2 and 4 proves the decision equivalence in Theorem 1 for all
rank allocations. The next section supplies its executable witness recovery.

= Recovery and bit complexity <recovery>

== Decoding an arbitrary valid witness

The two identity rows $L_0,L_1$, with row-major indices $0,2$, share a factor
line on the oriented left side and have independent factors on the other side.
Test whether rows 0 and 2 of $U$ are proportional. If so, use $U$ for decoding;
otherwise use $W$. This determines the correct side even after a global factor
exchange. Call the chosen matrix $Q$.

For each assignment item $i$, test whether row $X_i$, of index $2i+1$, is
proportional to row $L_0$ in $Q$. By @orientations,
$ epsilon_i=1 ⇔ Q_(X_i,*) " is proportional to " Q_(L_0,*). $ <decode>
Read the true item in each variable pair. Lemma 2 guarantees one selected
assignment item per pair and satisfaction of every clause. The predicate depends
on factor lines, so arbitrary invertible coordinate changes and nonzero gauges
do not affect it.

== Exact algebraic zero tests

The finite witness encoding uses one real algebraic primitive element $theta$.
It supplies a nonzero dense integer polynomial $P$ and rational non-root
endpoints $a<b$ isolating exactly one distinct real root $theta$. Every factor
coordinate is a dense rational polynomial evaluated at that root. The defining
polynomial may be reducible or have repeated roots. Rational numerators and
denominators are written as integer literals, without compressed exponents.

For a nonzero vector $u$, choose its first nonzero coordinate $u_j$. Another
vector $v$ is proportional precisely when
$ u_j v_l-v_j u_l=0 quad "for every coordinate " l. $ <minors>
Every identity-factor row is nonzero. To test a polynomial $D$ at $theta$, use
$ D(theta)=0 ⇔ gcd(P,D) " has a root in " (a,b). $ <zero-test>
All roots of the gcd are roots of $P$, so the isolating premise makes its root
count zero or one. This avoids factorization of $P$ and construction of a new
number field.

The executable takes the last nonzero subresultant for the gcd, clears rational
denominators, removes multiplicities with the derivative gcd, and counts roots
with a sign-corrected subresultant Sturm sequence. Endpoint variation counts
omit zero evaluations. The required coefficient and algebraic-comparison bounds
are standard @emiris2008. The implementation calls SymPy's
#raw("Poly.subresultants") and #raw("sturm_amv(method=1)"); the latter uses
controlled remainders and the Sturm signs discussed in Section 2.4.3 of
@akritas2016. No feasibility solver runs inside construction or recovery.

== Polynomial bounds

Let $ell$ be the source bit length and $S=n+m+2$. The first $n+m$ primes have
magnitude $O(S log S)$ @rosser1962. Trial division generates them in polynomial
time. Counting all $3m$ literal occurrences gives $O(S log S)$ bits per item,
for $T$, and for $T^2$. The dimensions in @parameters and @rows imply
$ N=O(S^2), quad mu=O(S^3), quad
  "output bits"=O(S^6 log S). $ <size>
There are $O(S^5)$ dense entries. Schoolbook arithmetic and serialization fit
the conservative bounds
$ O((ell+2)^10) " forward bit operations, " quad
  O((ell+2)^7) " output bits. " $ <forward-time>
The rational completeness witness also has polynomial length: each $h_i$ is
an item subproduct, with $O(S^2 log S)$ bits under a loose bound.

Let $H$ be the total serialized witness length and set $D_0=H+2$.
Explicit dense degrees and literal coefficients bound input degrees and heights
by $O(D_0)$. Each determinant polynomial has degree $O(D_0)$ and height
$O(D_0^2)$ after clearing denominators. Sylvester determinant bounds give
$O(D_0^3)$ heights for normalized gcd data and $O(D_0^4)$ for the subsequent
sign-corrected subresultants. Square-free division preserves polynomial height.
These estimates use the controlled subresultant procedure actually called.

Conservatively allowing $O(D_0^3)$ rational coefficient operations per sequence
and $O(D_0^8)$ bits per intermediate numerator or denominator gives
$O(D_0^24)$ bit operations per zero test under schoolbook arithmetic. This is
a loose upper bound, not a performance estimate. Orientation detection, pivot
searches and @minors require $O((n+1)s)$ zero tests. Thus recovery takes
$ O((ell+2)^2 (H+2)^24) " bit operations " $ <recovery-time>
and outputs $O(ell+1)$ bits. Reading the witness and repeated coordinate parsing
are covered. No bound polynomial in source length alone is imposed on an
arbitrary supplied witness.

The converse holds over all real factors. Executable recovery concerns the
specified finite algebraic encoding. A nonempty real solution set of the rational
factorization equations has a real-algebraic point, by real closed field transfer;
this does not assert a polynomial certificate bound for arbitrary target inputs.
Malformed source strings map outside the target language. Canonical renaming of
occurring variables is polynomial-time. These observations complete Theorem 1.

= Related work and scope

The total rank budget and extremal identity constructions are prior results:
Theorem 1 and Appendices A–B of @wertz2025 study rank-product expressivity,
including optimization over the number of factors. Our problem keeps exactly
two factors and tests a prescribed matrix. Extremal identity realizations do
not impose the extra anchor and cycle constraints needed in the reduction.

The rank-one reshape viewpoint is also prior work @gillis2026manifold.
Hardness of matrix signing and entrywise powers @gillis2026signing ties
factor magnitudes or coordinates; dropping those restrictions does not supply
a converse for independent Hadamard factors. Generic Hadamard–Hitchcock
identifiability @oneto2025 addresses different hypotheses and does not decide
exact membership for these specially constrained matrices.

The new construction combines the incomplete anchor frame with two-factor
budget saturation. The selectors and cycle encode the source choices; the frame makes their
converse valid under every allocation allowed by the total budget. Primary-literature searches through 15 September 2026 found
no matching total-budget hardness theorem within the reviewed coverage.
Unindexed manuscripts, exhaustive citation closure and overlooked implications
of broader representation results remain outside that coverage.

The result concerns exact minimum rank sum. It establishes neither approximation
hardness nor strong NP-hardness, hardness for a variable number of factors,
or NP membership for unrestricted target inputs. Both ranks grow with the source.
The nominal parameter count motivating @cost does not measure minimal bit
storage, statistical generalization, or typical training behavior. Independent
human assessment of correctness and novelty remains necessary.

#bibliography("references.bib", style: "ieee")

#pagebreak()
#set text(size: 10.5pt)
#set heading(numbering: "A.1.")
#counter(heading).update(0)
= Verification and reproducibility

== Evidence and limitations

The implementation uses Python 3.14.7 and SymPy 1.14.0. Prepared tests use
Z3 5.1.0; this document uses Typst 0.15.1. The generic target oracle enumerates
all unordered legal rank allocations and solves their defining quartic equations.
Swapping factors makes this enumeration complete. An unknown outcome is an error,
not a NO answer. Its hand-verifiable checks cover zero, rank-one and identity
cases, algebraic witnesses, invalid products and budget violations.

The prepared suite injects six formulas and makes eight recovery calls, using
both factor orders. A separately implemented verifier checks fourteen distinct
formulas, twelve YES and two NO, and makes seventy recovery calls, including
four algebraic gauges. Cases include all eight sign patterns of a one-variable
clause, contradictory repeated unit clauses, and mixed cases with up to three
variables and $K<=8$. The largest target has 3720 rows and 256 columns.

For these larger outputs, each checker validates the entire matrix against the
frame family before solving its extracted subset-product coefficients. The
prepared checker uses Boolean-controlled linear prefix equations in Z3. The
other uses meet-in-the-middle enumeration and exhaustive source assignments.
Both construct target factors independently of the candidate and check all
matrix entries exactly before invoking recovery in a fresh process. Their
structural NO conclusions depend on Lemmas 1–4; agreement of finite oracles
does not prove those lemmas.

Witness variants include alternative subsets, coordinate changes mixing active
and frame directions, signed row and column gauges, and entire-factor exchange.
Algebraic tests use positive and negative quadratic roots, a cubic root and a
repeated defining polynomial. A separate reviewer checked the general proof
and built further full witnesses without importing candidate implementations.
Those checks used negative prefix parameters, dense coordinate changes, an
isolated fifth root with a reducible repeated defining polynomial, and degree-14
coordinate representatives, in both factor orders. The review requested no
repair. Agent review and finite tests do not replace human expert verification.

== Artifacts and commands

From the repository root, the current artifacts are under
#raw("campaigns/hadamard-total-budget/work/"). They include #raw("algorithm.py"),
#raw("contract.md"), #raw("proof.md"), #raw("preparation.md"), #raw("verification.md"),
and this manuscript. Raw checks are under #raw("rounds/001/") in the same
campaign: #raw("probe-repaired.txt"), #raw("prepared-check-repaired.txt"),
#raw("independent-check.txt") and #raw("figure-check.txt"). Independent review
and its own checks are under #raw("reviews/native/"). The selector-cycle mechanism and algebraic zero-test implementation originate
in the preceding fixed-width campaign, #raw("campaigns/hadamard-decomposition/");
the allocation-forcing frame is the extension proved here. Earlier failures
remain with their owning round. Run:
```sh
cd campaigns/hadamard-total-budget/work
python3 check.py --self-test
python3 check.py --oracle frame --candidate algorithm.py
python3 verify.py --candidate algorithm.py
python3 figures/build.py
typst compile manuscript.typ manuscript.pdf
```
All domains are finite and explicit. There are no configured solver, subprocess
or campaign timeouts. The two executable maps are:
```sh
python3 algorithm.py < source.json > target.json
python3 algorithm.py --extract < request.json > assignment.json
```
The source has keys #raw("n") and #raw("clauses"). The target has
#raw("matrix") and #raw("budget"). Recovery receives #raw("source") and
#raw("target_solution"); the latter includes #raw("p"), #raw("q"), the four
factor matrices and #raw("field"), using the common-primitive encoding in
#raw("contract.md"). Construction and recovery share no process state.
