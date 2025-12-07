module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    raw_data = strip(raw_data)
    lines = split(raw_data, '\n')
    return lines #permutedims([lines...;;])
end
export parse_input


function solve1(parsed)
    lines = split.(parsed, ' ', keepempty=false)
    parsed = permutedims([lines...;;])
    sum = 0
    for col in eachcol(parsed)
        op = last(col) == "*" ? (*) : (+)
        sum += op(parse.(Int, col[begin:end-1])...)
    end
    sum
end
export solve1


function solve2(parsed)
    sum = 0
    ops = (str -> (str == "*" ? (*) : (+))).(split(last(parsed), ' ', keepempty=false))
    num_lines = parsed[begin:end-1]
    n_calc = length(ops)
    current_nums = Int[]
    for idx in length(first(num_lines)):-1:1
        col = [l[idx] for l in num_lines]
        num = tryparse(Int, join(col))
        if isone(idx)
            push!(current_nums, num)
            num = nothing
        end
        if isnothing(num)
            op = ops[n_calc]
            sum += op(current_nums...)
            empty!(current_nums)
            n_calc -= 1
        else
            push!(current_nums, num)
        end
    end
    sum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
"""
testanswer_1 = 4277556
testanswer_2 = 3263827
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
