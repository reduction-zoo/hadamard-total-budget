from pathlib import Path
import itertools
import json
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[2]/'work'))
import algorithm
import check
import frame_oracle

for s in range(6,21):
    assert [(p,q) for p in range(2*s+1) for q in range(2*s+1-p) if p*q>=s*s]==[(s,s)]
base=algorithm.construct({'n':0,'clauses':[]});s=6;blocks=[(2*i,s+2*i+1,2*i+1,s+2*i) for i in range(3)]
for choice in itertools.product((False,True),repeat=3):
    target=1
    for b,r in zip(choice,(2,3,5)):
        if b:target*=r
    t=json.loads(json.dumps(base))
    for i,r in enumerate((2,3,5)):
        row=[0]*36
        for j,v in zip(blocks[i],(1,r,1,r)):row[j]=v
        for j,v in zip(blocks[(i+1)%3],(1,target*target,target,target) if i==2 else (1,1,1,1)):row[j]=v
        t['matrix'][-3+i]=row
    witness=frame_oracle.witness(t,choice)
    assert check.target_witness_valid(t,witness)
    assert frame_oracle.solve(t) is not None
bad=json.loads(json.dumps(t))
for j,v in zip(blocks[0],(1,49,7,7)):bad['matrix'][-1][j]=v
assert frame_oracle.solve(bad) is None
print('PASS 15 allocation boundaries; 8 complete 180x36 frame witnesses with exact entry checks; target product 7 excluded for items 2,3,5 by structural oracle.')
print('The structural NO depends on the unreviewed frame theorem; no unrestricted large QF_NRA claim.')
