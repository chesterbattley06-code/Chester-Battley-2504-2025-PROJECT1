#############################################################################
#############################################################################
#
# This file implements polynomial GCD for abstract polynomials.
#                                                                               
#############################################################################
#############################################################################

function extended_euclid_alg_mod_p(a::P, b::P, prime::Int) where {C <: Integer, D, P <: Polynomial{C, D}}
    a_mod = to_mod_p(a, prime)
    b_mod = to_mod_p(b, prime)
    g_mod, s_mod, t_mod = extended_euclid_alg(ZModP{C, prime}, a_mod, b_mod)
    
    # Convert s_mod and t_mod to polynomials if they're integers
    if s_mod isa Integer
        P_mod = typeof(a_mod)
        s_mod = P_mod([Term(ZModP(C(s_mod), Val(prime)), zero(D))])
    end
    if t_mod isa Integer
        P_mod = typeof(a_mod)
        t_mod = P_mod([Term(ZModP(C(t_mod), Val(prime)), zero(D))])
    end
    
    return from_mod_p(g_mod), from_mod_p(s_mod), from_mod_p(t_mod)
end

gcd_mod_p(a::P, b::P, prime::Integer) where {C, D, P <: Polynomial{C, D}} = extended_euclid_alg_mod_p(a, b, prime) |> first