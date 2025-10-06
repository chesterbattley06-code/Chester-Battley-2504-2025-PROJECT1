#############################################################################
#############################################################################
#
# This file defines the `PolynomialSparse` type with several operations 
#                                                                               
#############################################################################
#############################################################################

"""
A Polynomial type with sparse representation.

This type only stores non-zero terms, ordered by degree using a max heap.
This is efficient for polynomials with many zero coefficients.
"""
struct PolynomialSparse{C, D} <: Polynomial{C, D}
    terms::Vector{Term{C, D}}
    
    PolynomialSparse{C, D}() where {C, D} = new([zero(Term{C, D})])

    function PolynomialSparse{C, D}(vt::Vector{Term{C, D}}) where {C, D}
        # Filter out zero terms
        vt = filter(t -> !iszero(t), vt)
        if isempty(vt)
            return new([zero(Term{C, D})])
        end
        # Sort by degree in descending order
        sort!(vt, by = t -> t.degree, rev = true)
        return new(vt)
    end
end

PolynomialSparse(vt::Vector{Term{C, D}}) where {C, D} = PolynomialSparse{C, D}(vt)
PolynomialSparse(::Type{C}, ::Type{D}) where {C, D} = PolynomialSparse{C, D}()

# Iteration
iterate(p::PolynomialSparse{C, D}, state=1) where {C, D} = iterate(p.terms, state)

# Query functions
length(p::PolynomialSparse) = length(p.terms)

function leading(p::PolynomialSparse{C, D})::Term{C, D} where {C, D}
    isempty(p.terms) ? zero(Term{C, D}) : first(p.terms)
end

function last(p::PolynomialSparse{C, D}) where {C, D}
    iszero(p) && return leading(p)
    Base.last(p.terms)
end

# Push and pop
function push!(p::PolynomialSparse{C, D}, t::Term{C, D}) where {C, D}
    if !iszero(t)
        insert_sorted!(p.terms, t)
    end
    return p
end

function pop!(p::PolynomialSparse{C, D})::Term{C, D} where {C, D}
    isempty(p.terms) && return zero(Term{C, D})
    popfirst!(p.terms)
end

# Helper function to insert in sorted order (descending by degree)
function insert_sorted!(v::Vector{Term{C, D}}, t::Term{C, D}) where {C, D}
    idx = findfirst(term -> term.degree < t.degree, v)
    if isnothing(idx)
        push!(v, t)
    else
        insert!(v, idx, t)
    end
end

# Equality
==(p1::PolynomialSparse{C, D}, p2::PolynomialSparse{C, D}) where {C, D} = p1.terms == p2.terms