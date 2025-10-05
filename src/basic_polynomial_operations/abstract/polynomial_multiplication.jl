#############################################################################
#############################################################################
#
# This file implements polynomial multiplication for abstract polynomials.
#                                                                               
#############################################################################
#############################################################################

function *(p1::P, p2::P)::P where {C, D, P <: Polynomial{C, D}}
    p_out = P()
    for t in p1
        new_summand = (t * p2)
        p_out = p_out + new_summand
    end
    return p_out
end

function ^(p::P, n::Integer)::P where {C, D, P <: Polynomial{C, D}}
    n < 0 && error("No negative power")
    out = one(p)
    for _ in 1:n
        out *= p
    end
    return out
end