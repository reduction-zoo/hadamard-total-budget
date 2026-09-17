"""Independent local proof checks and cubic-gauged recovery; no candidate imports."""
from fractions import Fraction as Q
import json
from pathlib import Path
import subprocess
import sys
import z3
import sympy as sp

CANDIDATE = Path(__file__).resolve().parents[2] / 'work' / 'algorithm.py'

def invoke(payload, extract=False):
    p = subprocess.run([sys.executable, str(CANDIDATE)] + (['--extract'] if extract else []), input=json.dumps(payload), text=True, capture_output=True)
    assert p.returncode == 0, p.stderr
    return json.loads(p.stdout)

# Normalized anchors e0 tensor f0 and e1 tensor f1, allowing a third right coordinate.
x = [[z3.Real(f'x{i}{j}') for j in range(3)] for i in range(2)]
def rank_one(a):
    return [a[0][j]*a[1][k] == a[0][k]*a[1][j] for j in range(3) for k in range(j+1,3)]
s = z3.SolverFor('QF_NRA')
s.add(rank_one(x))
for i,j in ((0,0),(1,1)):
    a = [r[:] for r in x]; a[i][j] += 1
    s.add(rank_one(a))
s.add(z3.Or([v != 0 for row in x for v in row]))
corner_a = z3.And(x[0][1] != 0, *[x[i][j] == 0 for i in range(2) for j in range(3) if (i,j)!=(0,1)])
corner_b = z3.And(x[1][0] != 0, *[x[i][j] == 0 for i in range(2) for j in range(3) if (i,j)!=(1,0)])
s.add(z3.Not(z3.Or(corner_a, corner_b)))
assert s.check() == z3.unsat
print('PASS normalized common-neighbor escape query: UNSAT, unrestricted real coordinates')

# Independent symbolic computation of calibration and all six cycle ratios.
t,u,r,T = sp.symbols('t u r T', nonzero=True)
assert sp.Matrix([[1,t],[u,1]]).det() == 1-t*u
for selected in (False,True):
    for a,b,c,d,expected in ((1,1,1,1,1/t if selected else t), (1,r,1,r,r/t if selected else t), (1,T*T,T,T,T/t if selected else T*t)):
        A = sp.Matrix([[a,c*t],[d/t,b]]) if selected else sp.Matrix([[a,d/t],[c*t,b]])
        assert sp.simplify(A.det()) == 0
        assert sp.simplify(A[1,0]/A[0,0]-expected) == 0
print('PASS calibration determinant and six symbolic cycle ratios')

# Both source truth orientations; hard-coded prime-item choices, independent tensor basis.
for truth in (False,True):
    source = {'n':1,'clauses':[[1 if truth else -1]*3]}
    target = invoke(source)
    M=target['matrix']; assert len(M)==52 and len(M[0])==16
    chosen = [truth,not truth,True,False]
    items = [54,2,3,9] if truth else [2,54,3,9]
    coords=[]; h=Q(1)
    for i,(take,item) in enumerate(zip(chosen,items)):
        coords.extend([(0,2*i,Q(1)),(1,2*i+1,Q(1))])
        coords.extend([(0,2*i+1,1/h),(1,2*i,h)] if take else [(1,2*i,h),(0,2*i+1,1/h)])
        if take: h*=item
    assert h==162
    U=[];W=[]
    for row in M:
        a=[[Q(0)]*8 for _ in range(2)]
        for coefficient,(i,j,c) in zip(row,coords): a[i][j]+=coefficient*c
        j=next(j for j in range(8) if a[0][j] or a[1][j])
        left=[a[0][j],a[1][j]];i=0 if left[0] else 1
        right=[c/left[i] for c in a[i]]
        assert all(left[i]*right[j]==a[i][j] for i in range(2) for j in range(8))
        U.append(left);W.append(right)
    V=[[Q(i==a)/c for a,b,c in coords] for i in range(2)]
    Z=[[Q(j==b) for a,b,c in coords] for j in range(8)]
    for i,row in enumerate(M):
        for j,value in enumerate(row):
            assert sum(U[i][a]*V[a][j] for a in range(2))*sum(W[i][b]*Z[b][j] for b in range(8))==value
    # Shear by theta=cuberoot(2); certify inverse identity symbolically.
    theta=sp.symbols('theta')
    G=sp.Matrix([[1,theta],[0,1]]); Gi=sp.Matrix([[1,-theta],[0,1]])
    assert G*Gi==sp.eye(2)
    Ug=sp.Matrix(U)*G; Vg=Gi*sp.Matrix(V)
    def scalar(v):
        p=sp.Poly(v,theta);a=p.nth(1);b=p.nth(0)
        if a==0:
            return str(b.p) if b.q==1 else f'(/ {b.p} {b.q})'
        y=sp.symbols('y');q=sp.Poly((y-b)**3-2*a**3,y).clear_denoms()[1]
        return {'polynomial':[int(q.nth(i)) for i in range(4)],'root':1}
    fs={'u1':[[scalar(v) for v in Ug.row(i)] for i in range(Ug.rows)],'v1':[[scalar(v) for v in Vg.row(i)] for i in range(Vg.rows)],'u2':[[scalar(v) for v in row] for row in W],'v2':[[scalar(v) for v in row] for row in Z]}
    answer=invoke({'source':source,'target_solution':fs},True)
    assert answer=={'assignment':[truth]}
    print('PASS full rational factor product and cubic-algebraic shear recovery:', truth)
print('All targeted checks passed. These are local symbolic and finite execution checks, not a proof of global soundness or runtime.')
