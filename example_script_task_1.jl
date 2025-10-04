## Task 1.1 (Create Example Scripts)
using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

x = x_poly(PolynomialDense)
println("Constructing polynomials f, g, h using PolynomialDense:")
@show f = x^2 - 2x
@show g = 2x^3 + 3x^2 + (-3)
@show h = x + 2

println("Basic operations with the polynomials:")
@show f + g
@show f * h
@show g * h

println("Computing derivative(f*g) and confirming this follows product rule:")
@show derivative(f*g)
@show f*derivative(g) + g*derivative(f)

println("Computing (f*h)/h modulo 5,17,101 and confirming these match f modulo 5,17,101:")
@show div_mod_p((f*h), h, 5)
@show mod(f, 5)
@show div_mod_p((f*h), h, 17)
@show mod(f, 17)
@show div_mod_p((f*h), h, 101)
@show mod(f, 101)

println("Computing gcd_mod_p for p=5,11,13:")
@show gcd_mod_p(f*h, g*h, 5)
@show gcd_mod_p(f*h, g*h, 11)
@show gcd_mod_p(f*h, g*h, 13)