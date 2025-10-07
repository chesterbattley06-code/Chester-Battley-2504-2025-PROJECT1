#############################################################################
#############################################################################
#
# This file implements operations for polynomials over a field, e.g. Zp[x].
#                                                                               
#############################################################################
#############################################################################

"""
Returns the quotient and remainder of num divided by den (where num/den have the 
same concrete type). 
"""
function div_rem(::Type{C}, num::P, den::P)::Tuple{P, P} where {T <: Integer, N, D, C <: ZModP{T, N}, P <: Polynomial{C, D}}
    iszero(den) && throw(DivideError())
    iszero(num) && return zero(P), zero(P)
    
    q = P()
    r = deepcopy(num)
    
    while !iszero(r) && degree(r) >= degree(den)
        lead_term = Term(leading(r).coeff ÷ leading(den).coeff, degree(r) - degree(den))
        q = q + P([lead_term])
        r = r - P([lead_term]) * den
    end
    
    return q, r
end

"""
Distinct degree factorization.

Given a square free polynomial `f` returns a list, `g` such that `g[k]` is a product 
of irreducible polynomials of degree `k` for `k` in 1,...,degree(f) ÷ 2, such that the 
product of the list is equal to `f`.
"""
function dd_factor(::Type{C}, f::P)::Array{P} where {T <: Integer, N, D, C <: ZModP{T, N}, P <: Polynomial{C, D}}
    x = x_poly(P)
    w = deepcopy(x)
    factors = P[]
    
    for i in 1:degree(f)÷2
        w = rem(C, w^N - x, f)
        push!(factors, gcd(C, f, w))
    end
    
    return factors
end

"""
Distinct degree split.

Returns a list of irreducible polynomials of degree `d` so that the product of
that list is the polynomial `f`.
"""
function dd_split(::Type{C}, f::P, d::Integer)::Vector{P} where {T <: Integer, N, D, C <: ZModP{T, N}, P <: Polynomial{C, D}}
    degree(f) == d && return [f]
    
    factors = P[]
    w = P([Term(one(C), zero(D))])
    
    for _ in 1:2*d
        w = w + P([Term(C(rand(-10:10)), D(rand(0:degree(f))))])
        w = rem(C, w^((N^d - 1) ÷ 2), f)
        g = gcd(C, w - one(P), f)
        
        if !iszero(g) && degree(g) != 0 && degree(g) != degree(f)
            append!(factors, dd_split(C, g, d))
            append!(factors, dd_split(C, div(C, f, g), d))
            return factors
        end
    end
    
    return [f]
end

"""
Returns the factors of `f` in an array of tuples. 

For a given tuple (g, n) in the returned array, g is an irreducible factor
of f and the multiplicity of g in f is n.

The returned array may also contain a constant for reconstruction of the
leading coefficient.
"""
function factor(::Type{C}, f::P)::Vector{Tuple{P, Integer}} where {T <: Integer, N, D, C <: ZModP{T, N}, P <: Polynomial{C, D}}
    # Handle constant
    if degree(f) == 0
        return Tuple{P, Integer}[]
    end
    
    # Factor as-is, without making monic
    f_sqfr = square_free(C, f)
    dd_factors = dd_factor(C, f_sqfr)
    
    factors = Tuple{P, Integer}[]
    
    for (i, g) in enumerate(dd_factors)
        if degree(g) > 0
            irreds = dd_split(C, g, i)
            for p in irreds
                push!(factors, (p, multiplicity(C, f, p)))
            end
        end
    end
    
    return factors
end

""" 
Returns the quotient of num divided by den (where num/den have the 
same concrete type) 
"""
div(::Type{C}, num::P, den::P) where {C, D, P <: Polynomial{C, D}} = first(div_rem(C, num, den))

""" 
Returns the remainder of num divided by den (where num/den have the 
same concrete type) 
"""
rem(::Type{C}, num::P, den::P) where {C, D, P <: Polynomial{C, D}} = last(div_rem(C, num, den))

"""
The extended euclid algorithm for polynomials (of the same concrete subtype).
"""
function extended_euclid_alg(::Type{C}, f::P, g::P) where {C, D, P <: Polynomial{C, D}}
    return ext_euclid_alg(f, g, rem, div)
end

"""
The greatest common divisor of two polynomials (of the same concrete subtype).
"""
gcd(::Type{C}, f::P, g::P) where {C, D, P <: Polynomial{C, D}} = extended_euclid_alg(C, f, g) |> first

"""
Yun's algorithm to compute a square free polynomial.
"""
function square_free(::Type{C}, f::P) where {C, D, P <: Polynomial{C, D}}
    min_deg = last(f).degree
    vt = filter(t -> !iszero(t), collect(f))
    f = P( map(t -> Term(t.coeff, t.degree - min_deg), vt) )

    der_f = derivative(f)
    sqr_part = gcd(C, f, der_f)

    iszero(sqr_part) && return f * (min_deg > zero(min_deg) ? x_poly(P) : one(P))

    sqr_free = div(C, f, sqr_part)

    if min_deg > zero(min_deg) 
        sqr_free *= x_poly(P)
    end

    return sqr_free
end

"""
Compute the number of times g divides f.
"""
function multiplicity(::Type{C}, f::P, g::P)::Integer where {C, D, P <: Polynomial{C, D}}
    degree(gcd(C, f, g)) == 0 && return 0
    return 1 + multiplicity(C, div(C, f, g), g)
end

"""
Convert polynomial with Int/BigInt coefficients to ZModP coefficients
"""
function to_mod_p(p::Polynomial{C, D}, prime::Int) where {C <: Integer, D}
    # Determine polynomial type
    if typeof(p) <: PolynomialDense
        P_mod = PolynomialDense{ZModP{C, prime}, D}
    elseif typeof(p) <: PolynomialSparse
        P_mod = PolynomialSparse{ZModP{C, prime}, D}
    else
        error("Unknown polynomial type")
    end
    
    terms_mod = [Term(ZModP(t.coeff, Val(prime)), t.degree) for t in p]
    return P_mod(terms_mod)
end

"""
Convert polynomial with ZModP coefficients back to Int/BigInt coefficients
"""
function from_mod_p(p::Polynomial{ZModP{T, N}, D}) where {T <: Integer, N, D}
    # Determine polynomial type
    if typeof(p) <: PolynomialDense
        P_int = PolynomialDense{T, D}
    elseif typeof(p) <: PolynomialSparse
        P_int = PolynomialSparse{T, D}
    else
        error("Unknown polynomial type")
    end
    
    terms_int = [Term(T(t.coeff), t.degree) for t in p]
    return P_int(terms_int)
end