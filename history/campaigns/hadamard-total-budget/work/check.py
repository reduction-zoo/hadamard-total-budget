import argparse
import itertools
import json
import re
from pathlib import Path
import subprocess
import sys
import tempfile
from fractions import Fraction

import z3
import sympy as sp

sys.set_int_max_str_digits(0)


def source_shape(s):
    assert type(s['n']) is int and s['n'] >= 0
    assert s['n'] <= 3*len(s['clauses'])
    assert all(len(c) == 3 and all(type(l) is int and 1 <= abs(l) <= s['n'] for l in c) for c in s['clauses'])
    assert {abs(l) for c in s['clauses'] for l in c} == set(range(1,s['n']+1))


def source_valid(s, witness):
    source_shape(s)
    a = witness['assignment']
    assert len(a) == s['n'] and all(type(x) is bool for x in a)
    return all(any(a[abs(l)-1] == (l > 0) for l in c) for c in s['clauses'])


def source_solve(s):
    source_shape(s)
    source_valid(s, {'assignment': [False]*s['n']})
    xs = [z3.Bool(f'x{i}') for i in range(s['n'])]
    solver = z3.Solver()
    solver.add([z3.Or([xs[abs(l)-1] if l > 0 else z3.Not(xs[abs(l)-1]) for l in c]) for c in s['clauses']])
    result = solver.check()
    assert result in (z3.sat, z3.unsat), result
    if result == z3.unsat:
        return None
    witness = {'assignment': [z3.is_true(solver.model().eval(x, model_completion=True)) for x in xs]}
    assert source_valid(s, witness)
    return witness


def exact(text):
    if isinstance(text,dict):
        assert set(text)=={'polynomial','root'}
        cs=text['polynomial'];assert len(cs)>=2 and all(type(c) is int for c in cs) and cs[-1]!=0
        assert type(text['root']) is int and 1<=text['root']<len(cs)
        terms=['(* '+str(c)+' (^ x '+str(i)+'))' for i,c in enumerate(cs) if c]
        text='(root-obj (+ '+' '.join(terms)+') '+str(text['root'])+')'
    else:
        assert isinstance(text,str) and re.fullmatch(r'[0-9./()\s-]+',text)
    x = z3.Real('witness_value')
    parsed = z3.parse_smt2_string('(assert (= witness_value '+text+'))', decls={'witness_value': x})
    assert len(parsed) == 1 and z3.is_eq(parsed[0]) and parsed[0].arg(0).eq(x)
    v = z3.simplify(parsed[0].arg(1))
    assert z3.is_rational_value(v) or z3.is_algebraic_value(v)
    return v


def encode(v):
    v=z3.simplify(v)
    if z3.is_rational_value(v):return v.sexpr()
    assert z3.is_algebraic_value(v)
    return {'polynomial':[c.as_long() for c in v.poly()],'root':v.index()}


def common_witness(w):
    values={};irrationals=set();x=sp.Symbol('x')
    for key,matrix in w.items():
        values[key]=[]
        for row in matrix:
            converted=[]
            for v in row:
                v=exact(v)
                if z3.is_rational_value(v):a=sp.Rational(v.numerator_as_long(),v.denominator_as_long())
                else:
                    p=sp.Poly.from_list([c.as_long() for c in reversed(v.poly())],x)
                    a=p.real_roots()[v.index()-1];irrationals.add(a)
                converted.append(a)
            values[key].append(converted)
    if not irrationals:
        return {'field':{'polynomial':[0,1],'interval':['-1','1']},**{key:[[[str(v)] for v in row] for row in matrix] for key,matrix in values.items()}}
    primitive=sp.to_number_field(sorted(irrationals,key=str));p=primitive.minpoly
    interval=next((a,b) for (a,b),multiplicity in p.intervals() if bool(a<primitive.as_expr()) and bool(primitive.as_expr()<b))
    result={'field':{'polynomial':[int(c) for c in reversed(p.all_coeffs())],'interval':list(map(str,interval))}}
    for key,matrix in values.items():
        result[key]=[[list(map(str,reversed(sp.to_number_field(v,primitive).coeffs()))) for v in row] for row in matrix]
    return result


def target_valid(t):
    assert set(t)=={'matrix','budget'}
    a=t['matrix']; assert isinstance(a,list) and a and isinstance(a[0],list) and a[0]
    m,n=len(a),len(a[0]); assert all(isinstance(row,list) and len(row)==n for row in a)
    for row in a:
        for x in row:
            assert type(x) is int or isinstance(x,str) and re.fullmatch(r'-?[0-9]+(?:/[0-9]+)?',x)
            Fraction(x)
    assert type(t['budget']) is int and t['budget']>=0
    return m,n


def target_witness_valid(t,w):
    m,n=target_valid(t);p,q=w['p'],w['q']
    assert type(p) is int and type(q) is int and 0<=p<=min(m,n) and 0<=q<=min(m,n) and p+q<=t['budget']
    assert set(w)=={'p','q','u1','v1','u2','v2'}
    values=[]
    for key,(r,c) in zip(('u1','v1','u2','v2'),((m,p),(p,n),(m,q),(q,n))):
        a=w[key];assert len(a)==r and all(len(row)==c for row in a)
        values.append([[exact(v) for v in row] for row in a])
    if all(z3.is_rational_value(v) for a in values for row in a for v in row):
        u,v,x,y=[[[Fraction(v.numerator_as_long(),v.denominator_as_long()) for v in row] for row in a] for a in values]
        def product(left,right,width):
            result=[]
            for row in left:
                out=[Fraction(0)]*n
                for j,c in enumerate(row):
                    if c:
                        for k,value in enumerate(right[j]):
                            if value:out[k]+=c*value
                result.append(out)
            return result
        a=product(u,v,p);b=product(x,y,q)
        return all(a[i][j]*b[i][j]==Fraction(t['matrix'][i][j]) for i in range(m) for j in range(n))
    u,v,x,y=values
    return all(z3.is_true(z3.simplify(sum(u[i][r]*v[r][j] for r in range(p))*sum(x[i][r]*y[r][j] for r in range(q))==z3.RealVal(str(t['matrix'][i][j])))) for i in range(m) for j in range(n))


def target_solve(t):
    m,n=target_valid(t);d=min(m,n)
    for p in range(d+1):
        for q in range(p,d+1):
            if p+q>t['budget']:continue
            shapes=((m,p),(p,n),(m,q),(q,n))
            vs={key:[[z3.Real(f'{key}_{i}_{j}') for j in range(c)] for i in range(r)] for key,(r,c) in zip(('u1','v1','u2','v2'),shapes)}
            u,v,x,y=[vs[key] for key in ('u1','v1','u2','v2')]
            solver=z3.SolverFor('QF_NRA')
            solver.add([sum(u[i][r]*v[r][j] for r in range(p))*sum(x[i][r]*y[r][j] for r in range(q))==z3.RealVal(str(t['matrix'][i][j])) for i in range(m) for j in range(n)])
            result=solver.check();assert result in (z3.sat,z3.unsat),result
            if result==z3.sat:
                model=solver.model();w={'p':p,'q':q,**{key:[[encode(model.eval(v,model_completion=True)) for v in row] for row in a] for key,a in vs.items()}}
                assert target_witness_valid(t,w)
                return w
    return None


def run_case(path,s,oracle=target_solve):
    t=json.loads(subprocess.run([sys.executable,str(path)],input=json.dumps(s),text=True,capture_output=True,check=True).stdout)
    target_valid(t);w=oracle(t);assert (w is not None)==(source_solve(s) is not None),s
    calls=0
    if w is not None:
        swapped={'p':w['q'],'q':w['p'],'u1':w['u2'],'v1':w['v2'],'u2':w['u1'],'v2':w['v1']}
        for solution in (w,swapped):
            assert target_witness_valid(t,solution)
            public={'p':solution['p'],'q':solution['q'],**common_witness({key:solution[key] for key in ('u1','v1','u2','v2')})}
            recovered=json.loads(subprocess.run([sys.executable,str(path),'--extract'],input=json.dumps({'source':s,'target_solution':public}),text=True,capture_output=True,check=True).stdout)
            assert source_valid(s,recovered),(s,recovered)
            calls+=1
    return calls


def self_test(cases):
    for c in cases:
        assert any(source_valid(c['source'],{'assignment':list(a)}) for a in itertools.product((False,True),repeat=c['source']['n']))==c['yes']==(source_solve(c['source']) is not None)
    tests=[([[0]],0,True),([[1]],0,False),([[1]],1,False),([[1]],2,True),([[1,2],[2,4]],2,True),([[1,0],[0,1]],2,False),([[1,0],[0,1]],3,True)]
    for a,b,yes in tests:
        t={'matrix':a,'budget':b};w=target_solve(t);assert (w is not None)==yes
        if w is not None:
            bad=json.loads(json.dumps(w));bad['p']=b+1
            try:target_witness_valid(t,bad)
            except AssertionError:pass
            else:raise AssertionError('over-budget witness accepted')
    irr={'p':1,'q':1,'u1':[[{'polynomial':[-2,0,1],'root':2}]],'v1':[['1']],'u2':[[{'polynomial':[-2,0,1],'root':2}]],'v2':[['1']]}
    assert target_witness_valid({'matrix':[[2]],'budget':2},irr)
    assert not target_witness_valid({'matrix':[[3]],'budget':2},irr)
    with tempfile.TemporaryDirectory() as d:
        p=Path(d)/'fixture.py'
        for name,t,s in [('malformed',{'matrix':[[1]],'budget':-1},cases[0]['source']),('decision',{'matrix':[[0]],'budget':0},cases[-1]['source'])]:
            p.write_text('import json\nprint(json.dumps('+repr(t)+'))\n')
            try:run_case(p,s)
            except AssertionError:print('rejected',name)
            else:raise AssertionError('bad fixture accepted')
        p.write_text('import sys,json\nprint(json.dumps({"assignment":[False]} if "--extract" in sys.argv else {"matrix":[[1]],"budget":2}))\n')
        try:run_case(p,{'n':1,'clauses':[[1,1,1]]})
        except AssertionError:print('rejected recovery')
        else:raise AssertionError('bad recovery accepted')
    print('PASS',len(cases),'source cases;',len(tests),'total-budget targets; algebraic and over-budget witness checks; 3 faulty subprocess fixtures; Z3',z3.get_version_string())


if __name__=='__main__':
    parser=argparse.ArgumentParser();g=parser.add_mutually_exclusive_group(required=True);g.add_argument('--self-test',action='store_true');g.add_argument('--candidate',type=Path);parser.add_argument('--oracle',choices=['quartic','frame'],default='quartic');args=parser.parse_args()
    cases=json.loads(Path(__file__).with_name('cases.json').read_text())
    if args.self_test:self_test(cases)
    else:
        if args.oracle=='frame':
            from frame_oracle import solve
            oracle=solve
        else:oracle=target_solve
        calls=sum(run_case(args.candidate,c['source'],oracle) for c in cases)
        print('PASS',len(cases),'injected sources;',calls,'recovery calls')
