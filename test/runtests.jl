#############################################################################
#############################################################################
#
# A script that runs all unit tests in the project.
#
#############################################################################
#############################################################################

using Pkg
Pkg.activate(".")

include("../poly_factorization_project.jl")

####
# Execute unit tests for integers
###
include("integers_test.jl")
println("---BEGIN INTEGER UNIT TESTS---")
test_euclid_ints()
test_ext_euclid_ints()
println("---END INTEGER UNIT TESTS---\n")

####
# Execute unit tests for data structures
###
include("heap_test.jl")
println("---BEGIN HEAP UNIT TESTS---")
test_heap()
println("---END HEAP UNIT TESTS---\n")

####
# Execute unit tests for polynomials
####
include("polynomials_test.jl")
polynomial_types = [PolynomialDense{Int, Int}, PolynomialDense{BigInt, Int}]
println("---BEGIN POLYNOMIAL UNIT TESTS---\n")
for poly in polynomial_types
    println("Type of `Polynomial`: $(poly)")
    prod_test_poly(poly)
    prod_derivative_test_poly(poly)
    ext_euclid_test_poly(poly)
    division_test_poly(poly)
    println("")
end
println("---END POLYNOMIAL UNIT TESTS---\n")

####
# Execute unit tests for power operations
####
include("power_test.jl")
polynomial_types = [PolynomialDense{Int, Int}, PolynomialSparse{Int, Int}]
println("---BEGIN POWER UNIT TESTS---\n")
for poly in polynomial_types
    println("Type of `Polynomial`: $(poly)")
    power_test_poly(poly)
    pow_mod_test_poly(poly)
    println("")
end
println("---END POWER UNIT TESTS---\n")

####
# Execute unit tests for polynomial factorization
####
include("factorization_test.jl")
polynomial_types = [PolynomialDense{Int, Int}, PolynomialDense{BigInt, Int}]
println("---BEGIN FACTORIZATION UNIT TESTS---\n")
for poly in polynomial_types
    println("Type of `Polynomial`: $(poly)")
    factor_mod_p_test_poly(poly)
    println("")
end
println("---END FACTORISATION UNIT TESTS---")
