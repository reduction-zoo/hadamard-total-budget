"""Independent literal-rational boundary checks, without candidate imports."""
from fractions import Fraction as Q
import json
from pathlib import Path
import subprocess
import sys
import sympy as sp

CANDIDATE = Path(__file__).resolve().parents[2] / 'work' / 'algorithm.py'
def invoke(payload, extract=False):
    p = subprocess.run([sys.executable, str(CANDIDATE)] + (['--extract'] if extract else []), input=json.dumps(payload), text=True, capture_output=True)
    assert p.returncode == 0, p.stderr
    return json.loads(p.stdout)

# Both source truth orientations; hard-coded prime-item choices, independent tensor basis.
for truth in (True,):
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
    def rational_matrix(matrix):return [[[str(v)] for v in row] for row in matrix]
    fs={name:rational_matrix(matrix) for name,matrix in zip(('u1','v1','u2','v2'),(U,V,W,Z))}
    fs['field']={'polynomial':[0,1],'interval':['-02/03','0005/07']}
    assert U[0]==[1,0] and W[0]==[1,0,0,0,0,0,0,0]
    fs['u1'][0][0]=['-3/2'];fs['u2'][0][0]=['-2/3']
    assert Q('-3/2')*Q('-2/3')==1
    assert invoke({'source':source,'target_solution':fs},True)=={'assignment':[True]}
    print('PASS valid signed literal fractions and noncanonical leading zeros in endpoints')
    for bad in ('1e4096','1.0','(1/2)'):
        for location in ('coefficient','endpoint'):
            modified=json.loads(json.dumps(fs))
            if location=='coefficient':modified['u1'][0][0]=[bad]
            else:modified['field']['interval'][1]=bad
            p=subprocess.run([sys.executable,str(CANDIDATE),'--extract'],input=json.dumps({'source':source,'target_solution':modified}),text=True,capture_output=True)
            assert p.returncode!=0 and 'Expected a literal integer or numerator/denominator' in p.stderr
            print('PASS rejected',repr(bad),'at',location,'through literal grammar')
