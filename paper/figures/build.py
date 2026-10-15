import json
from pathlib import Path
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import verify

path=Path(__file__).resolve().parents[1]
t=verify.invoke(path/'algorithm.py',{'n':1,'clauses':[[1,1,1]]})
choice=verify.product_solutions(*verify.decode_target(t))[0]
fs=verify.factors(t,choice);verify.validate(t,fs)
n=len(t['matrix'][0]);a=verify.mul(fs[0][:n],fs[1]);b=verify.mul(fs[2][:n],fs[3])
data={'a':[[int(v!=0) for v in row] for row in a],'b':[[int(v!=0) for v in row] for row in b],'m':t['matrix'][:n]}
(path/'figures'/'identity-supports.json').write_text(json.dumps(data)+'\n')
print('PASS actual F=(x1 or x1 or x1), K=4, s=8, budget=16; all 436x64 entries exact. Figure shows only leading 64x64 identity rows, not the full target. Support only, not magnitudes.')
