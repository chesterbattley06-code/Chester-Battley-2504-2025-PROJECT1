using Pkg
Pkg.activate(".")
include("poly_factorization_project.jl")

println("Task 5: Demonstrating ZModP operations\n")

# Basic arithmetic in Z5 (integers modulo 5)
println("=== Arithmetic in Z5 ===")
a = ZModP(3, Val(5))
b = ZModP(2, Val(5))
println("a = ", a, ", b = ", b)
println("a + b = ", a + b, " (should be 0 since 3+2=5≡0 mod 5)")
println("a - b = ", a - b, " (should be 1 since 3-2=1)")
println("a * b = ", a * b, " (should be 1 since 3*2=6≡1 mod 5)")
println("a ÷ b = ", a ÷ b, " (should be 4 since 3/2=3*3=9≡4 mod 5)")
println("a^3 = ", a^3, " (should be 2 since 3^3=27≡2 mod 5)")
println()

# Mixed operations with regular integers
println("=== Mixed operations ===")
println("a + 1 = ", a + 1, " (should be 4)")
println("5 * b = ", 5 * b, " (should be 0)")
println()

# Working in Z7 (integers modulo 7)
println("=== Arithmetic in Z7 ===")
c = ZModP(5, Val(7))
d = ZModP(3, Val(7))
println("c = ", c, ", d = ", d)
println("c * d = ", c * d, " (should be 1 since 5*3=15≡1 mod 7)")
println("c ÷ d = ", c ÷ d, " (should be 4)")