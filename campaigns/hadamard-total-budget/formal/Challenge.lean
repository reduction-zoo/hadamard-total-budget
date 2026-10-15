module

public import Mathlib.Computability.TuringMachine.Computable
public import Mathlib.Analysis.Real.Sqrt

@[expose] public section

namespace HadamardTotalBudget

/-- Q001's self-delimiting binary natural; length is logarithmic, not unary. -/
def encodeNat (n : Nat) : List Bool :=
  let bits := (Nat.toDigits 2 n).map (fun c => c == '1')
  List.replicate bits.length true ++ [false] ++ bits

def encodeList {α : Type} (encode : α → List Bool) (xs : List α) : List Bool :=
  encodeNat xs.length ++ xs.flatMap encode

def encodeOption {α : Type} (encode : α → List Bool) : Option α → List Bool
  | none => [false]
  | some x => true :: encode x

/-- None denotes mathematical nonexistence, never an execution error. -/
def searchOutput {I W : Type} (legal : I → Bool) (witness : I → W → Bool)
    (x : I) : Option W → Prop
  | some w => legal x = true ∧ witness x w = true
  | none => legal x = true ∧ ¬ ∃ w, witness x w = true

/-- Relational version for witnesses with quantified real or optimality conditions. -/
def relationalOutput {I W : Type} (legal : I → Bool) (witness : I → W → Prop)
    (x : I) : Option W → Prop
  | some w => legal x = true ∧ witness x w
  | none => legal x = true ∧ ¬ ∃ w, witness x w

def encodeInt (z : Int) : List Bool := [decide (z < 0)] ++ encodeNat z.natAbs
def encodeRat (q : Rat) : List Bool := encodeInt q.num ++ encodeNat q.den
structure Formula where
  n : Nat
  clauses : List (List (Nat × Bool))
  deriving Repr

def legalSource (x : Formula) : Bool :=
  x.clauses.all (fun c => c.length ≤ 3 && c.all (fun l => l.1 < x.n))

def sourceWitness (x : Formula) (a : List Bool) : Bool :=
  a.length == x.n && x.clauses.all (fun c => c.any (fun l => a[l.1]? == some l.2))

def encodeSource (x : Formula) : List Bool :=
  encodeNat x.n ++ encodeList (encodeList (fun l => encodeNat l.1 ++ [l.2])) x.clauses

def validSourceOutput := searchOutput legalSource sourceWitness

abbrev MatrixData := List (List Rat)
def matrixShape {α : Type} (rows cols : Nat) (a : List (List α)) : Bool :=
  a.length == rows && a.all (fun row => row.length == cols)
structure Primitive where
  polynomial : List Int
  lower : Rat
  upper : Rat
  deriving Repr
def evalInt (p : List Int) (t : ℝ) : ℝ := p.foldr (fun c value => (c : ℝ)+t*value) 0
def evalRat (p : List Rat) (t : ℝ) : ℝ := p.foldr (fun c value => (c : ℝ)+t*value) 0
def isolates (p : Primitive) (t : ℝ) : Prop :=
  p.polynomial.any (· != 0) = true ∧ (p.lower : ℝ) < t ∧ t < (p.upper : ℝ) ∧
  evalInt p.polynomial t = 0 ∧
  ∀ s : ℝ, (p.lower : ℝ) < s → s < (p.upper : ℝ) → evalInt p.polynomial s = 0 → s = t
abbrev AlgebraicMatrix := List (List (List Rat))
structure Factors where
  primitive : Primitive
  firstWidth : Nat
  secondWidth : Nat
  u : AlgebraicMatrix
  v : AlgebraicMatrix
  w : AlgebraicMatrix
  z : AlgebraicMatrix
  deriving Repr
def entry (a : AlgebraicMatrix) (i j : Nat) (t : ℝ) : ℝ := evalRat ((a[i]?.getD [])[j]?.getD []) t
def productEntry (a b : AlgebraicMatrix) (width i j : Nat) (t : ℝ) : ℝ :=
  ((List.range width).map (fun k => entry a i k t * entry b k j t)).sum
def factorization (rows cols : Nat) (m : MatrixData) (f : Factors) : Prop :=
  matrixShape rows f.firstWidth f.u = true ∧ matrixShape f.firstWidth cols f.v = true ∧
  matrixShape rows f.secondWidth f.w = true ∧ matrixShape f.secondWidth cols f.z = true ∧
  ∃ t : ℝ, isolates f.primitive t ∧ ∀ i < rows, ∀ j < cols,
    (((m[i]?.getD [])[j]?.getD 0 : Rat) : ℝ) =
    productEntry f.u f.v f.firstWidth i j t * productEntry f.w f.z f.secondWidth i j t
def encodePrimitive (p : Primitive) := encodeList encodeInt p.polynomial ++ encodeRat p.lower ++ encodeRat p.upper
def encodeFactors (f : Factors) := encodePrimitive f.primitive ++ encodeNat f.firstWidth ++ encodeNat f.secondWidth ++
  encodeList (encodeList (encodeList encodeRat)) f.u ++ encodeList (encodeList (encodeList encodeRat)) f.v ++
  encodeList (encodeList (encodeList encodeRat)) f.w ++ encodeList (encodeList (encodeList encodeRat)) f.z

structure Instance where
  rows : Nat
  cols : Nat
  matrix : MatrixData
  budget : Nat
  deriving Repr
def legalTarget (x : Instance) : Bool := x.rows > 0 && x.cols > 0 && matrixShape x.rows x.cols x.matrix
def targetWitness (x : Instance) (f : Factors) : Prop := f.firstWidth+f.secondWidth ≤ x.budget ∧ factorization x.rows x.cols x.matrix f
def validTargetOutput := relationalOutput legalTarget targetWitness
def encodeTarget (x : Instance) := encodeList encodeNat (List.range x.rows) ++ encodeList encodeNat (List.range x.cols) ++
  encodeList (encodeList encodeRat) x.matrix ++ encodeNat x.budget

/-- Both algorithms use Q001's explicit bit encoding and TM2 cost model.
Recovery receives the full pair of source instance and target output. -/
def Reduction (forward : Formula → Instance)
    (recover : Formula × Option Factors → Option (List Bool)) : Prop :=
  Nonempty (Turing.TM2ComputableInPolyTime encodeSource encodeTarget forward) ∧
  Nonempty (Turing.TM2ComputableInPolyTime
    (fun input => encodeSource input.1 ++ (encodeOption encodeFactors) input.2)
    (encodeOption (encodeList (fun b => [b]))) recover) ∧
  (∃ bound : Polynomial Nat, ∀ x,
    (encodeTarget (forward x)).length ≤ bound.eval (encodeSource x).length) ∧
  (∃ bound : Polynomial Nat, ∀ input,
    ((encodeOption (encodeList (fun b => [b]))) (recover input)).length ≤
      bound.eval (encodeSource input.1 ++ (encodeOption encodeFactors) input.2).length) ∧
  (∀ x, legalSource x = true → legalTarget (forward x) = true) ∧
  (∀ x, legalSource x = true → ∀ y, validTargetOutput (forward x) y →
    validSourceOutput x (recover (x, y)))


def Goal : Prop :=
  ∃ (forward : Formula → Instance)
    (recover : Formula × Option Factors → Option (List Bool)), Reduction forward recover

/-- Open question only; this placeholder is not a solution. -/
theorem solve : Goal := by
  sorry

end HadamardTotalBudget
