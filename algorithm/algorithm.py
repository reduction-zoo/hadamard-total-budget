import json
import math
import re
from fractions import Fraction
import sys

import sympy as sp
from sympy.polys.subresultants_qq_zz import sturm_amv

sys.set_int_max_str_digits(0)


def primes(count):
    result=[]
    candidate=2
    while len(result)<count:
        if all(candidate%p for p in result if p<=math.isqrt(candidate)):
            result.append(candidate)
        candidate+=1
    return result


def subset_product(source):
    n=source['n'];clauses=source['clauses'];m=len(clauses)
    ps=primes(n+m);items=[]
    for v in range(1,n+1):
        for truth in (True,False):
            number=ps[v-1]
            for j,clause in enumerate(clauses):
                number*=ps[n+j]**sum(abs(l)==v and (l>0)==truth for l in clause)
            items.append(number)
    for j in range(m):items.extend((ps[n+j],ps[n+j]**2))
    target=math.prod(ps[:n])*math.prod(p**4 for p in ps[n:])
    items.extend([1]*max(0,3-len(items)))
    return items,target


def construct(source):
    items,target=subset_product(source);k=len(items);s=2*k;size=s*s
    rows=[[int(i==j) for j in range(size)] for i in range(size)]
    anchors=[(r,c) for r in range(s) for c in range(s) if r>=2 or r==0 and c%2==0 or r==1 and c%2==1]
    for groups in ([[r*s+c for r,c in anchors if r==a] for a in range(s)],[[r*s+c for r,c in anchors if c==b] for b in range(s)]):
        for group in groups:
            for i in range(len(group)):
                for j in range(i+1,len(group)):
                    row=[0]*size;row[group[i]]=row[group[j]]=1;rows.append(row)
    for i in range(k):
        for x in (2*i+1,s+2*i):
            for anchor in (2*i,s+2*i+1):
                row=[0]*size;row[x]=row[anchor]=1;rows.append(row)
    def block(i,values,row):
        for j,value in zip((2*i,s+2*i+1,2*i+1,s+2*i),values):row[j]=value
    for i in range(k):
        row=[0]*size;block(i,[1]*4,row);rows.append(row)
    for i,r in enumerate(items):
        row=[0]*size;block(i,[1,r,1,r],row)
        block((i+1)%k,[1,target*target,target,target] if i==k-1 else [1]*4,row);rows.append(row)
    return {'matrix':rows,'budget':2*s}


theta=sp.Symbol('theta')


def rational(value):
    if type(value) is int:return Fraction(value)
    if not isinstance(value,str) or re.fullmatch(r'-?[0-9]+(?:/[0-9]+)?',value) is None:
        raise ValueError('Expected a literal integer or numerator/denominator')
    return Fraction(value)


def polynomial(coefficients):
    if not isinstance(coefficients,list) or not coefficients:raise ValueError('Expected dense rational coefficients')
    values=[rational(c) for c in coefficients]
    return sp.Poly.from_list([sp.Rational(c.numerator,c.denominator) for c in reversed(values)],theta,domain=sp.QQ)


def root_count(p,left,right):
    if p.degree()<=0:return 0
    p=p.clear_denoms(convert=True)[1].primitive()[1]
    common=p.subresultants(p.diff())[-1]
    p=p.exquo(common).clear_denoms(convert=True)[1]
    sequence=[sp.Poly(q,theta) for q in sturm_amv(p.as_expr(),p.diff().as_expr(),theta,method=1)]
    def variations(point):
        signs=[sp.sign(q.eval(point)) for q in sequence]
        signs=[s for s in signs if s]
        return sum(a!=b for a,b in zip(signs,signs[1:]))
    return variations(left)-variations(right)


def extract(source,witness):
    field=witness['field'];cs=field['polynomial']
    if set(field)!={'polynomial','interval'} or len(cs)<2 or any(type(c) is not int for c in cs) or not cs[-1]:
        raise ValueError('Expected a dense integer defining polynomial')
    p=polynomial(cs);interval=field['interval']
    if len(interval)!=2:raise ValueError('Expected an isolating interval')
    left,right=[sp.Rational(str(rational(v))) for v in interval]
    if left>=right or p.eval(left)==0 or p.eval(right)==0 or root_count(p,left,right)!=1:
        raise ValueError('Interval must isolate one distinct real root, with non-root endpoints')
    def zero(d):return root_count(p.subresultants(d)[-1],left,right)==1
    def parallel(a,b):
        a=list(map(polynomial,a));b=list(map(polynomial,b))
        pivot=next(j for j,value in enumerate(a) if not zero(value))
        return all(zero(a[pivot]*value-b[pivot]*a[j]) for j,value in enumerate(b))
    u=witness['u1'] if parallel(witness['u1'][0],witness['u1'][2]) else witness['u2']
    selected=[parallel(u[0],u[2*i+1]) for i in range(2*source['n'])]
    assignment=[]
    for i in range(source['n']):
        if selected[2*i]==selected[2*i+1]:raise ValueError('Invalid assignment selector pair')
        assignment.append(selected[2*i])
    if not all(any(assignment[abs(l)-1]==(l>0) for l in c) for c in source['clauses']):
        raise ValueError('Recovered assignment does not satisfy the source')
    return {'assignment':assignment}


def legal(source):
    if not isinstance(source,dict) or set(source)!={'n','clauses'}:return False
    n=source['n'];clauses=source['clauses']
    if type(n) is not int or n<0 or not isinstance(clauses,list) or n>3*len(clauses):return False
    if not all(isinstance(c,list) and len(c)==3 and all(type(l) is int and 1<=abs(l)<=n for l in c) for c in clauses):return False
    return {abs(l) for c in clauses for l in c}==set(range(1,n+1))


if __name__=='__main__':
    try:data=json.load(sys.stdin)
    except json.JSONDecodeError:
        print(json.dumps({'invalid':True}));sys.exit(0)
    if '--extract' in sys.argv:
        if not legal(data['source']):raise ValueError('Invalid source encoding')
        output=extract(data['source'],data['target_solution'])
    else:output=construct(data) if legal(data) else {'invalid':True}
    print(json.dumps(output))
