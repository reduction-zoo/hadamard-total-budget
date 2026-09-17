"""Build the paper's support plots from one actual candidate output."""
import json
from pathlib import Path
import subprocess
import sys
from fractions import Fraction
import sympy as sp

work=Path(__file__).resolve().parent.parent
sys.path.insert(0,str(work))
from check import exact,target_witness_valid
from product_basis_oracle import solve
from verify import mul

source={'n':1,'clauses':[[1,1,1]]}
target=json.loads(subprocess.run([sys.executable,str(work/'algorithm.py')],input=json.dumps(source),text=True,capture_output=True,check=True).stdout)
witness=solve(target)
assert target_witness_valid(target,witness)
factors=[]
for key in ('u1','v1','u2','v2'):
    factors.append([[Fraction(exact(x).numerator_as_long(),exact(x).denominator_as_long()) for x in row] for row in witness[key]])
a=mul(factors[0],factors[1]);b=mul(factors[2],factors[3]);m=target['matrix']
assert all(a[i][j]*b[i][j]==m[i][j] for i in range(len(m)) for j in range(len(m[0])))
assert sp.Matrix(a).rank()==2 and sp.Matrix(b).rank()==8
assert len(m)==52 and len(m[0])==16
result={name:[[int(x!=0) for x in row] for row in matrix] for name,matrix in [('a',a),('b',b),('m',m)]}
Path(__file__).with_name('supports.json').write_text(json.dumps(result))
print('PASS figure data: actual source F=(x1 or x1 or x1); 52x16 target; ranks A=2, B=8; all 832 entry products exact; plots show support only.')
