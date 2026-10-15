# 3-SAT to total-budget Hadamard complexity

This independent archive contains the completed candidate reduction, its written
proof, executable construction and recovery, and all retained campaign files.
Status: **ready for expert review**, based on the original agent assessment.
Migration is not a new correctness, novelty or formal-verification result.

## Read and review

1. Read the [fixed question](history/campaigns/hadamard-total-budget/question.md).
2. Review the [paper](paper/manuscript.pdf), [proof](paper/proof.md),
   [algorithm](algorithm/algorithm.py) and [encoding contract](algorithm/contract.md).
3. Inspect [verification coverage](algorithm/verification.md) and the
   [original state and round index](history/campaigns/hadamard-total-budget/state.md).
4. Follow the [history index](history/README.md) for failed approaches,
   counterexamples, independent reviews and supporting research records.

Finite checks do not prove correctness for all inputs. This archive does not
claim the local Lean certification available in the separate NMF archive.
The source and target semantics remain those of the fixed question.

## Reproduce

Use Python 3.12 and uv from this repository root:

```sh
uv sync --locked
uv run --locked python algorithm/check.py --self-test
uv run --locked python algorithm/check.py --candidate algorithm/algorithm.py --oracle frame
uv run --locked python algorithm/verify.py --candidate algorithm/algorithm.py
```

The forward command reads a source JSON instance on stdin and writes a target.
`--extract` reads `source` and `target_solution` and writes the recovered output.
The contract specifies the exact domains and supported special answers.
The finite suites may be expensive; inspect their declared domains before running.
Generated replay outputs belong in the live directories, not the history snapshot.
Current migration checks are recorded in [evidence](evidence/README.md).

Rebuild the manuscript with `typst compile paper/manuscript.typ paper/manuscript.pdf`.
Historical paper commands retain their original paths; the commands above are the
current entry points. No sibling research repository or Codex session is needed.

## Provenance

The retained files were imported from `reduction-research/campaigns/hadamard-total-budget`.
The history snapshot preserves original bytes, excluding dependency/build caches,
Python bytecode and OS metadata. No missing transcripts or intermediate versions
were reconstructed. The source campaign remains intact. Git history starts with
this import of the retained campaign files. The public archive is
[hadamard-total-budget](https://github.com/isPANN/hadamard-total-budget). Public availability does not change the review status.
