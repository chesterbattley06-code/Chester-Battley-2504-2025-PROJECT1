#############################################################################
#############################################################################
#
# This file contains unit tests for ZModP operations
#
#############################################################################
#############################################################################

function test_zmodp_operations(primes::Vector{Int})
    println("Testing ZModP with primes: ", primes)
    
    for prime in primes
        println("  Testing with prime = $prime")
        
        # Test 100 random operations
        for _ in 1:100
            a_int = rand(-10000:10000)
            b_int = rand(-10000:10000)
            
            a = ZModP(a_int, Val(prime))
            b = ZModP(b_int, Val(prime))
            
            # Test addition
            @assert (a + b).val == mod(a_int + b_int, prime)
            
            # Test subtraction
            @assert (a - b).val == mod(a_int - b_int, prime)
            
            # Test multiplication
            @assert (a * b).val == mod(a_int * b_int, prime)
            
            # Test division (if b is not zero mod prime)
            if !iszero(b.val)
                result = a ÷ b
                @assert mod(result.val * b.val, prime) == mod(a.val, prime)
            end
            
            # Test power
            n = rand(0:10)
            @assert (a^n).val == powermod(a_int, n, prime)
            
            # Test mixed operations with integers
            c_int = rand(1:100)
            @assert (a + c_int).val == mod(a_int + c_int, prime)
            @assert (a * c_int).val == mod(a_int * c_int, prime)
        end
    end
    
    println("test_zmodp_operations - PASSED")
end