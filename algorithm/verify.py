"""Finite independent checks; the target NO oracle uses the product-basis theorem."""
import argparse
from fractions import Fraction as Q
import itertools
import json
import math
from pathlib import Path
import random
import subprocess
import sys

sys.set_int_max_str_digits(0)


def invoke(path, payload, extract=False):
    result=subprocess.run([sys.executable,str(path)]+(['--extract'] if extract else []), input=json.dumps(payload),text=True,capture_output=True)
    if result.returncode:raise RuntimeError(result.stderr)
    return json.loads(result.stdout)


def subsets(values):
    result=[(1,())]
    for x in values:result=[(p,b+(False,)) for p,b in result]+[(p*x,b+(True,)) for p,b in result]
    return result


def product_solutions(values,T):
    half=len(values)//2;right={}
    for p,b in subsets(values[half:]):right.setdefault(p,[]).append(b)
    found=[]
    for p,b in subsets(values[:half]):
        if T%p==0:
            for tail in right.get(T//p,[]):
                found.append(b+tail)
                if len(found)==2:return found
    return found


def mul(a,b):
    out=[[Q(0) for _ in b[0]] for _ in a]
    for i,row in enumerate(a):
        for j,x in enumerate(row):
            if x:
                for c,y in enumerate(b[j]):
                    if y:out[i][c]+=x*y
    return out


def source_yes(s,a):
    return len(a)==s['n'] and all(type(x) is bool for x in a) and all(any(a[abs(l)-1]==(l>0) for l in c) for c in s['clauses'])


def decode_target(t):
    assert set(t)=={'matrix','budget'}
    a=t['matrix'];N=len(a[0]);s=math.isqrt(N);k=s//2
    assert k>=3 and s==2*k and s*s==N and t['budget']==2*s
    assert len(a)==N+k*(k-1)+s*(s-1)*(s-2)+6*k
    assert all(len(row)==N and all(type(v) is int and v>=0 for v in row) for row in a)
    for i,row in enumerate(a[:N]):assert row==[int(j==i) for j in range(N)]
    remaining=set(range(N))-{j for i in range(k) for j in (2*i+1,s+2*i)}
    expected={tuple(sorted((x,y))) for x in remaining for y in remaining if x<y and (x//s==y//s or x%s==y%s)}
    for i in range(k):expected.update(tuple(sorted((x,y))) for x in (2*i+1,s+2*i) for y in (2*i,s+2*i+1))
    actual=[]
    for row in a[N:-2*k]:
        nonzero=tuple(j for j,v in enumerate(row) if v)
        assert len(nonzero)==2 and all(row[j]==1 for j in nonzero);actual.append(nonzero)
    assert len(actual)==len(expected) and set(actual)==expected
    cells=[(2*i,s+2*i+1,2*i+1,s+2*i) for i in range(k)]
    for i,row in enumerate(a[-2*k:-k]):assert row==[int(j in cells[i]) for j in range(N)]
    values=[a[-k+i][s+2*i+1] for i in range(k)];T=a[-1][1]
    assert T>0 and all(v>0 for v in values)
    for i,row in enumerate(a[-k:]):
        d=dict(zip(cells[i],(1,values[i],1,values[i])))
        d.update(zip(cells[(i+1)%k],(1,T*T,T,T) if i==k-1 else (1,1,1,1)))
        assert row==[d.get(j,0) for j in range(N)]
    return values,T


def factors(t,choice):
    values,T=decode_target(t);s=2*len(values);N=s*s
    locations=[(j//s,j%s,Q(1)) for j in range(N)];h=Q(1)
    for i,take in enumerate(choice):
        locations[2*i+1]=(0,2*i+1,1/h) if take else (1,2*i,h)
        locations[s+2*i]=(1,2*i,h) if take else (0,2*i+1,1/h)
        if take:h*=values[i]
    assert h==T
    u=[];w=[]
    for row in t['matrix']:
        tensor={}
        for j,c in enumerate(row):
            if c:
                a,b,v=locations[j];tensor[a,b]=tensor.get((a,b),Q(0))+c*v
        a,b=next(pos for pos,v in sorted(tensor.items()) if v)
        right=[tensor.get((a,j),Q(0)) for j in range(s)]
        left=[tensor.get((j,b),Q(0))/right[b] for j in range(s)]
        assert all(left[i]*right[j]==tensor.get((i,j),0) for i in range(s) for j in range(s))
        u.append(left);w.append(right)
    v=[[Q(int(a==i)) for a,b,c in locations] for i in range(s)]
    z=[[Q(int(b==i))/c for a,b,c in locations] for i in range(s)]
    return [u,v,w,z]


def validate(t,fs):
    m,N=len(t['matrix']),len(t['matrix'][0]);s=math.isqrt(N)
    for a,r,c in zip(fs,(m,s,m,s),(s,N,s,N)):assert len(a)==r and all(len(row)==c for row in a)
    assert 2*s==t['budget']
    a,b=mul(fs[0],fs[1]),mul(fs[2],fs[3])
    assert all(a[i][j]*b[i][j]==t['matrix'][i][j] for i in range(m) for j in range(N))


def encode(fs):
    s=len(fs[0][0])
    return {'p':s,'q':s,'field':{'polynomial':[0,1],'interval':['-1','1']},**{key:[[[str(v)] for v in row] for row in a] for key,a in zip(('u1','v1','u2','v2'),fs)}}


def gauge(fs):
    u,v,w,z=[[row[:] for row in a] for a in fs]
    for left,right in ((u,v),(w,z)):
        for row in left:row[-1]+=row[0]
        right[0]=[a-b for a,b in zip(right[0],right[-1])]
        for row in left:row[0],row[1]=row[1],row[0]
        right[0],right[1]=right[1],right[0]
    for i in range(len(u)):
        c=Q(-2 if i%2 else 3);u[i]=[v*c for v in u[i]];w[i]=[v/c for v in w[i]]
    for j in range(len(v[0])):
        c=Q(-3 if j%2 else 2)
        for row in v:row[j]*=c
        for row in z:row[j]/=c
    return [u,v,w,z]


def algebraic(fs,kind):
    w=encode(fs)
    fields={'quadratic':([-2,0,1],['1','2']),'negative':([-2,0,1],['-2','-1']),'cubic':([-2,0,0,1],['1','2']),'repeated':([12,0,-12,0,3],['1','2'])}
    p,interval=fields[kind];w['field']={'polynomial':p,'interval':interval}
    # The polynomial shear and its inverse cancel identically over Q[t].
    for row,old in zip(w['u1'],fs[0]):row[-1]=[str(old[-1]),str(old[0])]
    for j in range(len(fs[1][0])):w['v1'][0][j]=[str(fs[1][0][j]),str(-fs[1][-1][j])]
    assert mul([[1,Q(7)],[0,1]],[[1,Q(-7)],[0,1]])==[[1,0],[0,1]]
    return w


def main(path):
    sources=[{'n':0,'clauses':[]}]+[{'n':1,'clauses':[list(c)]} for c in itertools.product((-1,1),repeat=3)]
    sources += [{'n':1,'clauses':[[1,1,1],[-1,-1,-1]]},{'n':1,'clauses':[[1,1,1],[-1,-1,-1],[1,-1,1]]},{'n':2,'clauses':[[1,2,-1]]},{'n':2,'clauses':[[1,1,-2],[-1,2,2]]},{'n':3,'clauses':[[1,2,3]]}]
    calls=irr=yes=no=0
    for index,source in enumerate(sources):
        t=invoke(path,source);items,T=decode_target(t);solutions=product_solutions(items,T)
        expected=any(source_yes(source,list(a)) for a in itertools.product((False,True),repeat=source['n']))
        assert bool(solutions)==expected
        yes+=expected;no+=not expected
        for selection in solutions:
            fs=factors(t,selection);transformed=gauge(fs)
            for variant in (fs,transformed,[transformed[2],transformed[3],transformed[0],transformed[1]]):
                validate(t,variant)
                result=invoke(path,{'source':source,'target_solution':encode(variant)},True)
                assert source_yes(source,result['assignment']);calls+=1
            if index==1:
                for kind in ('quadratic','negative','cubic','repeated'):
                    w=algebraic(transformed,kind)
                    result=invoke(path,{'source':source,'target_solution':w},True)
                    assert source_yes(source,result['assignment']);calls+=1;irr+=1
        print('case',index,'target',len(t['matrix']),len(t['matrix'][0]),'YES' if expected else 'NO',flush=True)
    for bad in ({},None,{'n':2,'clauses':[[1,1,1]]},{'n':10**5000,'clauses':[]}):assert invoke(path,bad)=={'invalid':True}
    print('PASS',len(sources),'distinct sources;',yes,'YES;',no,'NO;',calls,'recovery calls;',irr,'algebraic gauges; 4 malformed sources')
    print('Independent enumeration and exact matrix validation; structural NO depends on the frame theorem, not a general large-matrix solver.')


if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--candidate',type=Path,required=True);main(p.parse_args().candidate)
