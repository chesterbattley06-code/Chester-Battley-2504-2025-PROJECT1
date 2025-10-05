#############################################################################
#############################################################################
#
# This file defines the `PolynomialDense` type with several operations 
#                                                                               
#############################################################################
#############################################################################

struct PolynomialDense{C, D} <: Polynomial{C, D}
    terms::Vector{Term{C, D}}   
    
    PolynomialDense{C, D}() where {C, D} = new([zero(Term{C, D})])

    function PolynomialDense{C, D}(vt::Vector{Term{C, D}}) where {C, D}
        vt = filter((t)->!iszero(t), vt)
        if isempty(vt)
            vt = [zero(Term{C, D})]
        end

        max_degree = maximum((t)->t.degree, vt)
        terms = [zero(Term{C, D}) for i in 0:max_degree]

        for t in vt
            terms[t.degree + 1] = t
        end
        return new(terms)
    end
end

PolynomialDense(vt::Vector{Term{C, D}}) where {C, D} = PolynomialDense{C, D}(vt)
PolynomialDense(::Type{C}, ::Type{D}) where {C, D} = PolynomialDense{C, D}()

iterate(p::PolynomialDense, state=1) = iterate(p.terms, state)

length(p::PolynomialDense) = length(p.terms) 

function leading(p::PolynomialDense{C, D})::Term{C, D} where {C, D}
    isempty(p.terms) ? zero(Term{C, D}) : last(p.terms) 
end

function last(p::PolynomialDense{C, D}) where {C, D}
    iszero(p) && return leading(p)
    p.terms[findfirst(t -> !iszero(t), p.terms)]
end

function push!(p::PolynomialDense{C, D}, t::Term{C, D}) where {C, D}
    if t.degree < degree(p) || (t.degree == degree(p) && !iszero(p))
        error("Cannot push a term $(t) that is not a new leading term (the polynomial had degree $(degree(p)))")
    elseif iszero(p) && iszero(t.degree)
         p.terms[1] = t
    else
        append!(p.terms, zeros(Term{C, D}, t.degree - degree(p)-1))
        push!(p.terms, t)
    end
    return p        
end

function pop!(p::PolynomialDense{C, D})::Term{C, D} where {C, D}
    popped_term = pop!(p.terms)

    while !isempty(p.terms) && iszero(last(p.terms))
        pop!(p.terms)
    end

    if isempty(p.terms)
        push!(p.terms, zero(Term{C, D}))
    end

    return popped_term
end

==(p1::PolynomialDense{C, D}, p2::PolynomialDense{C, D}) where {C, D} = p1.terms == p2.terms