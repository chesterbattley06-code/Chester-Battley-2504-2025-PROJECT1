## Example script task 3
using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

println("Demonstrating overflow with Int vs BigInt coefficients:\n")
println("Maximum Int value: ", typemax(Int), "\n")

# Example 1: Close to max Int
println("Example 1:")
p1_int = PolynomialSparse{Int, Int}([Term(9000000000000000000, 0)])
p2_int = PolynomialSparse{Int, Int}([Term(9000000000000000000, 0)])
p_sum1_int = p1_int + p2_int
println("With Int: ", p_sum1_int, " (overflows)")

p1_big = PolynomialSparse{BigInt, Int}([Term(BigInt(9000000000000000000), 0)])
p2_big = PolynomialSparse{BigInt, Int}([Term(BigInt(9000000000000000000), 0)])
p_sum1_big = p1_big + p2_big
println("With BigInt: ", p_sum1_big, " (correct: 18000000000000000000)\n")

# Example 2
println("Example 2:")
p3_int = PolynomialSparse{Int, Int}([Term(5000000000000000000, 1)])
p4_int = PolynomialSparse{Int, Int}([Term(5000000000000000000, 1)])
p_sum2_int = p3_int + p4_int
println("With Int: ", p_sum2_int, " (overflows)")

p3_big = PolynomialSparse{BigInt, Int}([Term(BigInt(5000000000000000000), 1)])
p4_big = PolynomialSparse{BigInt, Int}([Term(BigInt(5000000000000000000), 1)])
p_sum2_big = p3_big + p4_big
println("With BigInt: ", p_sum2_big, " (correct: 10000000000000000000x)\n")

# Example 3: Max Int + 1
println("Example 3:")
max_int = typemax(Int)
p5_int = PolynomialSparse{Int, Int}([Term(max_int, 0)])
p6_int = PolynomialSparse{Int, Int}([Term(1, 0)])
p_sum3_int = p5_int + p6_int
println("With Int: ", p_sum3_int, " (overflows to negative)")

p5_big = PolynomialSparse{BigInt, Int}([Term(BigInt(max_int), 0)])
p6_big = PolynomialSparse{BigInt, Int}([Term(BigInt(1), 0)])
p_sum3_big = p5_big + p6_big
println("With BigInt: ", p_sum3_big, " (correct: ", BigInt(max_int) + 1, ")\n")

# Example 4
println("Example 4:")
p7_int = PolynomialSparse{Int, Int}([Term(7000000000000000000, 0), Term(7000000000000000000, 2)])
p8_int = PolynomialSparse{Int, Int}([Term(7000000000000000000, 0), Term(7000000000000000000, 2)])
p_sum4_int = p7_int + p8_int
println("With Int: ", p_sum4_int, " (overflows)")

p7_big = PolynomialSparse{BigInt, Int}([Term(BigInt(7000000000000000000), 0), Term(BigInt(7000000000000000000), 2)])
p8_big = PolynomialSparse{BigInt, Int}([Term(BigInt(7000000000000000000), 0), Term(BigInt(7000000000000000000), 2)])
p_sum4_big = p7_big + p8_big
println("With BigInt: ", p_sum4_big, " (correct)\n")

# Example 5
println("Example 5:")
p9_int = PolynomialSparse{Int, Int}([Term(8000000000000000000, 1)])
p10_int = PolynomialSparse{Int, Int}([Term(8000000000000000000, 1)])
p_sum5_int = p9_int + p10_int
println("With Int: ", p_sum5_int, " (overflows)")

p9_big = PolynomialSparse{BigInt, Int}([Term(BigInt(8000000000000000000), 1)])
p10_big = PolynomialSparse{BigInt, Int}([Term(BigInt(8000000000000000000), 1)])
p_sum5_big = p9_big + p10_big
println("With BigInt: ", p_sum5_big, " (correct: 16000000000000000000x)\n")

println("\n" * "="^60)
println("Benchmarking PolynomialSparse vs PolynomialDense")
println("="^60 * "\n")

using BenchmarkTools

# Test case: Very sparse polynomial (only a few non-zero terms out of high degree)
println("Test 1: Sparse polynomial (degree 100, only 5 non-zero terms)")
sparse_terms = [Term(1, 0), Term(2, 25), Term(3, 50), Term(4, 75), Term(5, 100)]
dense_sparse = PolynomialDense{Int, Int}(sparse_terms)
sparse_sparse = PolynomialSparse{Int, Int}(sparse_terms)

println("\nAddition:")
println("Dense:  ", @benchmark $dense_sparse + $dense_sparse)
println("Sparse: ", @benchmark $sparse_sparse + $sparse_sparse)

println("\nMultiplication:")
println("Dense:  ", @benchmark $dense_sparse * $dense_sparse)
println("Sparse: ", @benchmark $sparse_sparse * $sparse_sparse)

# Test case: Medium sparse polynomial
println("\n\nTest 2: Medium sparse polynomial (degree 50, 10 terms)")
med_terms = [Term(i, i*5) for i in 1:10]
dense_med = PolynomialDense{Int, Int}(med_terms)
sparse_med = PolynomialSparse{Int, Int}(med_terms)

println("\nAddition:")
println("Dense:  ", @benchmark $dense_med + $dense_med)
println("Sparse: ", @benchmark $sparse_med + $sparse_med)

println("\nMultiplication:")
println("Dense:  ", @benchmark $dense_med * $dense_med)
println("Sparse: ", @benchmark $sparse_med * $sparse_med)