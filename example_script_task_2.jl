## Task 2.1 (Showing overflow for PolynomialDense)
using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

println("Demonstrating overflow with Int vs BigInt coefficients:\n")
println("Maximum Int value: ", typemax(Int), "\n")

# Example 1: Close to max Int
println("Example 1:")
p1 = PolynomialDense([Term(9000000000000000000, 0)])
p2 = PolynomialDense([Term(9000000000000000000, 0)])
p_sum1 = p1 + p2
println("With Int: 9000000000000000000 + 9000000000000000000 = ", p_sum1)
println("Expected: 18000000000000000000 (will overflow)\n")

# Example 2
println("Example 2:")
p3 = PolynomialDense([Term(5000000000000000000, 1)])
p4 = PolynomialDense([Term(5000000000000000000, 1)])
p_sum2 = p3 + p4
println("With Int: 5000000000000000000x + 5000000000000000000x = ", p_sum2)
println("Expected: 10000000000000000000x (will overflow)\n")

# Example 3: Max Int + 1
println("Example 3:")
max_int = typemax(Int)
p5 = PolynomialDense([Term(max_int, 0)])
p6 = PolynomialDense([Term(1, 0)])
p_sum3 = p5 + p6
println("With Int: ", max_int, " + 1 = ", p_sum3)
println("Expected: ", big(max_int) + 1, " (will overflow to negative)\n")

# Example 4
println("Example 4:")
p7 = PolynomialDense([Term(7000000000000000000, 0), Term(7000000000000000000, 2)])
p8 = PolynomialDense([Term(7000000000000000000, 0), Term(7000000000000000000, 2)])
p_sum4 = p7 + p8
println("With Int: (7×10^18 + 7×10^18x^2) + (7×10^18 + 7×10^18x^2) = ", p_sum4)
println("Expected: 14×10^18 + 14×10^18x^2 (will overflow)\n")

# Example 5
println("Example 5:")
p9 = PolynomialDense([Term(8000000000000000000, 1)])
p10 = PolynomialDense([Term(8000000000000000000, 1)])
p_sum5 = p9 + p10
println("With Int: 8×10^18x + 8×10^18x = ", p_sum5)
println("Expected: 16×10^18x (will overflow)\n")