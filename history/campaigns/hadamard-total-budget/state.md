# Total-budget Hadamard campaign

Status: ready_for_expert_review. [Fixed question](question.md).
Budget: 40 rounds authorized; 1 started and completed, 39 unstarted.
Result: a candidate deterministic 3-SAT reduction to C0(M)<=b, including
polynomial-time recovery from every valid common-primitive encoded witness.
[Algorithm](work/algorithm.py) · [Proof](work/proof.md) ·
[English manuscript PDF](work/manuscript.pdf) · [Typst source](work/manuscript.typ).

The construction uses s=2K, identity order s^2 and budget 2s=4K. Every feasible
allocation must be (s,s); the incomplete anchor frame preserves the selectors
and multiplicative cycle. This handles all allocations and does not merely
reinterpret the prior fixed-width theorem. Input matrices are nonnegative
integer, while factors remain arbitrary-sign real. No approximation hardness,
variable-number-of-factors hardness or unrestricted NP-membership claim.

| Round | Mechanism | Result |
|---|---|---|
| [001](rounds/001/round.md) | Balanced saturation and incomplete Cartesian frame | Complete rule; both suites pass; native review advances; manuscript inspected |

[Preparation](work/preparation.md): six sources/eight recoveries.
[Independent verification](work/verification.md): fourteen distinct sources,
twelve YES and two NO, seventy recoveries including four algebraic gauges.
Standalone checks: eight full frame witnesses and fifteen allocation boundaries.
Large target NO decisions rely on the general frame theorem, not an unrestricted
quartic-solver result. [Native review](reviews/native/review.md): advance, with
two independently constructed adversarial algebraic witnesses, no repair request,
and explicit novelty-coverage limits. Human correctness/novelty review remains.

Writing: nine English Typst pages, two vector matrix figures, all pages visually
inspected after compilation. The current algorithm is unchanged since review;
editorial notation and figure changes preserve its theorem.

Stop exploration because the complete rule passed review and writing, not because
the 40-round budget was exhausted. Next action: independent human expert review.
No publication, production integration or other-repository changes performed.

Experience extraction: new shared entries 1; updated 0; pending 0.
[Balanced Hadamard frame allocation](../../research/experience/balanced-hadamard-frame-allocation.md)
was saved on 2026-09-15 after explicit user authorization. Its premises, proof,
review status and provenance are linked to [round 001](rounds/001/round.md).
Time/token totals unavailable.
