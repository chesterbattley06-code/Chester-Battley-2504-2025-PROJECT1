#############################################################################
#############################################################################
#
# This file implements factorization 
#                                                                               
#############################################################################
#############################################################################

"""
Factors a polynomial over the field Z_p.

Returns a vector of tuples of (irreducible polynomials (mod p), multiplicity) such that their product of the list (mod p) is f. 
Irreducibles are fixed points on the function `factor`.
"""
function factor_mod_p(f::P, prime::Int)::Vector{Tuple{P, Int}} where {C <: Integer, D, P <: Polynomial{C, D}}
    f_mod = to_mod_p(f, prime)
    factors_mod = factor(ZModP{C, prime}, f_mod)
    return [(from_mod_p(p), mult) for (p, mult) in factors_mod]
end

"""
Expand a factorization.
"""
function expand_factorization(factorization::Array{Tuple{P, I}, 1}) where {C, D, I <: Integer, P <: Polynomial{C, D}}
    isempty(factorization) && return one(P)
    return prod(p^n for (p, n) in factorization)
end

"""
Compute the number of times g divides f modulo a prime.
"""
function multiplicity_mod_p(f::P, g::P, prime::Int)::Int where {C <: Integer, D, P <: Polynomial{C, D}}
    f_mod = to_mod_p(f, prime)
    g_mod = to_mod_p(g, prime)
    return multiplicity(ZModP{C, prime}, f_mod, g_mod)
end

"""
Distinct degree factorization.

Given a square free polynomial `f` returns a list, `g` such that `g[k]` is a product of irreducible 
polynomials of degree `k` for `k` in 1,...,degree(f) ÷ 2, such that the product of the list (mod `prime`) 
is equal to `f` (mod `prime`).
"""
function dd_factor_mod_p(f::P, prime::Int)::Array{P} where {C <: Integer, D, P <: Polynomial{C, D}}
    f_mod = to_mod_p(f, prime)
    factors_mod = dd_factor(ZModP{C, prime}, f_mod)
    return [from_mod_p(p) for p in factors_mod]
end

"""
Distinct degree split.

Returns a list of irreducible polynomials of degree `d` so that the product of that list (mod prime) is the polynomial `f`.
"""
function dd_split_mod_p(f::P, d::Int, prime::Int)::Vector{P} where {C <: Integer, D, P <: Polynomial{C, D}}
    f_mod = to_mod_p(f, prime)
    factors_mod = dd_split(ZModP{C, prime}, f_mod, d)
    return [from_mod_p(p) for p in factors_mod]
end