#############################################################################
#############################################################################
#
# This file implements integers modulo a prime (ℤp)
#                                                                               
#############################################################################
#############################################################################

using Primes

# Import functions we're extending
import Base: +, -, *, ÷, ^, abs, zero, one, show, ==

struct ZModP{T <: Integer, N} <: Integer
    val::T
    
    function ZModP{T, N}(a::T) where {T <: Integer, N}
        isprime(N) || error("N must be prime, got N = $N")
        new{T, N}(mod(a, N))
    end
end

# Outer constructors
function ZModP(a::T, ::Val{N})::ZModP{T, N} where {T <: Integer, N}
    return ZModP{T, N}(a)
end

function zero(::Type{ZModP{T, N}})::ZModP{T, N} where {T <: Integer, N}
    return ZModP{T, N}(zero(T))
end

function one(::Type{ZModP{T, N}})::ZModP{T, N} where {T <: Integer, N}
    return ZModP{T, N}(one(T))
end

function zero(a::ZModP{T, N})::ZModP{T, N} where {T <: Integer, N}
    return zero(ZModP{T, N})
end

function one(a::ZModP{T, N})::ZModP{T, N} where {T <: Integer, N}
    return one(ZModP{T, N})
end

# Display
function show(io::IO, a::ZModP{T, N}) where {T <: Integer, N}
    print(io, a.val)
end

# Equality
function ==(a::ZModP{T, N}, b::ZModP{T, N})::Bool where {T <: Integer, N}
    return a.val == b.val
end

function ==(a::ZModP{T, N}, b::S)::Bool where {T <: Integer, S <: Integer, N}
    return a.val == mod(b, N)
end

function ==(a::S, b::ZModP{T, N})::Bool where {T <: Integer, S <: Integer, N}
    return mod(a, N) == b.val
end

# Arithmetic operations
function +(a::ZModP{T, N}, b::ZModP{T, N}) where {T <: Integer, N}
    return ZModP{T, N}(a.val + b.val)
end

function +(a::ZModP{T, N}, b::S) where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(a.val + b)
end

function +(a::S, b::ZModP{T, N}) where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(a + b.val)
end

function -(a::ZModP{T, N}) where {T <: Integer, N}
    return ZModP{T, N}(-a.val)
end

function -(a::ZModP{T, N}, b::ZModP{T, N}) where {T <: Integer, N}
    return ZModP{T, N}(a.val - b.val)
end

function -(a::ZModP{T, N}, b::S) where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(a.val - b)
end

function -(a::S, b::ZModP{T, N}) where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(a - b.val)
end

function *(a::ZModP{T, N}, b::ZModP{T, N}) where {T <: Integer, N}
    return ZModP{T, N}(a.val * b.val)
end

function *(a::ZModP{T, N}, b::S) where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(a.val * b)
end

function *(a::S, b::ZModP{T, N}) where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(a * b.val)
end

function inv(a::ZModP{T, N})::ZModP{T, N} where {T <: Integer, N}
    return ZModP{T, N}(int_inverse_mod(a.val, N))
end

function ÷(a::ZModP{T, N}, b::ZModP{T, N})::ZModP{T, N} where {T <: Integer, N}
    return a * inv(b)
end

function ÷(a::ZModP{T, N}, b::S)::ZModP{T, N} where {T <: Integer, S <: Integer, N}
    return a * inv(ZModP{T, N}(b))
end

function ÷(a::S, b::ZModP{T, N})::ZModP{T, N} where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(a) * inv(b)
end

function ^(a::ZModP{T, N}, n::S) where {T <: Integer, S <: Integer, N}
    return ZModP{T, N}(powermod(a.val, n, N))
end

function abs(a::ZModP{T, N})::ZModP{T, N} where {T <: Integer, N}
    return a
end

# Conversion to Int/BigInt
function Base.Int(a::ZModP{T, N})::Int where {T <: Integer, N}
    return Int(a.val)
end

function Base.BigInt(a::ZModP{T, N})::BigInt where {T <: Integer, N}
    return BigInt(a.val)
end