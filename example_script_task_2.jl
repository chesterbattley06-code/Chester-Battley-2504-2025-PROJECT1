## Example script task 2
using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

println("Demonstrating overflow with Int vs BigInt coefficients:\n")
println("Maximum Int value: ", typemax(Int), "\n")

# Example 1: Close to max Int
println("Example 1:")
p1_int = PolynomialDense{Int, Int}([Term(9000000000000000000, 0)])
p2_int = PolynomialDense{Int, Int}([Term(9000000000000000000, 0)])
p_sum1_int = p1_int + p2_int
println("With Int: ", p_sum1_int, " (overflows)")

p1_big = PolynomialDense{BigInt, Int}([Term(BigInt(9000000000000000000), 0)])
p2_big = PolynomialDense{BigInt, Int}([Term(BigInt(9000000000000000000), 0)])
p_sum1_big = p1_big + p2_big
println("With BigInt: ", p_sum1_big, " (correct: 18000000000000000000)\n")

# Example 2
println("Example 2:")
p3_int = PolynomialDense{Int, Int}([Term(5000000000000000000, 1)])
p4_int = PolynomialDense{Int, Int}([Term(5000000000000000000, 1)])
p_sum2_int = p3_int + p4_int
println("With Int: ", p_sum2_int, " (overflows)")

p3_big = PolynomialDense{BigInt, Int}([Term(BigInt(5000000000000000000), 1)])
p4_big = PolynomialDense{BigInt, Int}([Term(BigInt(5000000000000000000), 1)])
p_sum2_big = p3_big + p4_big
println("With BigInt: ", p_sum2_big, " (correct: 10000000000000000000x)\n")

# Example 3: Max Int + 1
println("Example 3:")
max_int = typemax(Int)
p5_int = PolynomialDense{Int, Int}([Term(max_int, 0)])
p6_int = PolynomialDense{Int, Int}([Term(1, 0)])
p_sum3_int = p5_int + p6_int
println("With Int: ", p_sum3_int, " (overflows to negative)")

p5_big = PolynomialDense{BigInt, Int}([Term(BigInt(max_int), 0)])
p6_big = PolynomialDense{BigInt, Int}([Term(BigInt(1), 0)])
p_sum3_big = p5_big + p6_big
println("With BigInt: ", p_sum3_big, " (correct: ", BigInt(max_int) + 1, ")\n")

# Example 4
println("Example 4:")
p7_int = PolynomialDense{Int, Int}([Term(7000000000000000000, 0), Term(7000000000000000000, 2)])
p8_int = PolynomialDense{Int, Int}([Term(7000000000000000000, 0), Term(7000000000000000000, 2)])
p_sum4_int = p7_int + p8_int
println("With Int: ", p_sum4_int, " (overflows)")

p7_big = PolynomialDense{BigInt, Int}([Term(BigInt(7000000000000000000), 0), Term(BigInt(7000000000000000000), 2)])
p8_big = PolynomialDense{BigInt, Int}([Term(BigInt(7000000000000000000), 0), Term(BigInt(7000000000000000000), 2)])
p_sum4_big = p7_big + p8_big
println("With BigInt: ", p_sum4_big, " (correct)\n")

# Example 5
println("Example 5:")
p9_int = PolynomialDense{Int, Int}([Term(8000000000000000000, 1)])
p10_int = PolynomialDense{Int, Int}([Term(8000000000000000000, 1)])
p_sum5_int = p9_int + p10_int
println("With Int: ", p_sum5_int, " (overflows)")

p9_big = PolynomialDense{BigInt, Int}([Term(BigInt(8000000000000000000), 1)])
p10_big = PolynomialDense{BigInt, Int}([Term(BigInt(8000000000000000000), 1)])
p_sum5_big = p9_big + p10_big
println("With BigInt: ", p_sum5_big, " (correct: 16000000000000000000x)\n")