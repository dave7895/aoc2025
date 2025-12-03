module Solver
using Test
using AoC
using AoC.Utils
using ProgressMeter

function parse_input(raw_data)
    stringvec = split.(split(raw_data, "\n"; keepempty=false), "")
    stringvec
end
export parse_input


function solve1(parsed)
    sum = 0
    for bank in parsed
        best_jolt = 0
        for b1 in 1:lastindex(bank)-1
            for b2 in b1+1:lastindex(bank)
                val = parse(Int, bank[b1]*bank[b2])
                if val > best_jolt
                    best_jolt = val
                end
            end
        end
        sum += best_jolt
        println("found best_jolt $best_jolt for bank $bank")
    end
    println("sum for naive: $sum")
    sum = 0
    for bank in parsed
        sum += parse(Int, getlargestsub(bank, 2))
    end
    println("sum for brute: $sum")
    sum = 0
    for bank in parsed
        sum += parse(Int, getlargestsub2(bank, 2))
    end
    println("sum for sorted: $sum")
    sum
end
export solve1

function getlargestsub(subbank, l)
    if l == 1
        return string(maximum(parse.(Int, subbank)))
    end
    best_jolt = 0
        for b1 in 1:lastindex(subbank)-1
            val = parse(Int, subbank[b1]*getlargestsub(subbank[b1+1:end], l-1))
                if val > best_jolt
                    best_jolt = val
                end
        end
    return string(best_jolt)
end

function getlargestsub2(subbank, l)
    l == 0 && return ""
    pbank = parse.(Int, subbank)
    m, idx = findmax(pbank)
    maxidx = lastindex(pbank) - l + 1
    if idx < maxidx
        return string(m)*getlargestsub2(subbank[idx+1:end], l-1)
    end
    while idx > maxidx
        m = m - 1
        idx = findfirst(==(m), pbank)
        isnothing(idx) && (idx = Inf)
    end
    return string(m)*getlargestsub2(subbank[idx+1:end], l-1)
end
function solve2(parsed)
    sum = 0
    @showprogress for bank in parsed
        sum += parse(Int, getlargestsub2(bank, 12))
    end
    sum
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
987654321111111
811111111111119
234234234234278
818181911112111
"""
testanswer_1 = 357
testanswer_2 = 3121910778619
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
