# Executable rule contract

Source: JSON object with exactly `n` and `clauses`; n is the nonnegative count
of consecutively numbered occurring variables, and each clause is a list of
three nonzero signed integer literals. Repetitions are legal. Empty conjunction
uses n=0. A source witness is `{"assignment": [true, false, ...]}` and must
satisfy all clauses. Malformed sources map to `{"invalid": true}`, outside B.

Target: exactly `matrix` and `budget`; matrix is a nonempty rectangular array
of literal rational entries (JSON integers or numerator/denominator strings),
budget is a nonnegative integer. No individual ranks are part of the instance.

Public target solution: `p`, `q`, `field`, `u1`, `v1`, `u2`, `v2`.
Widths p,q are nonnegative and at most min(rows,columns), with p+q<=budget.
Matrix dimensions are m-by-p, p-by-n, m-by-q, q-by-n. Every coordinate is a
nonempty dense rational coefficient list evaluated at the same primitive root.
The field has `polynomial` (dense integer coefficients, ascending powers,
nonzero leading coefficient) and `interval` (two literal rational non-root
endpoints isolating exactly one distinct real root). Reducibility and repeated
roots are permitted. Empty width products are zero matrices. Validity requires
every entry of (u1*v1) Hadamard (u2*v2) to equal matrix exactly.

Default command: `python3 algorithm.py`, source JSON on stdin, target JSON on
stdout. Recovery: `python3 algorithm.py --extract`, stdin object with `source`
and `target_solution`, assignment on stdout. Fresh processes, deterministic
polynomial-time maps; no solver inside candidate. Errors exit nonzero.

The prepared oracle's internal scalar codec uses exact Z3 rational/root objects;
it converts these to the public common-primitive encoding before recovery.
Independent target validation checks dimensions, budget and all entry equations.
