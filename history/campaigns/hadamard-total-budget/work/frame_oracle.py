from fractions import Fraction as Q
import itertools
import math
import z3


def parameters(t):
    assert set(t)=={'matrix','budget'}
    a=t['matrix'];n=len(a[0]);s=math.isqrt(n);k=s//2
    assert s==2*k and k>=3 and n==s*s and t['budget']==2*s
    assert len(a)==s*s+k*(k-1)+s*(s-1)*(s-2)+6*k
    assert all(len(row)==n and all(type(v) is int and v>=0 for v in row) for row in a)
    for i in range(n):assert all(v==int(i==j) for j,v in enumerate(a[i]))
    anchors={r*s+c for r in range(s) for c in range(s) if r>=2 or r==c%2}
    edges=set()
    for group in ([j for j in anchors if j//s==r] for r in range(s)):
        edges.update(tuple(sorted(e)) for e in itertools.combinations(group,2))
    for group in ([j for j in anchors if j%s==c] for c in range(s)):
        edges.update(tuple(sorted(e)) for e in itertools.combinations(group,2))
    for i in range(k):edges.update(tuple(sorted((x,y))) for x in (2*i+1,s+2*i) for y in (2*i,s+2*i+1))
    found=[]
    for row in a[n:-2*k]:
        support=tuple(j for j,v in enumerate(row) if v)
        assert len(support)==2 and all(row[j]==1 for j in support)
        found.append(support)
    assert len(found)==len(edges) and set(found)==edges
    blocks=[(2*i,s+2*i+1,2*i+1,s+2*i) for i in range(k)]
    for i,row in enumerate(a[-2*k:-k]):assert all(v==int(j in blocks[i]) for j,v in enumerate(row))
    items=[a[-k+i][s+2*i+1] for i in range(k)];target=a[-1][1]
    assert target>0 and all(v>0 for v in items)
    for i,row in enumerate(a[-k:]):
        expected=dict(zip(blocks[i],(1,items[i],1,items[i])))
        expected.update(zip(blocks[(i+1)%k],(1,target*target,target,target) if i==k-1 else (1,1,1,1)))
        assert all(v==expected.get(j,0) for j,v in enumerate(row))
    return items,target


def witness(t,chosen):
    items,target=parameters(t);s=2*len(items);n=s*s
    assert math.prod(v for v,b in zip(items,chosen) if b)==target
    cells=[(j//s,j%s) for j in range(n)];scales=[Q(1)]*n;h=Q(1)
    for i,b in enumerate(chosen):
        x=2*i+1;y=s+2*i;ti=1/h if b else h
        if not b:cells[x],cells[y]=cells[y],cells[x]
        scales[x],scales[y]=ti,1/ti
        if b:h*=items[i]
    u=[];w=[]
    for row in t['matrix']:
        tensor=[[Q(0)]*s for _ in range(s)]
        for j,c in enumerate(row):
            if c:
                a,b=cells[j];tensor[a][b]+=c*scales[j]
        a,b=next((a,b) for a in range(s) for b in range(s) if tensor[a][b])
        left=[tensor[r][b] for r in range(s)];right=[x/left[a] for x in tensor[a]]
        assert all(left[r]*right[c]==tensor[r][c] for r in range(s) for c in range(s))
        u.append(left);w.append(right)
    v=[[Q(int(r==a))/scale for (a,b),scale in zip(cells,scales)] for r in range(s)]
    z=[[Q(int(c==b)) for a,b in cells] for c in range(s)]
    return {'p':s,'q':s,**{key:[[z3.RealVal(str(v)).sexpr() for v in row] for row in matrix] for key,matrix in zip(('u1','v1','u2','v2'),(u,v,w,z))}}


def solve(t):
    items,target=parameters(t);k=len(items)
    b=[z3.Bool(f'item_{i}') for i in range(k)];h=[z3.Real(f'h_{i}') for i in range(k+1)]
    solver=z3.SolverFor('QF_LRA');solver.add(h[0]==1,h[-1]==target)
    solver.add([h[i+1]==z3.If(b[i],items[i]*h[i],h[i]) for i in range(k)])
    result=solver.check();assert result in (z3.sat,z3.unsat),result
    if result==z3.unsat:return None
    return witness(t,[z3.is_true(solver.model().eval(v,model_completion=True)) for v in b])
