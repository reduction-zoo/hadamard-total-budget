import Challenge
open HadamardTotalBudget
example : matrixShape 1 2 ([[1,2]] : MatrixData) = true := by native_decide
example : matrixShape 2 1 ([[1,2]] : MatrixData) = false := by native_decide
example : evalRat [1,2] (3 : ℝ) = 7 := by norm_num [evalRat]
