"""Independent full-witness localization and global-orientation check."""
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp

candidate = Path(__file__).resolve().parents[2] / 'work' / 'algorithm.py'
source = {'n': 1, 'clauses': [[-1, -1, -1]]}
target = json.loads(subprocess.run([sys.executable, str(candidate)], input=json.dumps(source), text=True, capture_output=True, check=True).stdout)
items = [2, 54, 3, 9]
chosen = [False, True, True, False]
s = 8
cells = [divmod(j, s) for j in range(s*s)]
scales = [sp.Rational(1)] * (s*s)
h = sp.Rational(-2)
for i, selected in enumerate(chosen):
    t = 1/h if selected else h
    cells[2*i+1] = (0, 2*i+1) if selected else (1, 2*i)
    cells[s+2*i] = (1, 2*i) if selected else (0, 2*i+1)
    scales[2*i+1] = t
    scales[s+2*i] = 1/t
    h *= items[i] if selected else 1
assert h == -2*162 and len(set(cells)) == s*s
u, w = [], []
for row in target['matrix']:
    reshaped = sp.zeros(s)
    for j, value in enumerate(row):
        reshaped[cells[j]] = value*scales[j]
    a, b = next((a,b) for a in range(s) for b in range(s) if reshaped[a,b])
    left = reshaped[:, b]
    right = reshaped[a, :]/reshaped[a,b]
    assert left*right == reshaped
    u.append(list(left))
    w.append(list(right))
v, z = sp.zeros(s, s*s), sp.zeros(s, s*s)
for j, ((a,b), scale) in enumerate(zip(cells, scales)):
    v[a,j] = 1/scale
    z[b,j] = 1
u, w = sp.Matrix(u), sp.Matrix(w)
# Dense rational changes mix every frame direction.
g = sp.ones(s) + sp.eye(s)
u, v = u*g, g.inv()*v
w, z = w*g.T, g.T.inv()*z
assert (u*v).multiply_elementwise(w*z) == sp.Matrix(target['matrix'])
assert target['budget'] == 2*s
x = sp.Symbol('x')
minimal = x**5-2
defining = -3*minimal**2*(x*x-2)
assert sp.Poly(defining,x).count_roots(1,sp.Rational(6,5)) == 1
def encode(matrix):
    output = []
    for row in matrix.tolist():
        encoded = []
        for value in row:
            # A high-degree coordinate representative vanishes at the chosen
            # root but is not zero modulo the entire defining polynomial.
            representative = value + minimal*(x**9+x+1)
            assert sp.rem(representative-value,minimal,x) == 0
            assert sp.rem(representative-value,defining,x) != 0
            encoded.append([str(c) for c in reversed(sp.Poly(representative,x).all_coeffs())])
        output.append(encoded)
    return output
witness = {'p':s, 'q':s, 'field':{'polynomial':[int(c) for c in reversed(sp.Poly(defining,x).all_coeffs())], 'interval':['1','6/5']}, 'u1':encode(u), 'v1':encode(v), 'u2':encode(w), 'v2':encode(z)}
for swapped in (False, True):
    if swapped:
        witness['u1'],witness['u2'] = witness['u2'],witness['u1']
        witness['v1'],witness['v2'] = witness['v2'],witness['v1']
    result = subprocess.run([sys.executable,str(candidate),'--extract'],input=json.dumps({'source':source,'target_solution':witness}),text=True,capture_output=True,check=True)
    assert json.loads(result.stdout) == {'assignment':[False]}
    print('PASS localized degree-five root, negative prefix parameters, dense frame gauge, factor swap =',swapped)
print('PASS complete actual target entries; high-degree representatives not divisible by whole defining polynomial; two fresh-process recoveries')
