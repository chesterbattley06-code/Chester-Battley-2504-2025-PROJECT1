#############################################################################
#############################################################################
#
# This file implements polynomial multiplication for sparse polynomials.
#                                                                               
#############################################################################
#############################################################################

# Optimized term multiplication for sparse
function *(t::Term{C, D}, p::PolynomialSparse{C, D})::PolynomialSparse{C, D} where {C, D}
    iszero(t) && return PolynomialSparse{C, D}()
    terms = [t * pt for pt in p.terms]
    return PolynomialSparse{C, D}(terms)
end

# Optimized polynomial multiplication for sparse
function *(p1::PolynomialSparse{C, D}, p2::PolynomialSparse{C, D})::PolynomialSparse{C, D} where {C, D}
    iszero(p1) || iszero(p2) && return PolynomialSparse{C, D}()
    
    # Accumulate terms by degree
    degree_map = Dict{D, C}()
    
    for t1 in p1.terms
        for t2 in p2.terms
            prod = t1 * t2
            deg = prod.degree
            degree_map[deg] = get(degree_map, deg, zero(C)) + prod.coeff
        end
    end
    
    # Convert to term vector, filtering zeros
    terms = [Term(coeff, deg) for (deg, coeff) in degree_map if !iszero(coeff)]
    
    return PolynomialSparse{C, D}(terms)
end