#############################################################################
#############################################################################
#
# This file contains unit tests for power operations
#
#############################################################################
#############################################################################

function power_test_poly(::Type{P}; N::Int = 100, seed::Int = 0) where {C, D, P <: Polynomial{C, D}}
    Random.seed!(seed)
    
    # Test x^n returns correct result
    x = x_poly(P)
    for n in [0, 1, 5, 10, 100]
        result = x^n
        if n == 0
            @assert result == one(P)
        else
            # Check the result is correct
            @assert degree(result) == n
            @assert leading(result).coeff == one(C)
        end
    end
    
    # Test 0^n and 1^n
    @assert zero(P)^5 == zero(P)
    @assert one(P)^100 == one(P)
    
    # Test general polynomials
    for _ in 1:N
        p = rand(P, degree=5)
        # Verify (p^2) = p * p
        @assert p^2 == p * p
        # Verify (p^3) = p * p * p
        @assert p^3 == p * p * p
    end
    
    println("power_test_poly for $(P) - PASSED")
end

function pow_mod_test_poly(::Type{P}; N::Int = 100, prime::Int = 101, seed::Int = 0) where {C, D, P <: Polynomial{C, D}}
    Random.seed!(seed)
    
    for _ in 1:N
        p = rand(P, degree=5)
        n = rand(1:20)
        
        # Just verify pow_mod doesn't crash and produces a polynomial
        result = pow_mod(p, n, prime)
        @assert degree(result) <= n * degree(p)
        @assert all(t -> abs(t.coeff) < prime, result)
    end
    
    println("pow_mod_test_poly for $(P) - PASSED")
end