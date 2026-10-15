# Testing foundation

The generic target oracle enumerates every unordered pair 0<=p<=q<=min(m,n)
with p+q<=budget and solves the defining quartic factor equations in Z3 QF_NRA.
Swapping factors proves the unordered enumeration complete. A target is NO
only after every such query returns UNSAT. Unknown is an explicit failure.
This oracle is exact but intended for tiny targets; no practical polynomial
runtime is claimed. No timeouts or approximate optimizers are configured.

Source decisions use Z3 SAT and are cross-checked by exhaustive assignments.
Rational target witnesses are checked with exact Fraction products; algebraic
ones with exact Z3 algebraic arithmetic, independently of the solver constraints.
The public witness codec and source checks reuse the prior campaign's tested
utility logic by direct adaptation, with the changed budget predicate explicit.

Command: `python3 campaigns/hadamard-total-budget/work/check.py --self-test`.
[Raw output](evidence/preparation/self-test.txt): six source cases, seven
hand-verifiable target cases (zero budget, rank-one, rank-two identity), an
irrational witness and an invalid product, over-budget witnesses, and three
faulty subprocess fixtures (malformed target, decision mismatch, bad recovery).
All pass with Z3 5.1.0. No candidate has yet been checked. These tests cover the
definition, not a proposed reduction or the large instances it may produce.

Before candidate injection, the inherited large three-variable test instances
were replaced with hand-verifiable cases of K<=8 (s<=16), retaining six cases
with four YES and two NO. The quadratic identity increases dense target size;
this finite resource choice changes no oracle predicate or acceptance criterion.
The revised suite self-test passes in
[evidence/preparation/bounded-self-test.txt](evidence/preparation/bounded-self-test.txt).

The explicit `--oracle frame` mode checks the full returned matrix against the
candidate frame family, extracts its integer item coefficients, and solves
Boolean-controlled linear prefix equations with Z3. It builds exact rational
witnesses and checks every target entry. Its NO conclusion depends on the general
frame theorem in proof.md; it is not an independent proof of that theorem or a
replacement for the generic quartic oracle on arbitrary matrices. An unsupported
matrix fails explicitly. The initial frame witness emitter used fraction strings
where the internal codec required SMT rational expressions; the saved failure
and repaired output are in round 001. The public literal-rational codec is unchanged.

Current candidate check passed:
`python3 campaigns/hadamard-total-budget/work/check.py --oracle frame --candidate
campaigns/hadamard-total-budget/work/algorithm.py`.
[Raw output](../rounds/001/prepared-check-repaired.txt): six injected sources,
eight recovery calls, with both factor orders of every obtained YES witness.
The eight K=3 construction witnesses and one subset-product NO are checked in
[probe-repaired.txt](../rounds/001/probe-repaired.txt).
