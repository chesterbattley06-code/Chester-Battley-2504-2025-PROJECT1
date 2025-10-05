#############################################################################
#############################################################################
#
# This file implements polynomial addition for abstract polynomials.
#                                                                               
#############################################################################
#############################################################################

function +(p::Polynomial{C, D}, t::Term{C, D}) where {C, D}
    not_implemented_error(p, "Polynomial + Term")
end
+(t::Term, p::Polynomial) = p + t

function +(p1::P, p2::P)::P where {C, D, P <: Polynomial{C, D}}
    p = deepcopy(p1)
    for t in p2
        p += t
    end
    return p
end

+(p::Polynomial{C, D}, n::Integer) where {C, D} = p + Term(C(n), zero(D))
+(n::Integer, p::Polynomial{C, D}) where {C, D} = p + Term(C(n), zero(D))