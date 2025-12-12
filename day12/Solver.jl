module Solver
using Test
using AoC
using AoC.Utils


function parse_input(raw_data)
    shapes = []
    trees = []
    line_accum = ""
    idx = 0
    at_trees = false
    for line in lines(raw_data)
        if contains(line, 'x')
            at_trees = true
            idx = 1
        end
        if at_trees
            line_ints = ints(line)
            push!(trees, ((line_ints[1:2]...,), line_ints[3:end]))
        else
            if contains(line, ':')
                idx = parse(Int, line[begin:end-1])
                continue
            elseif isempty(line)
                push!(shapes, read_as_matrix(line_accum))
                line_accum = ""
            else
                line_accum = line_accum * line * "\n"
            end
        end
    end
    shapes, trees
end
export parse_input


function solve1(parsed)
end
export solve1


function solve2(parsed)
end
export solve2


solution = Solution(parse_input, solve1, solve2)

testinput = """
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
"""
testanswer_1 = 2
testanswer_2 = nothing
export testinput, testanswer_1, testanswer_2

test() = AoC.test_solution(solution, testinput, testanswer_1, testanswer_2)
export test

main(part=missing) = AoC.main(solution, part)
export main


end # module Solver
