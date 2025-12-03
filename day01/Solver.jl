module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    pdata = []
    for line in eachline(IOBuffer(raw_data))
        dir = line[1] == 'L' ? -1 : 1   
        push!(pdata, (dir, parse(Int, line[2:end])))
    end
    pdata
end
export parse_input


function solve1(parsed)
    dial = 50
    println(parsed)
    zero_counts = 0
    for (dir, step) in parsed
        #@show dir step dial
        dial = (dial + dir*step) % 100
        #@show dial
        iszero(dial % 100) && (zero_counts += 1)
        #@show zero_counts
    end
    zero_counts
end
export solve1


function solve2(parsed)
    dial = 50
    zero_counts = 0
    for (dir, step) in parsed
        for i in 1:step
            dial += dir
            if dial > 99
                dial -= 100
            elseif dial < 0
                dial += 100
            end
            if dial == 0
                zero_counts += 1
            end
        end
    end
    zero_counts
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
"""
testanswer_1 = 3
testanswer_2 = 6
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
