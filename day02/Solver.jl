module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    ranges = split(raw_data, ',')
    tups = split.(ranges, '-')
    jl_ranges = [range(parse.(Int, r)...) for r in tups]
end
export parse_input

function isinvalid(id)
    sid = string(id)
    l = length(sid)
    isodd(l) && return false
    middle = l ÷ 2
    firsth = sid[begin:middle]
    secondh = sid[middle+1:end]
    return firsth == secondh
end

function solve1(parsed)
    sum = 0
    for r in parsed
        for id in r
            if isinvalid(id)
                sum += id
                println("id $id is invalid")
            end
        end
    end
    sum
end
export solve1

function solve2(parsed)
    sum = 0
    rgx = r"^(\d+?)\1+$"
    for r in parsed
        for id in r
            m = match(rgx, string(id))
            isnothing(m) && continue
            println("id $id is invalid, $(m.captures[1]) repeats")
            sum += id
        end
    end
    sum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
"""
testanswer_1 = 1227775554
testanswer_2 = 4174379265
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
