#############################################################################
#############################################################################
#
# This file implements polynomial division for abstract polynomials.
#                                                                               
#############################################################################
#############################################################################

function div_rem_mod_p(num::P, den::P, prime::Int)::Tuple{P, P} where {C <: Integer, D, P <: Polynomial{C, D}}
    num_mod = to_mod_p(num, prime)
    den_mod = to_mod_p(den, prime)
    q_mod, r_mod = div_rem(ZModP{C, prime}, num_mod, den_mod)
    return from_mod_p(q_mod), from_mod_p(r_mod)
end

div_mod_p(num::P, den::P, prime::Integer) where {C, D, P <: Polynomial{C, D}} = first(div_rem_mod_p(num, den, prime))

rem_mod_p(num::P, den::P, prime::Integer) where {C, D, P <: Polynomial{C, D}} = last(div_rem_mod_p(num, den, prime))