#############################################################################
#############################################################################
#
# This file implements polynomial addition for sparse polynomials.
#                                                                               
#############################################################################
#############################################################################

function +(p::PolynomialSparse{C, D}, t::Term{C, D}) where {C, D}
    iszero(t) && return p
    
    # Find if term with same degree exists
    terms = copy(p.terms)
    idx = findfirst(term -> term.degree == t.degree, terms)
    
    if isnothing(idx)
        # Insert new term in sorted order
        idx = findfirst(term -> term.degree < t.degree, terms)
        if isnothing(idx)
            push!(terms, t)
        else
            insert!(terms, idx, t)
        end
    else
        # Add to existing term
        new_term = terms[idx] + t
        if iszero(new_term)
            deleteat!(terms, idx)
        else
            terms[idx] = new_term
        end
    end
    
    return PolynomialSparse{C, D}(terms)
end