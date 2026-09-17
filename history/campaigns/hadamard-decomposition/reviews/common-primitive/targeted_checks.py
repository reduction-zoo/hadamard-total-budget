"""Independent common-primitive witness checks; candidate subprocesses only."""
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
    theta=sp.symbols('theta')
    for minimal, interval in ((theta**5-2,['1','6/5']), (theta**2-2,['13/10','3/2'])):
        defining=-3*(theta**5-2)**2*(theta**2-2)
        shear=theta**4+theta**2/sp.Integer(3)+sp.Rational(1,7)
        G=sp.Matrix([[1,shear],[0,1]])
        Gi=sp.Matrix([[1,-shear],[0,1]])
        assert G*Gi==sp.eye(2)
        Ug=sp.Matrix(U)*G; Vg=Gi*sp.Matrix(V)
        Wg=sp.Matrix(W); Zg=sp.Matrix(Z)
        scale=theta+2; inverse=sp.invert(scale,minimal,theta)
        assert sp.rem(scale*inverse-1,minimal,theta)==0
        for j in range(Ug.cols):Ug[0,j]*=scale
        for j in range(Wg.cols):Wg[0,j]*=inverse
        # A formally nonzero addition vanishes only on the intended irreducible factor.
        Ug[2,1]+=minimal*theta**8
        product1=Ug*Vg; product2=Wg*Zg
        for i,row in enumerate(M):
            for j,value in enumerate(row):
                assert sp.rem(sp.expand(product1[i,j]*product2[i,j]-value),minimal,theta)==0
        def coefficients(v):
            p=sp.Poly(v,theta)
            return [str(p.nth(i)) for i in range(max(0,p.degree())+1)]
        fs={'field':{'polynomial':[int(sp.Poly(defining,theta).nth(i)) for i in range(13)],'interval':interval}}
        for name,matrix in zip(('u1','v1','u2','v2'),(Ug,Vg,Wg,Zg)):
            fs[name]=[[coefficients(matrix[i,j]) for j in range(matrix.cols)] for i in range(matrix.rows)]
        answer=invoke({'source':source,'target_solution':fs},True)
        assert answer=={'assignment':[truth]}
        print('PASS repeated/reducible negative-leading field; degree',sp.degree(minimal,theta),'root; degree-13 coordinates; truth',truth)
    if truth:
        def rational_matrix(matrix):return [[[str(v)] for v in row] for row in matrix]
        fs={name:rational_matrix(matrix) for name,matrix in zip(('u1','v1','u2','v2'),(U,V,W,Z))}
        fs['field']={'polynomial':[0,1],'interval':['-1','1']}
        assert U[0]==[1,0] and W[0]==[1,0,0,0,0,0,0,0]
        fs['u1'][0][0]=['1e4096'];fs['u2'][0][0]=['1e-4096']
        assert Q('1e4096')*Q('1e-4096')==1
        assert invoke({'source':source,'target_solution':fs},True)=={'assignment':[True]}
        print('CONFIRMED compressed-exponent witness accepted: 6-character coefficient has',Q('1e4096').numerator.bit_length(),'numerator bits')
