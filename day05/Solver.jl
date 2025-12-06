module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    reading_fresh = true
    freshs = []
    ingredients = Int[]
    for line in eachline(IOBuffer(raw_data))
        if isempty(line)
            reading_fresh = false
            continue
        end
        if reading_fresh
            #thisrange = range(parse.(Int, split(line, '-'))...)
            thisrange = read_range(line)
            push!(freshs, thisrange)
            continue
        else
            push!(ingredients, parse(Int, line))
        end
    end
    ingredients, freshs
end
export parse_input


function solve1(parsed)
    ingredients, freshs = parsed
    sum = 0
    for i in ingredients
        if any(in.(i, freshs))
            sum += 1
        end
    end
    #count(in.(ingredients, (freshs,)))
    sum
end
export solve1

function merge_ranges(r1, r2)
    r = (0,0)
    if length(intersect(r1, r2)) == 0
        return r1, r2
    end
    return range(minimum(first.((r1, r2))), maximum(last.((r1, r2))))
end
    

function solve2(parsed)
    _, freshs = parsed
    originals = deepcopy(freshs)
    sort!(originals; by=first)
    simplified = empty(freshs)
    while !isempty(originals)
        orig = popfirst!(originals)
        if isempty(simplified)
            push!(simplified, orig)
            continue
        end
        merged = false
        for isimpl in eachindex(simplified)
            rsimpl = simplified[isimpl]
            t = merge_ranges(rsimpl, orig)
            if t isa Tuple
                continue
            else
                simplified[isimpl] = t
                merged = true
                break
            end
        end
        merged || push!(simplified, orig)
    end
    sum(length.(simplified))
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
3-5
10-14
16-20
12-18

1
5
8
11
17
32
"""
testanswer_1 = 3
testanswer_2 = 14
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
