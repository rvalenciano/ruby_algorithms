
# Input: Given an array of integers
# Output: Output each integer in the array and all the other integers in the array that are factors of the first integer.

# Example:

# Given an array of [10, 5, 2, 20], the output would be:
# { 10: [5, 2], 5: [], 2: [], 20: [10,5,2] }

def factors(integers)
  integers.each_with_object({}) do |element, result|
    result[element] = num_factors(element, integers - [element])
    hash
  end
end

# Public: Give the factors of a number present in an array.
#
# elem  - number to be searching factors of.
# array - The array of integers of where to search factors.
#
# Examples
#
#   num_factors(10, [5, 2, 20])
#   # => [5, 2]
#
# Returns an array with the numbers that are a factor.
def num_factors(elem, rest)
  rest.select { |n| (elem % n).zero? }
end

# Test

result = factors([10, 5, 2, 20])
puts result.inspect